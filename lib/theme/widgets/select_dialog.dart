import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sac_slide_puzzle/audio_control/audio_control.dart';
import 'package:sac_slide_puzzle/colors/colors.dart';
import 'package:sac_slide_puzzle/helpers/helpers.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class SelectDialog extends StatefulWidget {
  const SelectDialog({
    Key? key,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  _SelectDialogState createState() => _SelectDialogState();
}

class _SelectDialogState extends State<SelectDialog> {
  late final AudioPlayer _clickAudioPlayer;

  @override
  void initState() {
    super.initState();
    _clickAudioPlayer = widget._audioPlayerFactory()
      ..setAsset('assets/audio/click.mp3');
  }

  @override
  void dispose() {
    _clickAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudioControlListener(
      audioPlayer: _clickAudioPlayer,
      key: const Key('select_dialog_click_audio_player'),
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

          final closeIconOffset = currentSize == ResponsiveLayoutSize.large
              ? const Offset(44, 37)
              : (currentSize == ResponsiveLayoutSize.medium
                  ? const Offset(25, 28)
                  : const Offset(17, 63));

          return Stack(
            children: [
              SingleChildScrollView(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      child: Padding(
                        padding: padding,
                        child: Column(
                          children: [
                            const Text('upload'),
                            IconButton(
                              icon: const Icon(Icons.upload_file),
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                        allowMultiple: false,
                                        type: FileType.image);

                                if (result != null) {
                                  PlatformFile file = result.files.first;
                                  showAppDialog(
                                      barrierColor: Colors.black,
                                      context: context,
                                      child: MultiBlocProvider(
                                        providers: [
                                          BlocProvider.value(
                                            value: context.read<ThemeBloc>(),
                                          ),
                                          BlocProvider.value(
                                            value: context
                                                .read<AudioControlBloc>(),
                                          ),
                                        ],
                                        child: CropDialog(
                                          file: file.bytes!,
                                        ),
                                      ),
                                      barrierDismissible: true);
                                } else {
                                  unawaited(_clickAudioPlayer.play());
                                  context
                                      .read<ThemeBloc>()
                                      .add(const ThemeChanged(themeIndex: 0));
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                right: closeIconOffset.dx,
                top: closeIconOffset.dy,
                child: IconButton(
                  key: const Key('select_dialog_close_button'),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 18,
                  icon: const Icon(
                    Icons.close,
                    color: PuzzleColors.black,
                  ),
                  onPressed: () async {
                    StreamingSharedPreferences prefs =
                        await StreamingSharedPreferences.instance;
                    setState(() {
                      prefs.setBool('isCropped', false);
                    });
                    unawaited(_clickAudioPlayer.play());
                    context
                        .read<ThemeBloc>()
                        .add(const ThemeChanged(themeIndex: 0));
                    Navigator.pop(context);
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
