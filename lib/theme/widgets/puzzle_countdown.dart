import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sac_slide_puzzle/audio_control/audio_control.dart';
import 'package:sac_slide_puzzle/countdown/countdown.dart';
import 'package:sac_slide_puzzle/helpers/helpers.dart';
import 'package:sac_slide_puzzle/l10n/l10n.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/puzzle/puzzle.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';
import 'package:sac_slide_puzzle/timer/timer.dart';
import 'package:sac_slide_puzzle/typography/font_styles.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class PuzzleCountdown extends StatefulWidget {
  const PuzzleCountdown({Key? key, AudioPlayerFactory? audioPlayer})
      : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<PuzzleCountdown> createState() => _PuzzleCountdownState();
}

class _PuzzleCountdownState extends State<PuzzleCountdown> {
  late final AudioPlayer _shufflePlayer;
  late final AudioPlayer _themePlayer;

  @override
  void initState() {
    super.initState();
    _shufflePlayer = widget._audioPlayerFactory()..setAsset('assets/audio/shuffle.mp3');
    _themePlayer = widget._audioPlayerFactory();
  }

  @override
  void dispose() {
    _shufflePlayer.dispose();
    _themePlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondsElapsed = context.select((TimerBloc bloc) => bloc.state.secondsElapsed);
    double c = 0.25;
    return AudioControlListener(
      audioPlayer: _shufflePlayer,
      key: shuffleCont,
      child: AudioControlListener(
        audioPlayer: _themePlayer,
        key: audioCont,
        child: BlocListener<CountdownBloc, CountdownState>(
          listener: (context, state) async {
            StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;

            int a = preferences.getInt('currentIndex', defaultValue: 0).getValue();
            if (!state.isCountdownRunning) {
              return;
            }

            if (state.secondsToBegin < 3) {
              unawaited(_themePlayer.setVolume(1 - c));
              c = c + 0.25;
            }
            unawaited(_shufflePlayer.replay());
            // Start the puzzle timer when the countdown finishes.
            if (state.status == CountdownStatus.started) {
              a == 0
                  ? context.read<TimerBloc>().add(const TimerStarted())
                  : context.read<TimerBloc>().add(TimerResume(secondsElapsed));
            }

            // Shuffle the puzzle on every countdown tick.
            if (state.secondsToBegin >= 1 && state.secondsToBegin <= 3) {
              context.read<PuzzleBloc>().add(const PuzzleReset());
            }
          },
          child: ResponsiveLayoutBuilder(
            small: (_, child) => child!,
            medium: (_, child) => child!,
            large: (_, child) => child!,
            child: (currentSize) {
              return BlocBuilder<CountdownBloc, CountdownState>(builder: (context, state) {
                if (!state.isCountdownRunning || state.secondsToBegin > 3) {
                  return const SizedBox();
                }

                if (state.secondsToBegin > 0) {
                  return CountdownSecondsToBegin(
                    key: ValueKey(state.secondsToBegin),
                    secondsToBegin: state.secondsToBegin,
                  );
                } else {
                  return const CountdownGo();
                }
              });
            },
          ),
        ),
      ),
    );
  }
}

class CountdownSecondsToBegin extends StatefulWidget {
  const CountdownSecondsToBegin({Key? key, required this.secondsToBegin}) : super(key: key);

  final int secondsToBegin;

  @override
  State<CountdownSecondsToBegin> createState() => _CountdownSecondsToBeginState();
}

class _CountdownSecondsToBeginState extends State<CountdownSecondsToBegin> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> inOpacity;
  late Animation<double> inScale;
  late Animation<double> outOpacity;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    inOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.58, curve: Curves.decelerate),
      ),
    );

    inScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.58, curve: Curves.decelerate),
      ),
    );

    outOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.81, 1, curve: Curves.easeIn),
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return FadeTransition(
      opacity: outOpacity,
      child: FadeTransition(
        opacity: inOpacity,
        child: ScaleTransition(
          scale: inScale,
          child: Text(
            widget.secondsToBegin.toString(),
            style: PuzzleTextStyle.countdownTime.copyWith(
              color: theme.nameColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CountdownGo extends StatefulWidget {
  const CountdownGo({Key? key}) : super(key: key);

  @override
  State<CountdownGo> createState() => _CountdownGoState();
}

class _CountdownGoState extends State<CountdownGo> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> inOpacity;
  late Animation<double> inScale;
  late Animation<double> outScale;
  late Animation<double> outOpacity;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    inOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.37, curve: Curves.decelerate),
      ),
    );

    inScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.37, curve: Curves.decelerate),
      ),
    );

    outOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.63, 1, curve: Curves.easeIn),
      ),
    );

    outScale = Tween<double>(begin: 1, end: 1.5).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.63, 1, curve: Curves.easeIn),
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return Padding(
      padding: const EdgeInsets.only(top: 101),
      child: FadeTransition(
        opacity: outOpacity,
        child: FadeTransition(
          opacity: inOpacity,
          child: ScaleTransition(
            scale: outScale,
            child: ScaleTransition(
              scale: inScale,
              child: Text(
                context.l10n.countdownGo,
                style: PuzzleTextStyle.countdownTime.copyWith(
                  fontSize: 100,
                  color: theme.defaultColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final audioCont = GlobalKey(debugLabel: 'audioCont');
final shuffleCont = GlobalKey(debugLabel: 'shuffleCont');
