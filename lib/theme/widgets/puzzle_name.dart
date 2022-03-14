import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';
import 'package:sac_slide_puzzle/typography/typography.dart';

class PuzzleName extends StatelessWidget {
  const PuzzleName({Key? key, this.color}) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final nameColor = color ?? theme.nameColor;

    return ResponsiveLayoutBuilder(
      small: (context, child) => const SizedBox(),
      medium: (context, child) => const SizedBox(),
      large: (context, child) => AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 5000),
        style: PuzzleTextStyle.text.copyWith(color: nameColor),
        child: Text(
          theme.name,
          key: const Key('puzzle_name_theme'),
        ),
      ),
    );
  }
}
