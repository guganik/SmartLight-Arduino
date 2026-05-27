import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_light/screens/main_screen.dart';
import 'package:smart_light/services/ble_service.dart';

class LoadScreen extends StatefulWidget {
  LoadScreen({super.key});

  @override
  _LoadScreenState createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  final BleService bleService = BleService();

  BluetoothDevice? connectedDevice;

  int? hue;
  int? saturation;
  int? brightness;
  bool? powerOn;

  bool bleConnect = false;
  int tries = 0;

  @override
  void initState() {
    super.initState();
    getConnectedDevice();
    bleService.startAutoScan();
  }

  Future<void> getConnectedDevice() async {
    connectedDevice = await bleService.startScan();

    while (
        (hue == null ||
        saturation == null ||
        brightness == null ||
        powerOn == null) &&
        tries < 40) {

      await Future.delayed(Duration(milliseconds: 300));

      tries++;

      powerOn = bleService.powerOn;
      hue = bleService.hue;
      saturation = bleService.saturation;
      brightness = bleService.brightness;
    }

    if (mounted) {
      setState(() {
        bleConnect = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bleConnect && connectedDevice != null) {
        Future.delayed(Duration(milliseconds: 1000));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(
              connectedDevice: connectedDevice!,
              powerOn: powerOn ?? false,
              hue: hue ?? 0,
              saturation: saturation ?? 0,
              brightness: brightness ?? 0,
              currentColorTheme: 'dark',
              currentPowerTheme: (powerOn ?? false) ? 'on' : 'off',
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 77, 77, 77),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(screenWidth > screenHeight ? screenHeight * 0.15 : screenWidth * 0.15),
              child: CircularProgressIndicator(
                strokeWidth: screenWidth > screenHeight ? screenHeight * 0.02 : screenWidth * 0.02,
                strokeAlign: screenWidth > screenHeight ? screenHeight * 0.01 : screenWidth * 0.01,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            Text(
              'Подключаюсь...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            )
          ]
        )
      ),
    );
  }
}