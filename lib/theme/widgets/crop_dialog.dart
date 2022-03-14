import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as imglib;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sac_slide_puzzle/audio_control/audio_control.dart';
import 'package:sac_slide_puzzle/colors/colors.dart';
import 'package:sac_slide_puzzle/helpers/helpers.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class CropDialog extends StatefulWidget {
  const CropDialog({
    Key? key,
    AudioPlayerFactory? audioPlayer,
    required this.file,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final AudioPlayerFactory _audioPlayerFactory;
  final Uint8List file;

  @override
  _CropDialogState createState() => _CropDialogState();
}

class _CropDialogState extends State<CropDialog> {
  late final AudioPlayer _clickAudioPlayer;

  @override
  void initState() {
    super.initState();
    _clickAudioPlayer = widget._audioPlayerFactory()..setAsset('assets/audio/click.mp3');
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
      key: const Key('crop_dialog_click_audio_player'),
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
              : (currentSize == ResponsiveLayoutSize.medium ? const Offset(25, 28) : const Offset(17, 63));

          final _cropController = CropController();
          Uint8List? _croppedData;

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
                            SizedBox(
                              width: 500,
                              height: 500,
                              child: Crop(
                                controller: _cropController,
                                aspectRatio: 1 / 1,
                                image: widget.file.buffer.asUint8List(),
                                baseColor: Colors.transparent,
                                initialSize: 0.5,
                                maskColor: Colors.white.withAlpha(100),
                                onCropped: (croppedData) {
                                  setState(() {
                                    _croppedData = croppedData;
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _cropController.crop();
                                Future.delayed(const Duration(seconds: 1)).whenComplete(() async {
                                  StreamingSharedPreferences prefs = await StreamingSharedPreferences.instance;
                                  // List<String>? image = _croppedData
                                  //     ?.map((i) => i.toString())
                                  //     .toList();
                                  // List<String> imageX =
                                  //     splitImage(_croppedData!)
                                  //         .map((e) => e)
                                  //         .toList();
                                  setState(() {
                                    prefs.setBool('isCropped', true);
                                    prefs.setStringList('croppedData', splitImage(_croppedData!));
                                  });
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              },
                              icon: const Icon(Icons.save),
                            )
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
                  key: const Key('crop_dialog_close_button'),
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
                    StreamingSharedPreferences prefs = await StreamingSharedPreferences.instance;
                    setState(() {
                      prefs.setBool('isCropped', false);
                    });
                    unawaited(_clickAudioPlayer.play());
                    context.read<ThemeBloc>().add(const ThemeChanged(themeIndex: 0));
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

List<String> splitImage(List<int> input) {
  imglib.Image? image = imglib.decodeImage(input);

  int x = 0, y = 0;
  int width = (image!.width / 4).round();
  int height = (image.height / 4).round();

  List<imglib.Image> parts = <imglib.Image>[];
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      parts.add(imglib.copyCrop(image, x, y, width, height));
      x += width;
    }
    x = 0;
    y += height;
  }

  List<String> output = <String>[];
  for (var img in parts) {
    output.add(img.getBytes().toString());
  }

  return output;
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  final myDir = Directory('${directory.path}/de');
  if (await myDir.exists()) {
    return myDir.path;
  } else {
    final createDir = Directory('${directory.path}/de').create(recursive: true).then((value) {
      return value.path;
    });
    return createDir;
  }
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

Future<File> writeCounter(String counter) async {
  final file = await _localFile;
  // Write the file
  return file.writeAsString(counter);
}
