import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sac_slide_puzzle/colors/colors.dart';
import 'package:sac_slide_puzzle/typography/typography.dart';

class PuzzleTextStyle {
//head
  static TextStyle get headline {
    return _baseTextStyle.copyWith(
      fontSize: 34,
      height: 1.12,
      fontWeight: PuzzleFontWeight.bold,
    );
  }

  //button
  static TextStyle get text {
    return _baseTextStyle.copyWith(
      fontSize: 16,
      height: 1.25,
      fontWeight: PuzzleFontWeight.bold,
    );
  }

  //body
  static TextStyle get bodyText {
    return _baseTextStyle.copyWith(
      fontSize: 14,
      height: 1.25,
      fontWeight: PuzzleFontWeight.light,
    );
  }

  //scoreCard
  static TextStyle get labelText {
    return _baseTextStyle.copyWith(
      fontSize: 12,
      height: 1.25,
      fontWeight: PuzzleFontWeight.light,
    );
  }

  //name
  static TextStyle get bodyHigh {
    return _bodyTextStyle.copyWith(
      fontSize: 16,
      height: 1.33,
      fontWeight: PuzzleFontWeight.regular,
    );
  }

  static TextStyle get headline4 {
    return _baseTextStyle.copyWith(
      fontSize: 24,
      height: 1.15,
      fontWeight: PuzzleFontWeight.bold,
    );
  }

  static TextStyle get headline4Soft {
    return _baseTextStyle.copyWith(
      fontSize: 24,
      height: 1.15,
      fontWeight: PuzzleFontWeight.regular,
    );
  }

  static TextStyle get body {
    return _bodyTextStyle.copyWith(
      fontSize: 24,
      height: 1.33,
      fontWeight: PuzzleFontWeight.regular,
    );
  }

  static TextStyle get bodySmall {
    return _bodyTextStyle.copyWith(
      fontSize: 18,
      height: 1.22,
      fontWeight: PuzzleFontWeight.regular,
    );
  }

  static TextStyle get bodyXSmall {
    return _bodyTextStyle.copyWith(
      fontSize: 14,
      height: 1.27,
      fontWeight: PuzzleFontWeight.regular,
    );
  }

  static TextStyle get label {
    return _baseTextStyle.copyWith(
      fontSize: 14,
      height: 1.27,
      fontWeight: PuzzleFontWeight.regular,
    );
  }

  static TextStyle get countdownTime {
    return _baseTextStyle.copyWith(
      fontSize: 300,
      height: 1,
      fontWeight: PuzzleFontWeight.bold,
    );
  }

  static const _baseTextStyle = TextStyle(
    fontFamily: 'BalsamiqSans',
    color: PuzzleColors.white,
    fontWeight: PuzzleFontWeight.regular,
  );

  static final _bodyTextStyle = GoogleFonts.balsamiqSans(
    color: PuzzleColors.white,
    fontWeight: PuzzleFontWeight.regular,
  );
}
