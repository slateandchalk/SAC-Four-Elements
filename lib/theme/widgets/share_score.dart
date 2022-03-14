import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sac_slide_puzzle/colors/colors.dart';
import 'package:sac_slide_puzzle/l10n/l10n.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';
import 'package:sac_slide_puzzle/typography/typography.dart';

class Score extends StatelessWidget {
  const Score({Key? key, required this.numberOfMoves}) : super(key: key);

  static const _smallImageOffset = Offset(124, 36);
  static const _mediumImageOffset = Offset(215, -47);
  static const _largeImageOffset = Offset(215, -47);

  final int numberOfMoves;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((SimpleThemeBloc bloc) => bloc.state.theme);

    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final height = currentSize == ResponsiveLayoutSize.small ? 374.0 : 355.0;

        final imageOffset = currentSize == ResponsiveLayoutSize.large
            ? _largeImageOffset
            : (currentSize == ResponsiveLayoutSize.medium ? _mediumImageOffset : _smallImageOffset);

        final imageHeight = currentSize == ResponsiveLayoutSize.small ? 374.0 : 437.0;

        final completedTextWidth = currentSize == ResponsiveLayoutSize.small ? 160.0 : double.infinity;

        final wellDoneTextStyle =
            currentSize == ResponsiveLayoutSize.small ? PuzzleTextStyle.headline4Soft : PuzzleTextStyle.headline;

        final timerTextStyle =
            currentSize == ResponsiveLayoutSize.small ? PuzzleTextStyle.text : PuzzleTextStyle.headline4;

        final timerIconSize = currentSize == ResponsiveLayoutSize.small ? const Size(21, 21) : const Size(28, 28);

        final timerIconPadding = currentSize == ResponsiveLayoutSize.small ? 4.0 : 6.0;

        final numberOfMovesTextStyle =
            currentSize == ResponsiveLayoutSize.small ? PuzzleTextStyle.text : PuzzleTextStyle.headline4;

        return ClipRRect(
          borderRadius: BorderRadius.circular(22),
          key: const Key('score'),
          child: Container(
            width: double.infinity,
            height: height,
            color: theme.backgroundColorPrimary,
            child: Stack(
              children: [
                Positioned(
                  left: imageOffset.dx,
                  top: imageOffset.dy,
                  child: Image.asset(
                    theme.successThemeAsset,
                    height: imageHeight,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppLogo(
                        height: 18,
                        isColored: false,
                      ),
                      const ResponsiveGap(
                        small: 24,
                        medium: 32,
                        large: 32,
                      ),
                      SizedBox(
                        key: const Key('score_completed'),
                        width: completedTextWidth,
                        child: AnimatedDefaultTextStyle(
                          style: PuzzleTextStyle.text.copyWith(
                            color: theme.defaultColor,
                          ),
                          duration: const Duration(milliseconds: 500),
                          child: Text(context.l10n.successCompleted),
                        ),
                      ),
                      const ResponsiveGap(
                        small: 8,
                        medium: 16,
                        large: 16,
                      ),
                      AnimatedDefaultTextStyle(
                        key: const Key('score_well_done'),
                        style: wellDoneTextStyle.copyWith(
                          color: PuzzleColors.white,
                        ),
                        duration: const Duration(milliseconds: 500),
                        child: Text(context.l10n.successWellDone),
                      ),
                      const ResponsiveGap(
                        small: 24,
                        medium: 32,
                        large: 32,
                      ),
                      AnimatedDefaultTextStyle(
                        key: const Key('score_score'),
                        style: PuzzleTextStyle.text.copyWith(
                          color: theme.defaultColor,
                        ),
                        duration: const Duration(milliseconds: 500),
                        child: Text(context.l10n.successScore),
                      ),
                      const ResponsiveGap(
                        small: 8,
                        medium: 9,
                        large: 9,
                      ),
                      PuzzleTimer(
                        textStyle: timerTextStyle,
                        iconSize: timerIconSize,
                        iconPadding: timerIconPadding,
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                      const ResponsiveGap(
                        small: 2,
                        medium: 8,
                        large: 8,
                      ),
                      AnimatedDefaultTextStyle(
                        key: const Key('score_number_of_moves'),
                        style: numberOfMovesTextStyle.copyWith(
                          color: PuzzleColors.white,
                        ),
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          context.l10n.successNumberOfMoves(
                            numberOfMoves.toString(),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
