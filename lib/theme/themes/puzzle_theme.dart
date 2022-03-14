import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';

abstract class PuzzleTheme extends Equatable {
  const PuzzleTheme();
  String get name;
  bool get hasTimer;
  Color get nameColor;
  Color get titleColor;
  Color get backgroundColorPrimary;
  Color get backgroundColorSecondary;
  Color get defaultColor;
  Color get buttonColor;
  Color get hoverColor;
  Color get pressedColor;
  bool get isLogoColored;
  Color get menuActiveColor;
  Color get menuInactiveColor;
  Color get menuUnderlineColor;
  String get successThemeAsset;
  PuzzleLayoutDelegate get layoutDelegate;
}
