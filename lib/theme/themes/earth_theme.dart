import 'package:flutter/material.dart';
import 'package:sac_slide_puzzle/colors/colors.dart';
import 'package:sac_slide_puzzle/l10n/l10n.dart';
import 'package:sac_slide_puzzle/theme/themes/themes.dart';

class EarthTheme extends SimpleTheme {
  const EarthTheme() : super();

  @override
  String get name => 'Earth';

  @override
  String semanticsLabel(BuildContext context) => context.l10n.earthLabelText;

  @override
  Color get backgroundColorPrimary => PuzzleColors.earthPrimary;

  @override
  Color get backgroundColorSecondary => PuzzleColors.earthSecondary;

  @override
  Color get defaultColor => PuzzleColors.earth90;

  @override
  Color get buttonColor => PuzzleColors.earth50;

  @override
  Color get menuInactiveColor => PuzzleColors.earth50;

  @override
  Color get countdownColor => PuzzleColors.earth50;

  @override
  String get themeAsset => 'assets/images/gallery/earth.png';

  @override
  String get successThemeAsset => 'assets/images/success.png';

  @override
  String get audioAsset => 'assets/audio/earth.mp3';

  @override
  String get tileAssetsDirectory => 'assets/images/earth';
}
