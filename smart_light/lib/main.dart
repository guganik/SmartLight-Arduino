import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:smart_light/screens/main_screen.dart';
// ignore: unused_import
import 'screens/load_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Light',
      home: LoadScreen(),
      // home: MainScreen(
      //   currentColorTheme: 'dark',
      //   currentPowerTheme: 'off',
      //   hue: 120,
      //   saturation: 100,
      //   brightness: 100,
      //   powerOn: false,
      //   connectedDevice: null
      // ),
      debugShowCheckedModeBanner: true,
    );
  }
}