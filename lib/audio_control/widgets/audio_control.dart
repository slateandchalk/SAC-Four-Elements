import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sac_slide_puzzle/audio_control/audio_control.dart';
import 'package:sac_slide_puzzle/colors/colors.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class AudioControl extends StatelessWidget {
  const AudioControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioMuted = context.select((AudioControlBloc bloc) => bloc.state.muted);
    final audioIcon = audioMuted ? Icons.volume_up : Icons.volume_off;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
          preferences.setBool('audioState', context.read<AudioControlBloc>().state.muted);
          context.read<AudioControlBloc>().add(AudioToggled());
        },
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          child: ResponsiveLayoutBuilder(
              small: (_, child) => child!,
              medium: (_, child) => child!,
              large: (_, child) => child!,
              child: (currentSize) {
                final leftPadding = currentSize != ResponsiveLayoutSize.small ? 40.0 : 8.0;

                return Padding(
                  padding: EdgeInsets.only(left: leftPadding),
                  child: Icon(
                    audioIcon,
                    color: PuzzleColors.white,
                  ),
                );
              }),
        ),
      ),
    );
  }
}
