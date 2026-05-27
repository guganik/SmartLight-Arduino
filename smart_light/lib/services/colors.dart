import 'package:color_models/color_models.dart';
import 'package:flutter/material.dart';

class SelectColor {
  final num hue;
  final int saturation;
  final int brightness;
  SelectColor({
    required this.hue,
    required this.saturation,
    required this.brightness,
  });

  final RgbColor lightOffBG_RGB = HsbColor(0, 0, 100).toRgbColor();
  late final RgbColor lightOnBG_RGB = HsbColor(hue, 15, 100).toRgbColor();
  final RgbColor darkOffBG_RGB = HsbColor(0, 0, 35).toRgbColor();
  late final RgbColor darkOnBG_RGB = HsbColor(hue, 60, 35).toRgbColor();

  Map<String, Color> get backgroundColors => {
    'lightoff': Color.fromRGBO(lightOffBG_RGB.red, lightOffBG_RGB.green, lightOffBG_RGB.blue, 1),
    'lighton': Color.fromRGBO(lightOnBG_RGB.red, lightOnBG_RGB.green, lightOnBG_RGB.blue, 1),
    'darkoff': Color.fromRGBO(darkOffBG_RGB.red, darkOffBG_RGB.green, darkOffBG_RGB.blue, 1),
    'darkon': Color.fromRGBO(darkOnBG_RGB.red, darkOnBG_RGB.green, darkOnBG_RGB.blue, 1),
  };

  final RgbColor lightOffIcon_RGB = HsbColor(0, 0, 70).toRgbColor();
  late final RgbColor lightOnIcon_RGB = HsbColor(hue, 50, 70).toRgbColor();
  final RgbColor darkOffIcon_RGB = HsbColor(0, 0, 70).toRgbColor();
  late final RgbColor darkOnIcon_RGB = HsbColor(hue, 50, 70).toRgbColor();

  Map<String, Color> get iconColors => {
    'lightoff': Color.fromRGBO(lightOffIcon_RGB.red, lightOffIcon_RGB.green, lightOffIcon_RGB.blue, 1),
    'lighton': Color.fromRGBO(lightOnIcon_RGB.red, lightOnIcon_RGB.green, lightOnIcon_RGB.blue, 1),
    'darkoff': Color.fromRGBO(darkOffIcon_RGB.red, darkOffIcon_RGB.green, darkOffIcon_RGB.blue, 1),
    'darkon': Color.fromRGBO(darkOnIcon_RGB.red, darkOnIcon_RGB.green, darkOnIcon_RGB.blue, 1),
  };

  final RgbColor lightOffButton_RGB = HsbColor(0, 0, 100).toRgbColor();
  late final RgbColor lightOnButton_RGB = HsbColor(hue, 30, 100).toRgbColor();
  final RgbColor darkOffButton_RGB = HsbColor(0, 0, 100).toRgbColor();
  late final RgbColor darkOnButton_RGB = HsbColor(hue, 60, 35).toRgbColor();

  Map<String, Color> get buttonColors => {
    'lightoff': Color.fromRGBO(lightOffButton_RGB.red, lightOffButton_RGB.green, lightOffButton_RGB.blue, 1),
    'lighton': Color.fromRGBO(lightOnButton_RGB.red, lightOnButton_RGB.green, lightOnButton_RGB.blue, 1),
    'darkoff': Color.fromRGBO(darkOffButton_RGB.red, darkOffButton_RGB.green, darkOffButton_RGB.blue, 1),
    'darkon': Color.fromRGBO(darkOnButton_RGB.red, darkOnButton_RGB.green, darkOnButton_RGB.blue, 1),
  };

  final RgbColor lightOffButtonPlus_RGB = HsbColor(0, 0, 60).toRgbColor();
  late final RgbColor lightOnButtonPlus_RGB = HsbColor(hue, 80, 100).toRgbColor();
  final RgbColor darkOffButtonPlus_RGB = HsbColor(0, 0, 60).toRgbColor();
  late final RgbColor darkOnButtonPlus_RGB = HsbColor(hue, 80, 60).toRgbColor();

  Map<String, Color> get buttonColorsPlus => {
    'lightoff': Color.fromRGBO(lightOffButtonPlus_RGB.red, lightOffButtonPlus_RGB.green, lightOffButtonPlus_RGB.blue, 1),
    'lighton': Color.fromRGBO(lightOnButtonPlus_RGB.red, lightOnButtonPlus_RGB.green, lightOnButtonPlus_RGB.blue, 1),
    'darkoff': Color.fromRGBO(darkOffButtonPlus_RGB.red, darkOffButtonPlus_RGB.green, darkOffButtonPlus_RGB.blue, 1),
    'darkon': Color.fromRGBO(darkOnButtonPlus_RGB.red, darkOnButtonPlus_RGB.green, darkOnButtonPlus_RGB.blue, 1),
  };

  final RgbColor lightOffButtonUI_RGB = HsbColor(0, 0, 50).toRgbColor();
  late final RgbColor lightOnButtonUI_RGB = HsbColor(hue, 100, 70).toRgbColor();
  final RgbColor darkOffButtonUI_RGB = HsbColor(0, 0, 50).toRgbColor();
  late final RgbColor darkOnButtonUI_RGB = HsbColor(hue, 80, 100).toRgbColor();

  Map<String, Color> get buttonUIColors => {
    'lightoff': Color.fromRGBO(lightOffButtonUI_RGB.red, lightOffButtonUI_RGB.green, lightOffButtonUI_RGB.blue, 1),
    'lighton': Color.fromRGBO(lightOnButtonUI_RGB.red, lightOnButtonUI_RGB.green, lightOnButtonUI_RGB.blue, 1),
    'darkoff': Color.fromRGBO(darkOffButtonUI_RGB.red, darkOffButtonUI_RGB.green, darkOffButtonUI_RGB.blue, 1),
    'darkon': Color.fromRGBO(darkOnButtonUI_RGB.red, darkOnButtonUI_RGB.green, darkOnButtonUI_RGB.blue, 1),
  };

  final RgbColor lightOffShadow_RGB = HsbColor(0, 0, 70).toRgbColor();
  late final RgbColor lightOnShadow_RGB = HsbColor(hue, 80, 70).toRgbColor();
  final RgbColor darkOffShadow_RGB = HsbColor(0, 0, 100).toRgbColor();
  late final RgbColor darkOnShadow_RGB = HsbColor(hue, 80, 70).toRgbColor();

  Map<String, Color> get shadowColors => {
    'lightoff': Color.fromRGBO(lightOffShadow_RGB.red, lightOffShadow_RGB.green, lightOffShadow_RGB.blue, 1),
    'lighton': Color.fromRGBO(lightOnShadow_RGB.red, lightOnShadow_RGB.green, lightOnShadow_RGB.blue, 1),
    'darkoff': Color.fromRGBO(darkOffShadow_RGB.red, darkOffShadow_RGB.green, darkOffShadow_RGB.blue, 1),
    'darkon': Color.fromRGBO(darkOnShadow_RGB.red, darkOnShadow_RGB.green, darkOnShadow_RGB.blue, 1),
  };

  final RgbColor lightOfffont_RGB = HsbColor(0, 0, 30).toRgbColor();
  late final RgbColor lightOnfont_RGB = HsbColor(hue, 10, 30).toRgbColor();
  final RgbColor darkOfffont_RGB = HsbColor(0, 0, 100).toRgbColor();
  late final RgbColor darkOnfont_RGB = HsbColor(hue, 10, 100).toRgbColor();

  Map<String, Color> get fontColors => {
    'lightoff': Color.fromRGBO(lightOfffont_RGB.red, lightOfffont_RGB.green, lightOfffont_RGB.blue, 1),
    'lighton': Color.fromRGBO(lightOnfont_RGB.red, lightOnfont_RGB.green, lightOnfont_RGB.blue, 1),
    'darkoff': Color.fromRGBO(darkOfffont_RGB.red, darkOfffont_RGB.green, darkOfffont_RGB.blue, 1),
    'darkon': Color.fromRGBO(darkOnfont_RGB.red, darkOnfont_RGB.green, darkOnfont_RGB.blue, 1),
  };

  final RgbColor lightOffselectButton_RGB = HsbColor(0, 0, 100).toRgbColor();
  final RgbColor lightOnselectButton_RGB = HsbColor(0, 0, 100).toRgbColor();
  final RgbColor darkOffselectButton_RGB = HsbColor(0, 0, 50).toRgbColor();
  final RgbColor darkOnselectButton_RGB = HsbColor(0, 0, 100).toRgbColor();

  Map<String, Color> get selectButtonColors => {
    'lightoff': Color.fromRGBO(lightOffselectButton_RGB.red, lightOffselectButton_RGB.green, lightOffselectButton_RGB.blue, 1),
    'lighton': Color.fromRGBO(lightOnselectButton_RGB.red, lightOnselectButton_RGB.green, lightOnselectButton_RGB.blue, 1),
    'darkoff': Color.fromRGBO(darkOffselectButton_RGB.red, darkOffselectButton_RGB.green, darkOffselectButton_RGB.blue, 1),
    'darkon': Color.fromRGBO(darkOnselectButton_RGB.red, darkOnselectButton_RGB.green, darkOnselectButton_RGB.blue, 1),
  };
}