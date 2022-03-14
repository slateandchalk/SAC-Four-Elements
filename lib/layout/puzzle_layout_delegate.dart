import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sac_slide_puzzle/countdown/countdown.dart';
import 'package:sac_slide_puzzle/models/models.dart';
import 'package:sac_slide_puzzle/puzzle/puzzle.dart';

abstract class PuzzleLayoutDelegate extends Equatable {
  const PuzzleLayoutDelegate();
  Widget backgroundBuilder(PuzzleState state);
  Widget backgroundTopBuilder(PuzzleState state, MediaQueryData size);
  Widget backgroundBottomLandscapeBuilder(PuzzleState state, MediaQueryData size, artboardL);
  Widget backgroundBottomMountainBuilder(PuzzleState state, MediaQueryData size, artboardM);
  Widget startSectionBuilder(PuzzleState state);
  Widget boardBuilder(int size, Map<String, int> board, double gap, List<Widget> tiles, double slideValue,
      Map<String, int> outline, PuzzleState state, CountdownStatus status);
  Widget whitespaceTileBuilder();
  Widget tileBuilder(Tile tile, Map<String, int> tileSize, PuzzleState state);
  Widget endSectionBuilder(PuzzleState state);
}
