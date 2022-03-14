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

class AbortDialog extends StatefulWidget {
  const AbortDialog({
    Key? key,
    AudioPlayerFactory? audioPlayer,
    required this.currentIndex,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final AudioPlayerFactory _audioPlayerFactory;
  final int currentIndex;

  @override
  State<AbortDialog> createState() => _AbortDialogState();
}

class _AbortDialogState extends State<AbortDialog> with TickerProviderStateMixin {
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
                                      children: [
                                        Image.asset(widget.currentIndex == 1
                                            ? 'assets/images/reward_air.png'
                                            : widget.currentIndex == 2
                                                ? 'assets/images/reward_water.png'
                                                : widget.currentIndex == 3
                                                    ? 'assets/images/reward_earth.png'
                                                    : widget.currentIndex == 0
                                                        ? 'assets/images/reward_all.png'
                                                        : 'assets/images/reward_fire.png'),
                                        Text(
                                          widget.currentIndex == 1
                                              ? '''Are you sure you want to restart the game now?\n Your achievement of the Air element will be lost.'''
                                              : widget.currentIndex == 2
                                                  ? '''Are you sure you want to restart the game now?\n Your achievements of Air and Water elements will be lost. Just two more to win!'''
                                                  : widget.currentIndex == 3
                                                      ? '''Come on, you don't want to restart the game now, do you?\n You're one step away to victory. Don't give up!'''
                                                      : widget.currentIndex == 0
                                                          ? '''Are you sure you want to restart the game?\n Give a little push, sure you can do it!'''
                                                          : '''Are you sure you want to restart the game?\n Give a little push, sure you can do it!''',
                                          style: PuzzleTextStyle.bodyText,
                                          textAlign: TextAlign.center,
                                        ),
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
                                        PuzzleRedButton(
                                          onPressed: () {
                                            Navigator.pop(context, ["Close", widget.currentIndex.toString()]);
                                          },
                                          child: Text(
                                            context.l10n.quitGame,
                                            style: PuzzleTextStyle.text,
                                          ),
                                        ),
                                        const Gap(16),
                                        PuzzleGreenButton(
                                          onPressed: () async {
                                            Navigator.pop(context, ["Open", widget.currentIndex.toString()]);
                                          },
                                          child: Text(
                                            context.l10n.continueGame,
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
