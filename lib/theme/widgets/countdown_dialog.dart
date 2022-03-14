import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sac_slide_puzzle/countdown/countdown.dart';
import 'package:sac_slide_puzzle/helpers/helpers.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';

class CountdownTimerDialog extends StatefulWidget {
  const CountdownTimerDialog({
    Key? key,
    AudioPlayerFactory? audioPlayer,
  }) : super(key: key);

  @override
  State<CountdownTimerDialog> createState() => _CountdownTimerDialogState();
}

class _CountdownTimerDialogState extends State<CountdownTimerDialog> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    Future.delayed(
      const Duration(milliseconds: 140),
      _controller.forward,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final padding = currentSize == ResponsiveLayoutSize.large
            ? const EdgeInsets.fromLTRB(68, 82, 68, 73)
            : (currentSize == ResponsiveLayoutSize.medium)
                ? const EdgeInsets.fromLTRB(48, 54, 48, 53)
                : const EdgeInsets.fromLTRB(20, 99, 20, 76);
        return Stack(
          children: [
            SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: Padding(
                      padding: padding,
                      child: PuzzleDialogAnimatedBuilder(
                        animation: _controller,
                        builder: (context, child, animation) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SlideTransition(
                                position: animation.scoreOffset,
                                child: Opacity(
                                  opacity: animation.scoreOpacity.value,
                                  child: MultiBlocProvider(
                                    providers: [
                                      BlocProvider.value(
                                        value: context.read<CountdownBloc>(),
                                      ),
                                    ],
                                    child: const PuzzleCountdown(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

final puzzleCont = GlobalKey(debugLabel: 'puzzleCont');
