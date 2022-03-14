import 'package:flutter/material.dart';
import 'package:sac_slide_puzzle/colors/colors.dart';
import 'package:sac_slide_puzzle/l10n/l10n.dart';
import 'package:sac_slide_puzzle/theme/themes/themes.dart';

class WaterTheme extends SimpleTheme {
  const WaterTheme() : super();

  @override
  String get name => 'Water';

  @override
  String semanticsLabel(BuildContext context) => context.l10n.waterLabelText;

  @override
  Color get backgroundColorPrimary => PuzzleColors.waterPrimary;

  @override
  Color get backgroundColorSecondary => PuzzleColors.waterSecondary;

  @override
  Color get defaultColor => PuzzleColors.water90;

  @override
  Color get buttonColor => PuzzleColors.water50;

  @override
  Color get menuInactiveColor => PuzzleColors.water50;

  @override
  Color get countdownColor => PuzzleColors.water50;

  @override
  String get themeAsset => 'assets/images/gallery/water.png';

  @override
  String get successThemeAsset => 'assets/images/success.png';

  @override
  String get audioAsset => 'assets/audio/water.mp3';

  @override
  String get tileAssetsDirectory => 'assets/images/water';
}
