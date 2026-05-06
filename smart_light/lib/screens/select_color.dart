import 'package:flutter/material.dart';
import 'package:smart_light/screens/main_screen.dart';
import 'package:smart_light/services/colors.dart';

class SelectColorScreen extends StatefulWidget {
  final String currentColorTheme;
  final String currentPowerTheme;
  final num hue;

  const SelectColorScreen({
    super.key,
    required this.currentColorTheme,
    required this.currentPowerTheme,
    required this.hue
  });

  @override
  _SelectColorScreenState createState() => _SelectColorScreenState();
}

class _SelectColorScreenState extends State<SelectColorScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // widget.currentColorTheme + widget.currentPowerTheme

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: SelectColor(hue: widget.hue).backgroundColors[widget.currentColorTheme + widget.currentPowerTheme],
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              color: SelectColor(hue: widget.hue).selectButtonColors[widget.currentColorTheme + widget.currentPowerTheme]
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap:() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen(
                        hue: widget.hue,
                        currentColorTheme: widget.currentColorTheme,
                        currentPowerTheme: widget.currentPowerTheme,
                      ))
                    );
                  },
                  child: Icon(
                    size: 32,
                    color: SelectColor(hue: widget.hue).fontColors[widget.currentColorTheme + widget.currentPowerTheme],
                    Icons.arrow_back_rounded
                  ),
                ),
                SizedBox(width: 16,),
                Text(
                  'Изменить свет',
                  style: TextStyle(
                    color: SelectColor(hue: widget.hue).fontColors[widget.currentColorTheme + widget.currentPowerTheme],
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16,),
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.topCenter,
            width: screenWidth,
            height: 150,
            decoration: BoxDecoration(
              color: SelectColor(hue: widget.hue).selectButtonColors[widget.currentColorTheme + widget.currentPowerTheme]
            ),
            child: Text(
              'Выбор температуры',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: SelectColor(hue: widget.hue).fontColors[widget.currentColorTheme + widget.currentPowerTheme]
              ),
            ),
          ),
          SizedBox(height: 16,),
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.topCenter,
            width: screenWidth,
            height: 150,
            decoration: BoxDecoration(
              color: SelectColor(hue: widget.hue).selectButtonColors[widget.currentColorTheme + widget.currentPowerTheme]
            ),
            child: Text(
              'Выбор цвета',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: SelectColor(hue: widget.hue).fontColors[widget.currentColorTheme + widget.currentPowerTheme]
              ),
            ),
          ),
          SizedBox(height: 16,),
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.topCenter,
            width: screenWidth,
            height: 150,
            decoration: BoxDecoration(
              color: SelectColor(hue: widget.hue).selectButtonColors[widget.currentColorTheme + widget.currentPowerTheme]
            ),
            child: Text(
              'Выбор яркости',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: SelectColor(hue: widget.hue).fontColors[widget.currentColorTheme + widget.currentPowerTheme]
              ),
            ),
          ),
        ],
      ),
    );
  }
}