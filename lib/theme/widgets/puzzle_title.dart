import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sac_slide_puzzle/countdown/countdown.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';
import 'package:sac_slide_puzzle/typography/typography.dart';

class PuzzleTitle extends StatelessWidget {
  const PuzzleTitle({Key? key, required this.title, this.color}) : super(key: key);

  final String title;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((SimpleThemeBloc bloc) => bloc.state.theme);
    final status = context.select((CountdownBloc bloc) => bloc.state.status);
    final isStarted = status == CountdownStatus.started;
    return ResponsiveLayoutBuilder(
      small: (context, child) => SizedBox(
        child: child,
      ),
      medium: (context, child) => SizedBox(
        child: child,
      ),
      large: (context, child) => SizedBox(
        child: child,
      ),
      child: (currentSize) {
        return AnimatedDefaultTextStyle(
          child: Text(
            isStarted ? theme.name : 'Elements of Nature',
            textAlign: TextAlign.center,
          ),
          style: PuzzleTextStyle.headline,
          duration: PuzzleThemeAnimationDuration.backgroundColorChange,
        );
      },
    );
  }
}
