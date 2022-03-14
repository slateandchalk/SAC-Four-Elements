import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sac_slide_puzzle/colors/colors.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/models/models.dart';
import 'package:sac_slide_puzzle/theme/themes/themes.dart';

abstract class SimpleTheme extends PuzzleTheme {
  const SimpleTheme() : super();

  @override
  String get name => 'Simple';

  @override
  bool get hasTimer => true;

  @override
  Color get nameColor => PuzzleColors.white;

  @override
  Color get titleColor => PuzzleColors.white;

  @override
  Color get hoverColor => PuzzleColors.black2;

  @override
  Color get pressedColor => PuzzleColors.white2;

  @override
  bool get isLogoColored => false;

  @override
  Color get menuActiveColor => PuzzleColors.white;

  @override
  Color get menuUnderlineColor => PuzzleColors.white;

  @override
  PuzzleLayoutDelegate get layoutDelegate => const SimplePuzzleLayoutDelegate();

  String semanticsLabel(BuildContext context);

  Color get countdownColor;

  String get themeAsset;

  @override
  String get successThemeAsset;

  String get audioAsset;

  String get tileAssetsDirectory;

  String tileAssetForTile(Tile tile) => p.join(tileAssetsDirectory, '${tile.value.toString()}.png');

  @override
  List<Object?> get props => [
        name,
        hasTimer,
        nameColor,
        titleColor,
        backgroundColorPrimary,
        backgroundColorSecondary,
        defaultColor,
        buttonColor,
        hoverColor,
        pressedColor,
        isLogoColored,
        menuActiveColor,
        menuUnderlineColor,
        menuInactiveColor,
        layoutDelegate,
        countdownColor,
        themeAsset,
        successThemeAsset,
        audioAsset,
        tileAssetsDirectory
      ];
}
