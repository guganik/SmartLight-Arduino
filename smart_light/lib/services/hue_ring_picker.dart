import 'package:flutter/material.dart';

class HueRingPainter extends CustomPainter {
  final double ringWidth;

  HueRingPainter({
    required this.ringWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {

    final Rect rect = Offset.zero & size;

    final SweepGradient sweepGradient = SweepGradient(
      colors: const [
        Colors.red,
        Colors.yellow,
        Colors.green,
        Colors.cyan,
        Colors.blue,
        Colors.purple,
        Colors.red,
      ],
    );

    final Paint paint = Paint()
      ..shader = sweepGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth;

    canvas.drawCircle(
      size.center(Offset.zero),
      size.width / 2 - ringWidth / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}