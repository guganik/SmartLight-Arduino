import 'package:flutter/material.dart';
import 'package:smart_light/screens/main_screen.dart';

class LoadScreen extends StatelessWidget {
  const LoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    Future.delayed(Duration(milliseconds: 100), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(
          hue: 120,
          currentColorTheme: 'dark',
          currentPowerTheme: 'off',
        ))
      );
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
              'Пару секунд...',
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