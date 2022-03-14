import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sac_slide_puzzle/audio_control/audio_control.dart';
import 'package:sac_slide_puzzle/helpers/helpers.dart';
import 'package:sac_slide_puzzle/l10n/l10n.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';
import 'package:sac_slide_puzzle/typography/font_styles.dart';

class PauseDialog extends StatefulWidget {
  const PauseDialog({
    Key? key,
    AudioPlayerFactory? audioPlayer,
    required this.currentIndex,
    required this.playerName,
    required this.airTime,
    required this.waterTime,
    required this.earthTime,
    required this.fireTime,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final AudioPlayerFactory _audioPlayerFactory;
  final int currentIndex;
  final String playerName;
  final String airTime;
  final String waterTime;
  final String earthTime;
  final String fireTime;

  @override
  State<PauseDialog> createState() => _PauseDialogState();
}

class _PauseDialogState extends State<PauseDialog> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AudioPlayer _successAudioPlayer;

  @override
  void initState() {
    super.initState();
    _successAudioPlayer = widget._audioPlayerFactory()..setAsset('assets/audio/success.mp3');
    unawaited(_successAudioPlayer.play());

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    Future.delayed(
      const Duration(milliseconds: 140),
      _controller.forward,
    );
  }

  String get() {
    return 'f';
  }

  String intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    String hourLeft = h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft = m.toString().length < 2 ? "0" + m.toString() : m.toString();

    String secondsLeft = s.toString().length < 2 ? "0" + s.toString() : s.toString();

    //hourLeft + "h " + minuteLeft + "m " + secondsLeft + "s"
    String hh = "";
    String mm = "";
    String ss = "";

    if (int.parse(hourLeft) != 0) {
      hh = hourLeft + "h ";
    }
    if (int.parse(minuteLeft) != 0) {
      mm = minuteLeft + "m ";
    }
    if (int.parse(secondsLeft) != 0) {
      ss = secondsLeft + "s";
    }

    return hh + mm + ss;
  }

  @override
  void dispose() {
    _successAudioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudioControlListener(
      key: const Key('puzzle_dialog_success_audio_player'),
      audioPlayer: _successAudioPlayer,
      child: ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => child!,
        large: (_, child) => child!,
        child: (currentSize) {
          final padding = currentSize == ResponsiveLayoutSize.large
              ? const EdgeInsets.fromLTRB(68, 82, 68, 73)
              : (currentSize == ResponsiveLayoutSize.medium)
                  ? const EdgeInsets.fromLTRB(48, 54, 48, 53)
                  : const EdgeInsets.fromLTRB(20, 99, 20, 76);

          final crossAxisAlignment =
              currentSize == ResponsiveLayoutSize.large ? CrossAxisAlignment.start : CrossAxisAlignment.center;
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
                              crossAxisAlignment: crossAxisAlignment,
                              children: [
                                SlideTransition(
                                  position: animation.scoreOffset,
                                  child: Opacity(
                                    opacity: animation.scoreOpacity.value,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/images/reward_all.png'),
                                        Text(
                                          'Hey! ' + widget.playerName + ',',
                                          style: PuzzleTextStyle.bodyHigh,
                                          textAlign: TextAlign.center,
                                        ),
                                        const Gap(4),
                                        Text(
                                          widget.currentIndex == 0
                                              ? '''you're going good. Now, go grab that Air element!'''
                                              : widget.currentIndex == 1
                                                  ? '''seems like you've easily earned the Air element.\n Let's see if you can earn the Water element.'''
                                                  : widget.currentIndex == 2
                                                      ? '''Impressive, you've earned two elements.\n Give the Earth element your best shot!'''
                                                      : widget.currentIndex == 3
                                                          ? '''on the road to victory eh? After all, perseverance is the key.\n Congrats in advance!'''
                                                          : '''on the road to victory eh? After all, perseverance is the key.\n Congrats in advance!''',
                                          style: PuzzleTextStyle.bodyText,
                                          textAlign: TextAlign.center,
                                        ),
                                        widget.currentIndex > 0
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.air,
                                                    color: Colors.white,
                                                    size: 16.0,
                                                  ),
                                                  const Gap(4),
                                                  Text(
                                                    'Air : ' + intToTimeLeft(int.parse(widget.airTime)),
                                                    style: PuzzleTextStyle.bodyText,
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        widget.currentIndex > 1
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.water,
                                                    color: Colors.white,
                                                    size: 16.0,
                                                  ),
                                                  const Gap(4),
                                                  Text(
                                                    'Water : ' + intToTimeLeft(int.parse(widget.waterTime)),
                                                    style: PuzzleTextStyle.bodyText,
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        widget.currentIndex > 2
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.landscape,
                                                    color: Colors.white,
                                                    size: 16.0,
                                                  ),
                                                  const Gap(4),
                                                  Text(
                                                    'Earth : ' + intToTimeLeft(int.parse(widget.earthTime)),
                                                    style: PuzzleTextStyle.bodyText,
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        widget.currentIndex > 3
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.local_fire_department,
                                                    color: Colors.white,
                                                    size: 16.0,
                                                  ),
                                                  const Gap(4),
                                                  Text(
                                                    'Fire : ' + intToTimeLeft(int.parse(widget.fireTime)),
                                                    style: PuzzleTextStyle.bodyText,
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                                const ResponsiveGap(
                                  small: 40,
                                  medium: 40,
                                  large: 20,
                                ),
                                SlideTransition(
                                  position: animation.socialButtonsOffset,
                                  child: Opacity(
                                    opacity: animation.socialButtonsOpacity.value,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Gap(16),
                                        PuzzleGreenButton(
                                          onPressed: () async {
                                            Navigator.pop(context, ["Open", widget.currentIndex.toString()]);
                                          },
                                          child: Text(
                                            context.l10n.resumeGame,
                                            style: PuzzleTextStyle.text,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
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
      ),
    );
  }
}
