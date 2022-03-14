import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sac_slide_puzzle/audio_control/audio_control.dart';
import 'package:sac_slide_puzzle/helpers/helpers.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class ShareDialog extends StatefulWidget {
  const ShareDialog({
    Key? key,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AudioPlayer _successAudioPlayer;
  late final AudioPlayer _clickAudioPlayer;
  late int numberOfMoves = 0;

  Future<int> getValue() async {
    StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
    return preferences.getInt('totalMoves', defaultValue: 0).getValue();
  }

  @override
  void initState() {
    super.initState();
    _successAudioPlayer = widget._audioPlayerFactory()..setAsset('assets/audio/success.mp3');
    unawaited(_successAudioPlayer.play());

    _clickAudioPlayer = widget._audioPlayerFactory()..setAsset('assets/audio/click.mp3');

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    getValue().then((value) => numberOfMoves = value);

    Future.delayed(
      const Duration(milliseconds: 140),
      _controller.forward,
    );
  }

  @override
  void dispose() {
    _successAudioPlayer.dispose();
    _clickAudioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<AudioControlBloc>().add(const AudioStopped(false));
    context.read<AudioControlBloc>().add(const AudioStopped(true));
    return AudioControlListener(
      key: const Key('share_dialog_success_audio_player'),
      audioPlayer: _successAudioPlayer,
      child: AudioControlListener(
        key: const Key('share_dialog_click_audio_player'),
        audioPlayer: _clickAudioPlayer,
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
                                      child: Score(numberOfMoves: numberOfMoves),
                                    ),
                                  ),
                                  const ResponsiveGap(
                                    small: 40,
                                    medium: 40,
                                    large: 80,
                                  ),
                                  ShareYourScore(
                                    animation: animation,
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
      ),
    );
  }
}
