import 'package:flutter/material.dart';
import 'package:sac_slide_puzzle/colors/colors.dart';
import 'package:sac_slide_puzzle/l10n/l10n.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/theme/themes/themes.dart';

class SacTheme extends PuzzleTheme {
  const SacTheme() : super();
  @override
  Color get backgroundColorPrimary => PuzzleColors.white;

  @override
  Color get backgroundColorSecondary => PuzzleColors.white;

  @override
  Color get defaultColor => PuzzleColors.black;

  @override
  Color get nameColor => PuzzleColors.white;

  @override
  get titleColor => PuzzleColors.white;

  @override
  bool get hasTimer => false;

  @override
  Color get hoverColor => PuzzleColors.black2;

  @override
  PuzzleLayoutDelegate get layoutDelegate => const ScoreLayoutDelegate();

  @override
  String get name => 'Score';

  @override
  Color get pressedColor => PuzzleColors.black;

  @override
  Color get menuActiveColor => PuzzleColors.white;

  @override
  Color get menuInactiveColor => PuzzleColors.black;

  @override
  Color get menuUnderlineColor => PuzzleColors.black;

  @override
  Color get buttonColor => PuzzleColors.black;

  @override
  String get successThemeAsset => 'assets/images/success.png';

  String semanticsLabel(BuildContext context) => context.l10n.sacLabelText;

  @override
  bool get isLogoColored => false;

  @override
  List<Object?> get props => [
        backgroundColorPrimary,
        backgroundColorSecondary,
        defaultColor,
        nameColor,
        titleColor,
        hasTimer,
        hoverColor,
        layoutDelegate,
        name,
        pressedColor,
        menuActiveColor,
        menuInactiveColor,
        menuUnderlineColor,
        buttonColor,
        successThemeAsset,
        isLogoColored
      ];
}
