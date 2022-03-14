import 'package:flutter/material.dart';
import 'package:sac_slide_puzzle/colors/colors.dart';
import 'package:sac_slide_puzzle/l10n/l10n.dart';
import 'package:sac_slide_puzzle/theme/themes/themes.dart';

class FireTheme extends SimpleTheme {
  const FireTheme() : super();

  @override
  String get name => 'Fire';

  @override
  String semanticsLabel(BuildContext context) => context.l10n.fireLabelText;

  @override
  Color get backgroundColorPrimary => PuzzleColors.firePrimary;

  @override
  Color get backgroundColorSecondary => PuzzleColors.fireSecondary;

  @override
  Color get defaultColor => PuzzleColors.fire90;

  @override
  Color get buttonColor => PuzzleColors.fire50;

  @override
  Color get menuInactiveColor => PuzzleColors.fire50;

  @override
  Color get countdownColor => PuzzleColors.fire50;

  @override
  String get themeAsset => 'assets/images/gallery/fire.png';

  @override
  String get successThemeAsset => 'assets/images/success.png';

  @override
  String get audioAsset => 'assets/audio/fire.mp3';

  @override
  String get tileAssetsDirectory => 'assets/images/fire';
}
