import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smart_light/services/hue_ring_picker.dart';

// ignore: must_be_immutable
class HueRingPicker extends StatefulWidget {
  final Function(int changedHue) onHueChanged;

  double size;
  double ringSize;
  int hue;

  HueRingPicker({
    super.key,
    required this.size,
    required this.ringSize,
    required this.onHueChanged,
    required this.hue
  });

  @override
  State<HueRingPicker> createState() => _HueRingPickerState();
}

class _HueRingPickerState extends State<HueRingPicker> {
  Offset knobPosition = Offset.zero;

  Timer? throttle;

  @override
  void initState() {
    super.initState();

    updateKnob();
  }

  Future<void> updateKnob() async {
    double radius = widget.size / 2 - widget.ringSize / 2;

    double radians = widget.hue * pi / 180;

    double center = widget.size / 2;

    knobPosition = Offset(
      center + cos(radians) * radius,
      center + sin(radians) * radius,
    );
  }

  void handleTouch(Offset localPosition) {
    double center = widget.size / 2;

    double dx = localPosition.dx - center;
    double dy = localPosition.dy - center;

    double angle = atan2(dy, dx);

    double degrees = angle * 180 / pi;

    if (degrees < 0) {
      degrees += 360;
    }

    setState(() {
      widget.hue = degrees.round();
      updateKnob();
    });
  }

  @override
  Widget build(BuildContext context) {
    updateKnob();
    Color selectedColor = HSVColor.fromAHSV(
      1,
      widget.hue.toDouble(),
      1,
      1,
    ).toColor();

    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: GestureDetector(
          onPanDown: (details) {
            handleTouch(details.localPosition);
            widget.onHueChanged(widget.hue);
          },

          onPanUpdate: (details) => handleTouch(details.localPosition),

          onPanEnd: (details) => widget.onHueChanged(widget.hue),

          onTap: () {},

          child: Stack(
            children: [

              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: HueRingPainter(
                  ringWidth: widget.ringSize,
                ),
              ),

              // КУРСОР
              Positioned(
                left: knobPosition.dx - 12,
                top: knobPosition.dy - 12,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}