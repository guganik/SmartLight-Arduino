import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_light/services/colors.dart';

class ModeButton extends StatelessWidget {
  Widget icon;

  VoidCallback changeMode;

  Color? background;

  ModeButton({
    super.key,
    required this.icon,
    required this.changeMode,
    required this.background
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: changeMode,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(10)
          ),
        ),
        child: Center(child: icon,)
      )
    );
  }
}