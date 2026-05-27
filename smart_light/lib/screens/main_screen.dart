import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_light/screens/load_screen.dart';
import 'package:smart_light/services/ble_service.dart';
import 'package:smart_light/widgets/hue_ping_picker.dart';
import 'package:smart_light/services/colors.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_light/widgets/mode_button_widget.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  String currentColorTheme;
  String currentPowerTheme;
  int hue;
  int saturation;
  int brightness;
  bool powerOn;

  BluetoothDevice? connectedDevice;

  MainScreen({
    super.key,
    required this.currentColorTheme,
    required this.currentPowerTheme,
    required this.hue,
    required this.saturation,
    required this.brightness,
    required this.powerOn,
    required this.connectedDevice,
  });

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String switchTheme = 'assets/icons/sun.svg';
  String gradientIcon = 'assets/icons/gradient.svg';
  String rainbowIcon = 'assets/icons/rainbow.svg';

  String activeMode = 'static';

  final BleService bleService = BleService();

  @override
  void initState() {
    super.initState();
    _initAll();

    bleService.onDeviceDisconnected = () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoadScreen()
        ),
      );
    };
  }

  Future<void> _initAll() async {
    await bleService.checkPermissionsAndGetDevices();
  }

  @override
  void dispose() {
    widget.connectedDevice!.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    String currentTheme = widget.currentColorTheme + widget.currentPowerTheme;
    
    return Scaffold(
      backgroundColor: SelectColor(
        hue: widget.hue,
        saturation: widget.saturation,
        brightness: widget.brightness
      ).backgroundColors[currentTheme],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (widget.currentColorTheme == 'light') {
                        widget.currentColorTheme = 'dark';
                        switchTheme = 'assets/icons/sun.svg';
                      } else {
                        widget.currentColorTheme = 'light';
                        switchTheme = 'assets/icons/moon.svg';
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 20, right: 20),
                    child: SvgPicture.asset(
                      switchTheme,
                      width: 52,
                      height: 52,
                      color: SelectColor(
                        hue: widget.hue,
                        saturation: widget.saturation,
                        brightness: widget.brightness
                      ).iconColors[currentTheme],
                    )
                  )
                ),
              ],
            ),
            Row(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (widget.powerOn) {
                      bleService.sendCommand(widget.connectedDevice!, 'LED_OFF');
                    } else {
                      bleService.sendCommand(widget.connectedDevice!, 'LED_ON');
                    }
                    setState(() {
                      widget.powerOn = !widget.powerOn;
                      if (widget.powerOn) {
                        widget.currentPowerTheme = 'on';
                      } else {
                        widget.currentPowerTheme = 'off';
                      }
                    });
                  },
                  child: Stack(
                    alignment: AlignmentGeometry.center,
                    children: [
                      widget.powerOn && activeMode == 'static'
                      ? HueRingPicker(
                        onHueChanged: (changedHue) {
                          setState(() {
                            widget.hue = changedHue;
                          });
                          bleService.sendCommand(widget.connectedDevice!, "SetHue:${widget.hue}");
                        },
                        hue: widget.hue,
                        size: screenWidth < screenHeight ? screenWidth * 0.6 + (screenWidth * 0.6 + 60) / 6 : screenHeight * 0.4 + (screenHeight * 0.4 + 60) / 6,
                        ringSize: screenWidth < screenHeight ? (screenWidth * 0.6 + 60) / 12 : (screenHeight * 0.4 + 60) / 12,
                      )
                      : SizedBox(
                        height: screenWidth < screenHeight ? screenWidth * 0.6 + (screenWidth * 0.6 + 60) / 6 : screenHeight * 0.4 + (screenHeight * 0.4 + 60) / 6,
                      ),
                      Container(
                        width: screenWidth < screenHeight ? screenWidth * 0.6 : screenHeight * 0.4,
                        height: screenWidth < screenHeight ? screenWidth * 0.6 : screenHeight * 0.4,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              SelectColor(
                                hue: widget.hue,
                                saturation: widget.saturation,
                                brightness: widget.brightness
                              ).buttonColors[currentTheme]!,
                              SelectColor(
                                hue: widget.hue,
                                saturation: widget.saturation,
                                brightness: widget.brightness
                              ).buttonColors[currentTheme]!,
                              SelectColor(
                                hue: widget.hue,
                                saturation: widget.saturation,
                                brightness: widget.brightness
                              ).buttonColorsPlus[currentTheme]!,
                              SelectColor(
                                hue: widget.hue,
                                saturation: widget.saturation,
                                brightness: widget.brightness
                              ).buttonColorsPlus[currentTheme]!,
                            ],
                            stops: [
                              0,
                              0.8,
                              1,
                              1
                            ]
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: SelectColor(
                                hue: widget.hue,
                                saturation: widget.saturation,
                                brightness: widget.brightness
                              ).shadowColors[currentTheme]!,
                              blurRadius: 100,
                            )
                          ]
                        ),
                      ),
                      Icon(
                        Icons.power_settings_new_rounded,
                        size: screenWidth < screenHeight ? screenWidth * 0.3 : screenHeight * 0.2,
                        color: SelectColor(
                          hue: widget.hue,
                          saturation: widget.saturation,
                          brightness: widget.brightness
                        ).buttonUIColors[currentTheme],
                      )
                    ],
                  ),
                ),
                Spacer(),
              ]
            ),
            SizedBox(height: 16,),
            widget.powerOn
            ? Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    SizedBox(
                      width: screenWidth < screenHeight ? screenWidth * 0.8 : screenHeight * 0.5,
                      child: Slider(
                        min: 0,
                        max: 100,
                        activeColor: HSVColor.fromAHSV(1, widget.hue.toDouble(), 0, widget.brightness / 100).toColor(),
                        value: widget.brightness.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            widget.brightness = value.round();
                          });
                        },
                        onChangeEnd: (value) {bleService.sendCommand(widget.connectedDevice!, 'set_bright:${widget.brightness}\n');},
                      ),
                    ),
                    Spacer(),
                  ]
                ),
                activeMode == 'static'
                ? Row(
                  children: [
                    Spacer(),
                    SizedBox(
                      width: screenWidth < screenHeight ? screenWidth * 0.8 : screenHeight * 0.5,
                      child: Slider(
                        min: 0,
                        max: 100,
                        activeColor: HSVColor.fromAHSV(1, widget.hue.toDouble(), widget.saturation / 100, 1).toColor(),
                        value: widget.saturation.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            widget.saturation = value.round();
                          });
                        },
                        onChangeEnd: (value) {bleService.sendCommand(widget.connectedDevice!, 'set_satur:${widget.saturation}\n');}
                      ),
                    ),
                    Spacer(),
                  ]
                )
                : SizedBox(),
              ],
            )
            : SizedBox(),
            Spacer(),
            widget.powerOn
            ? Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    ModeButton(
                      changeMode: () {
                        bleService.sendCommand(widget.connectedDevice!, 'mode_static');
                        bleService.sendCommand(widget.connectedDevice!, 'SetHue:${widget.hue}');
                        bleService.sendCommand(widget.connectedDevice!, 'set_satur:${widget.saturation}');
                        bleService.sendCommand(widget.connectedDevice!, 'set_bright:${widget.brightness}');
                        setState(() {
                          activeMode = 'static';
                        });
                      }, // Статика
                      icon: Icon(Icons.refresh_rounded, color: Colors.grey[600],),
                      background: activeMode == 'static' ? Colors.white : const Color.fromARGB(60, 158, 158, 158)
                    ),
                    Spacer(),
                    ModeButton(
                      changeMode: () {
                        bleService.sendCommand(widget.connectedDevice!, 'mode_warm');
                        setState(() {
                          activeMode = 'warm';
                        });
                      }, // Статика
                      icon: Icon(Icons.sunny, color: Colors.grey[600],),
                      background: activeMode == 'warm' ? Colors.white : const Color.fromARGB(60, 158, 158, 158)
                    ),
                    Spacer(),
                    ModeButton(
                      changeMode: () {
                        bleService.sendCommand(widget.connectedDevice!, 'mode_cold');
                        setState(() {
                          activeMode = 'cold';
                        });
                      }, // Статика
                      icon: Icon(Icons.ac_unit_rounded, color: Colors.grey[600],),
                      background: activeMode == 'cold' ? Colors.white : const Color.fromARGB(60, 158, 158, 158)
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 16,),
                Row(
                  children: [
                    Spacer(),
                    ModeButton(
                      changeMode: () {
                        bleService.sendCommand(widget.connectedDevice!, 'mode_fire');
                        setState(() {
                          activeMode = 'fire';
                        });
                      }, // Эффект пламени
                      icon: Icon(Icons.whatshot, color: Colors.grey[600]),
                      background: activeMode == 'fire' ? Colors.white : const Color.fromARGB(60, 158, 158, 158),
                    ),
                    Spacer(),
                    ModeButton(
                      changeMode: () {
                        bleService.sendCommand(widget.connectedDevice!, 'mode_gradient');
                        setState(() {
                          activeMode = 'gradient';
                        });
                      }, // Двигающийся градиент
                      icon: SvgPicture.asset(
                        gradientIcon,
                        width: 25,
                        height: 25,
                        color: Colors.grey[600]
                      ),
                      background: activeMode == 'gradient' ? Colors.white : const Color.fromARGB(60, 158, 158, 158),
                    ),
                    Spacer(),
                    ModeButton(
                      changeMode: () {
                        bleService.sendCommand(widget.connectedDevice!, 'mode_rainbow');
                        setState(() {
                          activeMode = 'rainbow';
                        });
                      }, // Радуга
                      icon: SvgPicture.asset(
                        rainbowIcon,
                        width: 25,
                        height: 25,
                        color: Colors.grey[600]
                      ),
                      background: activeMode == 'rainbow' ? Colors.white : const Color.fromARGB(60, 158, 158, 158),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  children: [],
                ),
              ],
            )
            : SizedBox(),
            Text(
              widget.connectedDevice != null ? 'Подключено к ${widget.connectedDevice!.platformName}' : 'Тестовый запуск',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16,),
          ]
        )
      )
    );
  }
}