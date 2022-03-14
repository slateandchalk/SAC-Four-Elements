import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sac_slide_puzzle/colors/colors.dart';
import 'package:sac_slide_puzzle/l10n/l10n.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/timer/timer.dart';
import 'package:sac_slide_puzzle/typography/typography.dart';

class PuzzleTimer extends StatelessWidget {
  const PuzzleTimer({Key? key, this.textStyle, this.iconSize, this.iconPadding, this.mainAxisAlignment})
      : super(key: key);

  final TextStyle? textStyle;
  final Size? iconSize;
  final double? iconPadding;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final secondsElapsed = context.select((TimerBloc bloc) => bloc.state.secondsElapsed);
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final timeElapsed = Duration(seconds: secondsElapsed);
        return Row(
          key: const Key('timer'),
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.timer,
              size: 18,
              color: PuzzleColors.white,
            ),
            Gap(iconPadding ?? 8),
            AnimatedDefaultTextStyle(
              style: PuzzleTextStyle.text,
              duration: const Duration(milliseconds: 500),
              child: Text(
                _formatDuration(timeElapsed),
                key: ValueKey(secondsElapsed),
                semanticsLabel: _getDurationLabel(timeElapsed, context),
              ),
            ),
          ],
        );
      },
    );
  }
}

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
}

String _getDurationLabel(Duration duration, BuildContext context) {
  return context.l10n.puzzleDurationLabelText(
    duration.inHours.toString(),
    duration.inMinutes.remainder(60).toString(),
    duration.inSeconds.remainder(60).toString(),
  );
}
