#include <SoftwareSerial.h>
SoftwareSerial softSerial(2, 3);

#define LED_PIN 11
#define LED_NUM 120
#include <FastLED.h>
CRGB leds[LED_NUM];

bool onPower = false;

int global_hue;
int global_saturation = 100;
int global_brightness = 100;

bool isConnected = false;
bool animConnectedDone = false;

String mode = "static";

char cmdBuffer[64];
uint8_t cmdIndex = 0;

unsigned long lastAnimUpdate = 0;
int animSpeed = 20;

float rainbowOffset = 0;
float gradientOffset = 0;
bool flipGradient = false;
float fireLedColor = 0;

void readBluetooth() {
  while (softSerial.available()) {
    char c = softSerial.read();
    if (c == '\n') {
      cmdBuffer[cmdIndex] = '\0';
      cmdIndex = 0;

      handleCommand(String(cmdBuffer));
    } else {
      if (cmdIndex < 63) {
        cmdBuffer[cmdIndex++] = c;
      }
    }
  }
}

void rainbowEffect() {
  for (int i = 0; i < LED_NUM; i++) {
    leds[i].setHSV((int)rainbowOffset, 255, 255);
  }

  FastLED.show();

  rainbowOffset += 1;
  if (rainbowOffset > 255) rainbowOffset = 0;
}

void gradientEffect() {
  uint8_t currentHue = map(global_hue, 0, 360, 0, 255);

  for (int i = 0; i < LED_NUM; i++) {
    leds[i].setHSV((int)gradientOffset, 255, 255);
  }

  FastLED.show();

  if (!flipGradient) gradientOffset += 1;
  else gradientOffset -= 1;

  if (gradientOffset >= currentHue + 20) flipGradient = true;
  if (gradientOffset <= currentHue) flipGradient = false;
}

void fireEffect() {
  uint8_t currentHue = map(global_hue, 0, 360, 0, 255);

  float randomFloat = -2 + ((float)random(0, 1000) / 1000) * 4;
  fireLedColor += randomFloat;
  for (int i = 0; i < LED_NUM; i++) {
    if (fireLedColor <= 0) {fireLedColor = 0;} else if (fireLedColor >= 25) {fireLedColor = 35;}
    leds[i].setHSV((int)fireLedColor, 255, 255);
  }

  FastLED.show();
}

void setColorAnim(int hue, int saturation, int bright) {
  uint8_t h = map(hue, 0, 360, 0, 255);
  uint8_t s = map(saturation, 0, 100, 0, 255);
  uint8_t b = map(bright, 0, 100, 0, 255);

  global_hue = hue;
  global_saturation = saturation;
  global_brightness = bright;

  for (int i = 0; i < LED_NUM; i++) {
    leds[i].setHSV(h, s, b);
  }

  FastLED.show();
}

void setBrightness(int brightness) {
  global_brightness = brightness;

  FastLED.setBrightness(map(brightness, 0, 100, 0, 255));
  FastLED.show();
}

void handleCommand(String cmd) {
  cmd.trim();
  if (cmd == "get_status") {
    softSerial.println("onPower:" + String(onPower));
    softSerial.println("bright:" + String(global_brightness));
    softSerial.println("satur:" + String(global_saturation));
    softSerial.println("hue:" + String(global_hue));

    isConnected = true;
    return;
  }

  if (cmd == "LED_ON") {
    onPower = true;
    setColorAnim(global_hue, global_saturation, global_brightness);
    return;
  }

  if (cmd == "LED_OFF") {
    onPower = false;
    FastLED.clear();
    FastLED.show();
    return;
  }

  if (cmd.startsWith("SetHue:")) {
    global_hue = cmd.substring(7).toInt();
    mode = "static";
    setColorAnim(global_hue, global_saturation, global_brightness);
    return;
  }

  if (cmd.startsWith("set_bright:")) {
    global_brightness = cmd.substring(11).toInt();
    setBrightness(global_brightness);
    return;
  }

  if (cmd.startsWith("set_satur:")) {
    global_saturation = cmd.substring(10).toInt();

    if (mode == "static") {
      setColorAnim(global_hue, global_saturation, global_brightness);
    }

    return;
  }

  if (cmd.startsWith("mode_")) {
    mode = cmd.substring(5);

    if (mode == "static") {
      setColorAnim(global_hue, global_saturation, global_brightness);
    }

    if (mode == "gradient") {
      gradientOffset = map(global_hue, 0, 360, 0, 255);
    }

    if (mode == "warm") {
      global_hue = 20;
      global_saturation = 90;
      setColorAnim(global_hue, global_saturation, global_brightness);
      mode = "static";
    }

    if (mode == "cold") {
      global_hue = 240;
      global_saturation = 10;
      setColorAnim(global_hue, global_saturation, global_brightness);
      mode = "static";
    }
  }
}

void setup() {
  Serial.begin(9600);
  softSerial.begin(9600);

  FastLED.addLeds<WS2812, LED_PIN, GRB>(leds, LED_NUM);

  setColorAnim(120, global_saturation, global_brightness);
  delay(1000);
  FastLED.clear();
  FastLED.show();
  delay(500);
  setColorAnim(120, global_saturation, global_brightness);
  delay(1000);
  FastLED.clear();
  FastLED.show();

  Serial.println("Ready");
}

void loop() {
  readBluetooth();
  if (!isConnected) {
    setColorAnim(200, global_saturation, global_brightness);
    delay(600);
    FastLED.clear();
    FastLED.show();
    delay(400);
    return;
  }

  if (onPower && mode != "static") {
    if (millis() - lastAnimUpdate > animSpeed) {
      lastAnimUpdate = millis();
      if (mode == "rainbow") rainbowEffect();
      if (mode == "gradient") gradientEffect();
      if (mode == "fire") fireEffect();
    }
  }
}