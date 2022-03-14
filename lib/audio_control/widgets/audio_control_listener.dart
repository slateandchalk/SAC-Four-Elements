import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sac_slide_puzzle/audio_control/audio_control.dart';

class AudioControlListener extends StatefulWidget {
  const AudioControlListener({Key? key, this.audioPlayer, required this.child})
      : super(key: key);

  final AudioPlayer? audioPlayer;

  final Widget child;

  @override
  _AudioControlListenerState createState() => _AudioControlListenerState();
}

class _AudioControlListenerState extends State<AudioControlListener> {
  @override
  void didChangeDependencies() {
    updatedAudioPlayer(muted: context.read<AudioControlBloc>().state.muted);
    stoppedAudioPlayer(stopped: context.read<AudioControlBloc>().state.stopped);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant AudioControlListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    updatedAudioPlayer(muted: context.read<AudioControlBloc>().state.muted);
    stoppedAudioPlayer(stopped: context.read<AudioControlBloc>().state.stopped);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AudioControlBloc, AudioControlState>(
      listener: (context, state) {
        updatedAudioPlayer(muted: state.muted);
        stoppedAudioPlayer(stopped: state.stopped);
      },
      child: widget.child,
    );
  }

  updatedAudioPlayer({required bool muted}) {
    widget.audioPlayer?.setVolume(muted ? 1.0 : 0.0);
  }

  stoppedAudioPlayer({required bool stopped}) {
    stopped
        ? null
        : widget.audioPlayer
            ?.pause()
            .then((value) => widget.audioPlayer?.stop());
  }
}
