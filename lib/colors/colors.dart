import 'package:flutter/widgets.dart';

/// Defines the color palette for the puzzle UI.
abstract class PuzzleColors {
  /// Black
  static const Color black = Color(0xFF000000);

  /// Black 2 (opacity 20%)
  static const Color black2 = Color(0x33000000);

  /// White
  static const Color white = Color(0xFFFFFFFF);

  /// White 2 (opacity 40%)
  static const Color white2 = Color(0x66FFFFFF);

  /// Air primary
  static const Color airPrimary = Color(0xFF94BBE3);

  /// Air secondary
  static const Color airSecondary = Color(0xFFC7DFEB);

  /// Air 90
  static const Color air90 = Color(0xFF5D7791);

  /// Air 50
  static const Color air50 = Color(0xFF5D7791);

  /// Water primary
  static const Color waterPrimary = Color(0xff4986A5);

  /// Water secondary
  static const Color waterSecondary = Color(0xff79CDF1);

  /// Water 90
  static const Color water90 = Color(0xff153649);

  /// Water 50
  static const Color water50 = Color(0xff153649);

  /// Earth primary
  static const Color earthPrimary = Color(0xff057C37);

  /// Earth secondary
  static const Color earthSecondary = Color(0xff61B140);

  /// Earth 90
  static const Color earth90 = Color(0xff233817);

  /// Earth 50
  static const Color earth50 = Color(0xff233817);

  /// Fire primary
  static const Color firePrimary = Color(0xffB2581C);

  /// Fire secondary
  static const Color fireSecondary = Color(0xffF0841F);

  /// Fire 90
  static const Color fire90 = Color(0xff26110E);

  /// Fire 50
  static const Color fire50 = Color(0xff26110E);
}
