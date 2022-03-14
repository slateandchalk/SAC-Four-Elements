import 'package:flutter/material.dart';
import 'package:sac_slide_puzzle/colors/colors.dart';
import 'package:sac_slide_puzzle/l10n/l10n.dart';
import 'package:sac_slide_puzzle/theme/themes/themes.dart';

class AirTheme extends SimpleTheme {
  const AirTheme() : super();

  @override
  String get name => 'Air';

  @override
  String semanticsLabel(BuildContext context) => context.l10n.airLabelText;

  @override
  Color get backgroundColorPrimary => PuzzleColors.airPrimary;

  @override
  Color get backgroundColorSecondary => PuzzleColors.airSecondary;

  @override
  Color get defaultColor => PuzzleColors.air90;

  @override
  Color get buttonColor => PuzzleColors.air50;

  @override
  Color get menuInactiveColor => PuzzleColors.air50;

  @override
  Color get countdownColor => PuzzleColors.air50;

  @override
  String get themeAsset => 'assets/images/gallery/air.png';

  @override
  String get successThemeAsset => 'assets/images/success.png';

  @override
  String get audioAsset => 'assets/audio/air.mp3';

  @override
  String get tileAssetsDirectory => 'assets/images/air';
}
