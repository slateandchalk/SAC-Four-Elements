import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rive/rive.dart' as rive;
import 'package:sac_slide_puzzle/audio_control/audio_control.dart';
import 'package:sac_slide_puzzle/colors/colors.dart';
import 'package:sac_slide_puzzle/countdown/countdown.dart';
import 'package:sac_slide_puzzle/helpers/helpers.dart';
import 'package:sac_slide_puzzle/l10n/l10n.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';
import 'package:sac_slide_puzzle/typography/font_styles.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:username_generator/username_generator.dart';

class PuzzleDialog extends StatefulWidget {
  const PuzzleDialog({
    Key? key,
    AudioPlayerFactory? audioPlayer,
    required this.currentIndex,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final AudioPlayerFactory _audioPlayerFactory;
  final int currentIndex;

  @override
  State<PuzzleDialog> createState() => _PuzzleDialogState();
}

class _PuzzleDialogState extends State<PuzzleDialog> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AudioPlayer _successAudioPlayer;
  var generator = UsernameGenerator();
  final focusNode = FocusNode();
  bool textHasFocus = false;
  bool textHasValue = false;

  final TextEditingController _firstNameController = TextEditingController();

  String getName() {
    return generator.generate('', prefix: 'Sac', adjectives: ['Air', 'Water', 'Earth', 'Fire']).toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    _successAudioPlayer = widget._audioPlayerFactory()..setAsset('assets/audio/success.mp3');
    unawaited(_successAudioPlayer.play());

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    generator.separator = ' ';
    _firstNameController.text = '';

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
    final status = context.select((CountdownBloc bloc) => bloc.state.status);
    final isStarted = status == CountdownStatus.started;

    focusNode.addListener(() {
      setState(() {
        textHasFocus = focusNode.hasFocus;
      });
    });

    DocumentReference count = FirebaseFirestore.instance.collection('puzzleStats').doc('numberOfPlayerPlayed');

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
                                    child: widget.currentIndex == 0
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ResponsiveLayoutBuilder(
                                                small: (_, child) => SizedBox(
                                                  child: Image.asset(
                                                    'assets/images/sac_four_elements.png',
                                                  ),
                                                  width: MediaQuery.of(context).size.width * .5,
                                                  height: MediaQuery.of(context).size.height * .2,
                                                ),
                                                medium: (_, child) => SizedBox(
                                                  child: Image.asset(
                                                    'assets/images/sac_four_elements.png',
                                                  ),
                                                  width: MediaQuery.of(context).size.width * .8,
                                                  height: MediaQuery.of(context).size.height * .25,
                                                ),
                                                large: (_, child) => SizedBox(
                                                  child: Image.asset(
                                                    'assets/images/sac_four_elements.png',
                                                  ),
                                                  width: MediaQuery.of(context).size.width * .8,
                                                  height: MediaQuery.of(context).size.height * .3,
                                                ),
                                              ),
                                              Text(
                                                '''The game consists of four levels. Solve the puzzle in each level to gain an element of nature. Collect all the elements to progress and win the game.''',
                                                style: PuzzleTextStyle.bodyText,
                                                textAlign: TextAlign.center,
                                              ),
                                              const ResponsiveGap(
                                                small: 20,
                                                medium: 40,
                                                large: 10,
                                              ),
                                              TextField(
                                                onChanged: (value) {
                                                  if (value.isNotEmpty) {
                                                    setState(() {
                                                      textHasValue = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      textHasValue = false;
                                                    });
                                                  }
                                                },
                                                cursorColor: PuzzleColors.white,
                                                focusNode: focusNode,
                                                decoration: InputDecoration(
                                                  enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: PuzzleColors.white.withOpacity(0.5),
                                                    ),
                                                  ),
                                                  focusedBorder: const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: PuzzleColors.white,
                                                    ),
                                                  ),
                                                  hintText: 'Nick Name',
                                                  hintStyle: TextStyle(
                                                    color: textHasFocus
                                                        ? PuzzleColors.white.withOpacity(0.2)
                                                        : PuzzleColors.white,
                                                  ),
                                                ),
                                                style: PuzzleTextStyle.bodyHigh,
                                                textAlign: TextAlign.center,
                                                controller: _firstNameController,
                                                textCapitalization: TextCapitalization.sentences,
                                              ),
                                              const ResponsiveGap(
                                                small: 20,
                                                medium: 20,
                                                large: 20,
                                              ),
                                              Text(
                                                '''Can't think of any nicknames? Fret not, a nickname will be automatically generated.''',
                                                style: PuzzleTextStyle.bodySmall.copyWith(fontSize: 12),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )
                                        : Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ResponsiveLayoutBuilder(
                                                small: (_, child) => SizedBox(
                                                  child: child!,
                                                  width: MediaQuery.of(context).size.width * .9,
                                                  height: MediaQuery.of(context).size.height * .5,
                                                ),
                                                medium: (_, child) => SizedBox(
                                                  child: child!,
                                                  width: MediaQuery.of(context).size.width,
                                                  height: MediaQuery.of(context).size.height * .25,
                                                ),
                                                large: (_, child) => SizedBox(
                                                  child: child!,
                                                  width: MediaQuery.of(context).size.width,
                                                  height: MediaQuery.of(context).size.height * .3,
                                                ),
                                                child: (currentSize) {
                                                  return rive.RiveAnimation.asset(
                                                    'assets/rive/rewards.riv',
                                                    artboard: widget.currentIndex == 1
                                                        ? 'AP'
                                                        : widget.currentIndex == 2
                                                            ? 'WP'
                                                            : widget.currentIndex == 3
                                                                ? 'EP'
                                                                : 'FP',
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              ),
                                              Text(
                                                widget.currentIndex == 1
                                                    ? '''Congrats on cracking the puzzle.\n Here is your Air element!'''
                                                    : widget.currentIndex == 2
                                                        ? '''Congrats on cracking the puzzle.\n Here is your Water element! Two more to go.'''
                                                        : widget.currentIndex == 3
                                                            ? '''Congrats on cracking the puzzle.\n Here is your Earth element!! One more to go.'''
                                                            : '''Congrats on cracking the puzzle.\n Here is your fire element!''',
                                                style: PuzzleTextStyle.bodyText,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                                const ResponsiveGap(
                                  small: 20,
                                  medium: 20,
                                  large: 20,
                                ),
                                SlideTransition(
                                  position: animation.socialButtonsOffset,
                                  child: Opacity(
                                    opacity: animation.socialButtonsOpacity.value,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        widget.currentIndex > 3
                                            ? PuzzleGreenButton(
                                                onPressed: () {
                                                  Navigator.pop(context, ["Finish", widget.currentIndex.toString()]);
                                                },
                                                child: Text(
                                                  context.l10n.finishGame,
                                                  style: PuzzleTextStyle.text,
                                                ),
                                              )
                                            : PuzzleRedButton(
                                                onPressed: () {
                                                  Navigator.pop(context, ["Close", widget.currentIndex.toString()]);
                                                },
                                                child: Text(
                                                  context.l10n.quitGame,
                                                  style: PuzzleTextStyle.text,
                                                ),
                                              ),
                                        widget.currentIndex > 3 ? const SizedBox() : const Gap(16),
                                        widget.currentIndex > 3
                                            ? const SizedBox()
                                            : PuzzleGreenButton(
                                                onPressed: () async {
                                                  StreamingSharedPreferences preference =
                                                      await StreamingSharedPreferences.instance;
                                                  preference.setString(
                                                      'nickName',
                                                      _firstNameController.text.isEmpty
                                                          ? getName()
                                                          : _firstNameController.text);
                                                  count.get().then((value) {
                                                    List<dynamic> x = value.get('history');
                                                    x.add({
                                                      'nick_name': _firstNameController.text.isEmpty
                                                          ? getName()
                                                          : _firstNameController.text,
                                                      'timeStamp': Timestamp.fromDate(DateTime.now())
                                                    });
                                                    return count.update({
                                                      'count': (int.parse(value.get('count').toString()) + 1),
                                                      'history': FieldValue.arrayUnion(x),
                                                    });
                                                  });
                                                  context.read<CountdownBloc>().add(
                                                        CountdownReset(secondsToBegin: isStarted ? 5 : 3),
                                                      );
                                                  Navigator.pop(context, ["Open", widget.currentIndex.toString()]);
                                                },
                                                child: Text(
                                                  widget.currentIndex == 0
                                                      ? context.l10n.beginGame
                                                      : context.l10n.nextGame,
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
