import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:smart_light/screens/main_screen.dart';
// ignore: unused_import
import 'package:smart_light/screens/select_color.dart';
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
      debugShowCheckedModeBanner: true,
    );
  }
}