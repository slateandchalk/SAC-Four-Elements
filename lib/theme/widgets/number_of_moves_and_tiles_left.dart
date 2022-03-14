import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sac_slide_puzzle/l10n/l10n.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';
import 'package:sac_slide_puzzle/typography/typography.dart';

class NumberOfMovesAndTilesLeft extends StatelessWidget {
  const NumberOfMovesAndTilesLeft({
    Key? key,
    required this.numberOfMoves,
    required this.numberOfTilesLeft,
    this.color,
  }) : super(key: key);

  final int numberOfMoves;
  final int numberOfTilesLeft;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((SimpleThemeBloc bloc) => bloc.state.theme);
    final l10n = context.l10n;
    final textColor = color ?? theme.defaultColor;

    return ResponsiveLayoutBuilder(
      small: (context, child) => Center(
        child: child,
      ),
      medium: (context, child) => Center(
        child: child,
      ),
      large: (context, child) => child!,
      child: (currentSize) {
        final scoreStyle = PuzzleTextStyle.text.copyWith(
          color: textColor,
        );
        const durationText = PuzzleThemeAnimationDuration.backgroundColorChange;
        return Semantics(
          label: l10n.puzzleNumberOfMovesAndTilesLeftLabelText(numberOfMoves.toString(), numberOfTilesLeft.toString()),
          child: ExcludeSemantics(
            child: Row(
              key: const Key('number_of_moves_and_tiles_left'),
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                AnimatedDefaultTextStyle(
                  key: const Key('number_of_moves_and_tiles_left_moves'),
                  child: Text(numberOfMoves.toString()),
                  style: scoreStyle,
                  duration: durationText,
                ),
                AnimatedDefaultTextStyle(
                  child: Text(' ${l10n.puzzleNumberOfMoves} | '),
                  style: PuzzleTextStyle.text,
                  duration: durationText,
                ),
                AnimatedDefaultTextStyle(
                  key: const Key('number_of_moves_and_tiles_left_tiles_left'),
                  child: Text(numberOfTilesLeft.toString()),
                  style: scoreStyle,
                  duration: durationText,
                ),
                AnimatedDefaultTextStyle(
                  child: Text(' ${l10n.puzzleNumberOfTilesLeft}'),
                  style: PuzzleTextStyle.text,
                  duration: durationText,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
