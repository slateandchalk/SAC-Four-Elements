import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sac_slide_puzzle/audio_control/audio_control.dart';
import 'package:sac_slide_puzzle/helpers/audio_player.dart';
import 'package:sac_slide_puzzle/typography/font_styles.dart';

class ShareButton extends StatefulWidget {
  const ShareButton(
      {Key? key,
      AudioPlayerFactory? audioPlayer,
      required this.title,
      required this.icon,
      required this.color,
      required this.onPressed})
      : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final AudioPlayerFactory _audioPlayerFactory;
  final String title;
  final Widget icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  _ShareButtonState createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget._audioPlayerFactory()..setAsset('assets/audio/click.mp3');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: widget.color),
          borderRadius: BorderRadius.circular(32),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            primary: widget.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            backgroundColor: Colors.transparent,
          ),
          onPressed: () async {
            widget.onPressed;
            unawaited(_audioPlayer.replay());
          },
          child: Row(
            children: [
              const Gap(12),
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  alignment: Alignment.center,
                  width: 32,
                  height: 32,
                  color: widget.color,
                  child: widget.icon,
                ),
              ),
              const Gap(10),
              Text(
                widget.title,
                style: PuzzleTextStyle.text.copyWith(
                  color: widget.color,
                ),
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
