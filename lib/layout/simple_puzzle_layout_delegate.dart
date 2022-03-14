import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rive/rive.dart' as rive;
import 'package:sac_slide_puzzle/audio_control/audio_control.dart';
import 'package:sac_slide_puzzle/countdown/countdown.dart';
import 'package:sac_slide_puzzle/helpers/helpers.dart';
import 'package:sac_slide_puzzle/l10n/l10n.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/models/models.dart';
import 'package:sac_slide_puzzle/puzzle/puzzle.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';
import 'package:sac_slide_puzzle/theme/widgets/pause_dialog.dart';
import 'package:sac_slide_puzzle/timer/timer.dart';
import 'package:sac_slide_puzzle/typography/font_styles.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class SimplePuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  const SimplePuzzleLayoutDelegate();

  @override
  List<Object?> get props => [];

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return Positioned(
      bottom: 0,
      right: 32,
      child: ResponsiveLayoutBuilder(
        small: (_, child) => const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 32, 32),
          child: SizedBox(
            width: 80,
            height: 80,
            child: rive.RiveAnimation.asset('assets/rive/dash_sac.riv'),
          ),
        ),
        medium: (_, child) => const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 40, 32),
          child: SizedBox(
            width: 128,
            height: 128,
            child: rive.RiveAnimation.asset('assets/rive/dash_sac.riv'),
          ),
        ),
        large: (_, child) => const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 160, 40),
          child: SizedBox(
            width: 192,
            height: 192,
            child: rive.RiveAnimation.asset('assets/rive/dash_sac.riv'),
          ),
        ),
      ),
    );
  }

  @override
  Widget backgroundTopBuilder(PuzzleState state, MediaQueryData size) {
    return Positioned(
      top: 0,
      child: ResponsiveLayoutBuilder(
        small: (_, child) => SizedBox(
          child: child!,
          width: size.size.width,
          height: 150,
        ),
        medium: (_, child) => SizedBox(
          child: child!,
          width: size.size.width,
          height: 150,
        ),
        large: (_, child) => SizedBox(
          child: child!,
          width: size.size.width,
          height: 300,
        ),
        child: (currentSize) {
          return const rive.RiveAnimation.asset(
            'assets/rive/clouds.riv',
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  @override
  Widget backgroundBottomLandscapeBuilder(PuzzleState state, MediaQueryData size, artboardL) {
    return Positioned(
      bottom: 0,
      child: ResponsiveLayoutBuilder(
        small: (_, child) => SizedBox(
          child: child!,
          width: size.size.width,
          height: 100,
        ),
        medium: (_, child) => SizedBox(
          child: child!,
          width: size.size.width,
          height: 150,
        ),
        large: (_, child) => SizedBox(
          child: child!,
          width: size.size.width,
          height: 200,
        ),
        child: (currentSize) {
          return rive.RiveAnimation.asset(
            'assets/rive/landscape.riv',
            fit: BoxFit.cover,
            onInit: artboardL,
          );
        },
      ),
    );
  }

  @override
  Widget backgroundBottomMountainBuilder(PuzzleState state, MediaQueryData size, artboardM) {
    return Positioned(
      bottom: 0,
      child: ResponsiveLayoutBuilder(
        small: (_, child) => SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: child!,
          ),
          width: size.size.width,
          height: 100,
        ),
        medium: (_, child) => SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: child!,
          ),
          width: size.size.width,
          height: 150,
        ),
        large: (_, child) => SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: child!,
          ),
          width: size.size.width,
          height: 200,
        ),
        child: (currentSize) {
          return rive.RiveAnimation.asset(
            'assets/rive/mountain.riv',
            fit: BoxFit.cover,
            onInit: artboardM,
          );
        },
      ),
    );
  }

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => SimpleStartSection(state: state),
    );
  }

  @override
  Widget boardBuilder(int size, Map<String, int> board, double gap, List<Widget> tiles, double slideValue,
      Map<String, int> outline, PuzzleState state, CountdownStatus status) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const ResponsiveGap(small: 16, medium: 96, large: 100),
        ResponsiveLayoutBuilder(
          small: (_, child) => SizedBox(width: board.values.elementAt(0).toDouble(), child: child!),
          medium: (_, child) => SizedBox(width: board.values.elementAt(1).toDouble(), child: child!),
          large: (_, child) => SizedBox(width: board.values.elementAt(2).toDouble(), child: child!),
          child: (currentSize) {
            return Container(
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const PuzzleTimer(),
                  NumberOfMovesAndTilesLeft(
                    key: numberOfMovesAndTilesLeftKey,
                    numberOfMoves: state.numberOfMoves,
                    numberOfTilesLeft:
                        status == CountdownStatus.started ? state.numberOfTilesLeft : state.puzzle.tiles.length - 1,
                  ),
                ],
              ),
            );
          },
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => SizedBox(width: board.values.elementAt(0).toDouble(), child: child!),
          medium: (_, child) => SizedBox(width: board.values.elementAt(1).toDouble(), child: child!),
          large: (_, child) => SizedBox(width: board.values.elementAt(2).toDouble(), child: child!),
          child: (currentSize) {
            return SliderWidget(
              slideValue: slideValue,
            );
          },
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => Container(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
            decoration: const BoxDecoration(),
            child: SizedBox.square(
              dimension: board.values.elementAt(0).toDouble(),
              child: SimplePuzzleBoard(
                key: const Key('simple_puzzle_board_small'),
                tiles: tiles,
                size: size,
                boardSize: outline.values.elementAt(0).toDouble(),
              ),
            ),
          ),
          medium: (_, __) => Container(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
            decoration: const BoxDecoration(),
            child: SizedBox.square(
              dimension: board.values.elementAt(1).toDouble(),
              child: SimplePuzzleBoard(
                key: const Key('simple_puzzle_board_medium'),
                tiles: tiles,
                size: size,
                boardSize: outline.values.elementAt(1).toDouble(),
              ),
            ),
          ),
          large: (_, __) => Container(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
            decoration: const BoxDecoration(),
            child: SizedBox.square(
              dimension: board.values.elementAt(2).toDouble(),
              child: SimplePuzzleBoard(
                key: const Key('simple_puzzle_board_large'),
                tiles: tiles,
                size: size,
                boardSize: outline.values.elementAt(2).toDouble(),
              ),
            ),
          ),
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => SizedBox(width: board.values.elementAt(0).toDouble(), child: child!),
          medium: (_, child) => SizedBox(width: board.values.elementAt(1).toDouble(), child: child!),
          large: (_, child) => SizedBox(width: board.values.elementAt(2).toDouble(), child: child!),
          child: (currentSize) {
            return const SimplePuzzleActionButton();
          },
        ),
        const ResponsiveGap(small: 0, medium: 56, large: 64),
      ],
    );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox();
  }

  @override
  Widget tileBuilder(Tile tile, Map<String, int> tileSize, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value.toString()}_small'),
        tile: tile,
        tileFontSize: _TileFontSize.small,
        state: state,
        tileSize: tileSize.values.elementAt(0).toDouble(),
      ),
      medium: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value.toString()}_medium'),
        tile: tile,
        tileFontSize: _TileFontSize.medium,
        state: state,
        tileSize: tileSize.values.elementAt(1).toDouble(),
      ),
      large: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value.toString()}_large'),
        tile: tile,
        tileFontSize: _TileFontSize.large,
        state: state,
        tileSize: tileSize.values.elementAt(2).toDouble(),
      ),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => const SimplePuzzleActionButton(),
          medium: (_, child) => const SimplePuzzleActionButton(),
          large: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => const SizedBox(),
          medium: (_, child) => const SizedBox(),
          large: (_, child) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 54,
        ),
        const ResponsiveGap(
          large: 130,
        ),
        //countdown
      ],
    );
  }
}

class SimpleStartSection extends StatelessWidget {
  const SimpleStartSection({Key? key, required this.state}) : super(key: key);

  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final status = context.select((CountdownBloc bloc) => bloc.state.status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveGap(
          small: 20,
          medium: 83,
          large: 151,
        ),
        PuzzleName(
          key: ValueKey(puzzleNameKey),
        ),
        const ResponsiveGap(
          large: 16,
        ),
        SimplePuzzleTitle(
          status: state.puzzleStatus,
          name: '',
        ),
        const ResponsiveGap(
          small: 12,
          medium: 16,
          large: 32,
        ),
        NumberOfMovesAndTilesLeft(
          key: numberOfMovesAndTilesLeftKey,
          numberOfMoves: state.numberOfMoves,
          numberOfTilesLeft:
              status == CountdownStatus.started ? state.numberOfTilesLeft : state.puzzle.tiles.length - 1,
        ),
        const ResponsiveGap(
          small: 8,
          medium: 18,
          large: 32,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => const SimplePuzzleActionButton(),
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => const PuzzleTimer(),
          medium: (_, __) => const PuzzleTimer(),
          large: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(small: 12),
      ],
    );
  }
}

class SimplePuzzleTitle extends StatefulWidget {
  const SimplePuzzleTitle({Key? key, required this.status, required this.name}) : super(key: key);

  final PuzzleStatus status;
  final String name;

  @override
  State<SimplePuzzleTitle> createState() => _SimplePuzzleTitleState();
}

class _SimplePuzzleTitleState extends State<SimplePuzzleTitle> {
  int index = 1;

  Future<int> getValue() async {
    StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
    return preferences.getInt('currentIndex', defaultValue: 0).getValue();
  }

  @override
  void initState() {
    super.initState();
    getValue().then((value) => index = value + 1);
  }

  @override
  Widget build(BuildContext context) {
    getValue().then((value) => index = value + 1);
    return PuzzleTitle(
      key: puzzleTitleKey,
      title: widget.status == PuzzleStatus.complete ? context.l10n.puzzleCompleted : 'Level $index : ${widget.name}',
    );
  }
}

class SimplePuzzleBoard extends StatefulWidget {
  const SimplePuzzleBoard({
    Key? key,
    AudioPlayerFactory? audioPlayer,
    required this.tiles,
    required this.size,
    this.spacing = 8,
    required this.boardSize,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final List<Widget> tiles;
  final int size;
  final double spacing;
  final double boardSize;
  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<SimplePuzzleBoard> createState() => _SimplePuzzleBoardState();
}

class _SimplePuzzleBoardState extends State<SimplePuzzleBoard> {
  Timer? _completePuzzleTimer;
  Timer? _showTimer;
  Timer? _closeCountdownTimer;
  int airTime = 0;
  int waterTime = 0;
  int earthTime = 0;
  bool showComp = true;
  int indexNow = 0;
  late final AudioPlayer _themePlayer;
  Timer? _timer;
  double c = 1;
  bool firstTime = true;
  Timer? _openingTimer;

  @override
  void initState() {
    super.initState();
    _themePlayer = widget._audioPlayerFactory()..setAsset('assets/audio/air.mp3');
  }

  @override
  void dispose() {
    _completePuzzleTimer?.cancel();
    _showTimer?.cancel();
    _closeCountdownTimer?.cancel();
    _themePlayer.dispose();
    _openingTimer?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference results = FirebaseFirestore.instance.collection('puzzle');
    final themeState = context.watch<SimpleThemeBloc>().state;
    return Center(
      child: AudioControlListener(
        audioPlayer: _themePlayer,
        child: BlocListener<PuzzleBloc, PuzzleState>(
          listener: (context, state) async {
            StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
            if (firstTime) {
              firstTime = false;
              _openingTimer = Timer(const Duration(milliseconds: 2100), () {
                unawaited(_themePlayer.play());
              });
            }

            if (state.puzzleStatus == PuzzleStatus.incomplete) {
              showComp = false;
              c = 1;
            }

            if (preferences.getBool('showComp', defaultValue: true).getValue()) {
              Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  indexNow = 0;
                  showComp = preferences.getBool('showComp', defaultValue: true).getValue();
                });
              });
            }
            if (state.puzzleStatus == PuzzleStatus.complete) {
              _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
                if (c <= 0) {
                  _themePlayer.pause();
                  setState(() {
                    _timer?.cancel();
                  });
                } else {
                  c = c - 0.125;
                }
                unawaited(_themePlayer.setVolume(c));
              });
              showComp = true;
              context.read<TimerBloc>().add(const TimerStopped());
              _showTimer = Timer(const Duration(milliseconds: 5002), () async {
                showComp = true;
              });
              _completePuzzleTimer = Timer(const Duration(milliseconds: 5100), () async {
                int currentIndex = preferences.getInt('currentIndex', defaultValue: 0).getValue();
                indexNow = currentIndex > 3 ? 3 : currentIndex;
                unawaited(_themePlayer.setLoopMode(LoopMode.all));
                int totalMoves = preferences.getInt('totalMoves', defaultValue: 0).getValue();
                setState(() {
                  preferences.setInt('totalMoves', totalMoves + state.numberOfMoves);
                });
                if (currentIndex > 3) {
                  results.add({
                    'total_moves': totalMoves + state.numberOfMoves,
                    'total_time': context.read<TimerBloc>().state.secondsElapsed,
                    'nick_name': preferences.getString('nickName', defaultValue: '').getValue(),
                    'date_time': FieldValue.serverTimestamp(),
                    'air_time': airTime,
                    'water_time': waterTime - airTime,
                    'earth_time': earthTime - waterTime,
                    'fire_time': context.read<TimerBloc>().state.secondsElapsed - earthTime
                  });
                  earthTime = int.parse(preferences.getString('earthTime', defaultValue: '0').getValue());
                  preferences.setString(
                      'fireTime', (context.read<TimerBloc>().state.secondsElapsed - earthTime).toString());
                } else if (currentIndex == 3) {
                  earthTime = context.read<TimerBloc>().state.secondsElapsed;
                  waterTime = int.parse(preferences.getString('waterTime', defaultValue: '0').getValue());
                  preferences.setString('earthTime', (earthTime - waterTime).toString());
                  await _themePlayer.setAsset('assets/audio/fire.mp3');
                } else if (currentIndex == 2) {
                  waterTime = context.read<TimerBloc>().state.secondsElapsed;
                  airTime = int.parse(preferences.getString('airTime', defaultValue: '0').getValue());
                  preferences.setString('waterTime', (waterTime - airTime).toString());
                  await _themePlayer.setAsset('assets/audio/earth.mp3');
                } else if (currentIndex == 1) {
                  airTime = context.read<TimerBloc>().state.secondsElapsed;
                  preferences.setString('airTime', (airTime).toString());
                  await _themePlayer.setAsset('assets/audio/water.mp3');
                }
                await showAppDialog<List<String>>(
                  context: context,
                  barrierDismissible: false,
                  barrierColor: Colors.black,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: context.read<SimpleThemeBloc>(),
                      ),
                      BlocProvider.value(
                        value: context.read<ThemeBloc>(),
                      ),
                      BlocProvider.value(
                        value: context.read<PuzzleBloc>(),
                      ),
                      BlocProvider.value(
                        value: context.read<TimerBloc>(),
                      ),
                      BlocProvider.value(
                        value: context.read<AudioControlBloc>(),
                      ),
                      BlocProvider.value(
                        value: context.read<CountdownBloc>(),
                      ),
                    ],
                    child: PuzzleDialog(currentIndex: currentIndex),
                  ),
                ).then((value) {
                  if (value![0] == 'Close') {
                    context.read<AudioControlBloc>().add(const AudioStopped(false));
                    context.read<TimerBloc>().add(const TimerReset());
                    setState(() {
                      indexNow = 0;
                      showComp = true;
                      preferences.setInt('totalMoves', 0);
                      preferences.setInt('currentIndex', 0);
                      preferences.setBool('canPress', false);
                      preferences.setBool('showComp', true);
                      preferences.setBool('stateStarted', true);
                    });
                    context.read<SimpleThemeBloc>().add(const SimpleThemeChanged(themeIndex: 0));
                    context.read<CountdownBloc>().add(const CountdownStopped());
                    context.read<PuzzleBloc>().add(const PuzzleInitialized(shufflePuzzle: false, size: 2));
                  } else if (value[0] == 'Finish') {
                    showAppDialog(
                      context: context,
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<SimpleThemeBloc>(),
                          ),
                          BlocProvider.value(
                            value: context.read<ThemeBloc>(),
                          ),
                          BlocProvider.value(
                            value: context.read<PuzzleBloc>(),
                          ),
                          BlocProvider.value(
                            value: context.read<TimerBloc>(),
                          ),
                          BlocProvider.value(
                            value: context.read<AudioControlBloc>(),
                          ),
                          BlocProvider.value(
                            value: context.read<CountdownBloc>(),
                          ),
                        ],
                        child: const ShareDialog(),
                      ),
                      barrierDismissible: false,
                      barrierColor: Colors.black,
                    ).then((value) {
                      if (value![0] == 'Close') {
                        context.read<AudioControlBloc>().add(const AudioStopped(false));
                        context.read<TimerBloc>().add(const TimerReset());
                        setState(() {
                          indexNow = 0;
                          showComp = true;
                          preferences.setInt('totalMoves', 0);
                          preferences.setInt('currentIndex', 0);
                          preferences.setBool('canPress', false);
                          preferences.setBool('showComp', true);
                          preferences.setBool('stateStarted', true);
                        });
                        context.read<SimpleThemeBloc>().add(const SimpleThemeChanged(themeIndex: 0));
                        context.read<CountdownBloc>().add(const CountdownStopped());
                        context.read<PuzzleBloc>().add(const PuzzleInitialized(shufflePuzzle: false, size: 2));
                      }
                    });
                  } else {
                    context.read<AudioControlBloc>().add(const AudioStopped(true));
                    _closeCountdownTimer = Timer(const Duration(milliseconds: 5100), () => Navigator.pop(context));
                    showAppDialog(
                      context: context,
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<SimpleThemeBloc>(),
                          ),
                          BlocProvider.value(
                            value: context.read<ThemeBloc>(),
                          ),
                          BlocProvider.value(
                            value: context.read<PuzzleBloc>(),
                          ),
                          BlocProvider.value(
                            value: context.read<TimerBloc>(),
                          ),
                          BlocProvider.value(
                            value: context.read<AudioControlBloc>(),
                          ),
                          BlocProvider.value(
                            value: context.read<CountdownBloc>(),
                          ),
                        ],
                        child: const CountdownTimerDialog(),
                      ),
                      barrierDismissible: false,
                      barrierColor: Colors.black,
                    ).then((value) {
                      unawaited(_themePlayer.play());
                    });
                  }
                });
              });
            }
          },
          child: Material(
            color: Colors.transparent,
            elevation: 80,
            child: ResponsiveLayoutBuilder(
              small: (_, child) => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: showComp
                    ? AnimatedContainer(
                        color: Colors.transparent,
                        width: widget.boardSize,
                        height: widget.boardSize,
                        curve: Curves.easeInOut,
                        duration: const Duration(seconds: 4),
                        child: SizedBox.square(
                          dimension: widget.boardSize,
                          child: AnimatedSwitcher(
                            duration: const Duration(seconds: 3),
                            child: Image.asset(
                              themeState.themes[indexNow].themeAsset,
                              fit: BoxFit.fill,
                              semanticLabel: themeState.themes[indexNow].semanticsLabel(context),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.square(
                        key: const Key('sac_puzzle_board_small'),
                        dimension: widget.boardSize,
                        child: child,
                      ),
              ),
              medium: (_, child) => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: showComp
                    ? AnimatedContainer(
                        width: widget.boardSize,
                        height: widget.boardSize,
                        curve: Curves.easeInOut,
                        duration: const Duration(seconds: 4),
                        child: SizedBox.square(
                          dimension: widget.boardSize,
                          child: AnimatedSwitcher(
                            duration: const Duration(seconds: 3),
                            child: Image.asset(
                              themeState.themes[indexNow].themeAsset,
                              fit: BoxFit.fill,
                              semanticLabel: themeState.themes[indexNow].semanticsLabel(context),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.square(
                        key: const Key('sac_puzzle_board_medium'),
                        dimension: widget.boardSize,
                        child: child,
                      ),
              ),
              large: (_, child) => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: showComp
                    ? AnimatedContainer(
                        width: widget.boardSize,
                        height: widget.boardSize,
                        curve: Curves.easeInOut,
                        duration: const Duration(seconds: 4),
                        child: SizedBox.square(
                          dimension: widget.boardSize,
                          child: AnimatedSwitcher(
                            duration: const Duration(seconds: 4),
                            child: Image.asset(
                              themeState.themes[indexNow].themeAsset,
                              fit: BoxFit.fill,
                              semanticLabel: themeState.themes[indexNow].semanticsLabel(context),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.square(
                        key: const Key('sac_puzzle_board_large'),
                        dimension: widget.boardSize,
                        child: child,
                      ),
              ),
              child: (_) => Stack(children: widget.tiles),
            ),
          ),
        ),
      ),
    );
  }
}

class SimplePuzzleTile extends StatefulWidget {
  const SimplePuzzleTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.state,
    AudioPlayerFactory? audioPlayer,
    required this.tileSize,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final Tile tile;
  final double tileFontSize;
  final PuzzleState state;
  final AudioPlayerFactory _audioPlayerFactory;
  final double tileSize;

  @override
  State<SimplePuzzleTile> createState() => _SimplePuzzleTileState();
}

class _SimplePuzzleTileState extends State<SimplePuzzleTile> with SingleTickerProviderStateMixin {
  AudioPlayer? _audioPlayer;
  late final Timer _timer;

  late AnimationController _controller;
  late Animation<double> _scale;

  late bool puzzleBoolState = false;

  Future<bool> getValue() async {
    StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
    return preferences.getBool('canPress', defaultValue: false).getValue();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 1), () {
      _audioPlayer = widget._audioPlayerFactory()..setAsset('assets/audio/tile_move.mp3');
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scale = Tween<double>(begin: 1, end: 0.94).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );

    getValue().then((value) => puzzleBoolState = value);
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.state.puzzle.getDimension();
    final theme = context.select((SimpleThemeBloc bloc) => bloc.state.theme);
    final status = context.select((CountdownBloc bloc) => bloc.state.status);
    final hasStarted = status == CountdownStatus.started;
    final puzzleIncomplete = context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus) == PuzzleStatus.incomplete;

    final movementDuration =
        status == CountdownStatus.loading ? const Duration(milliseconds: 800) : const Duration(milliseconds: 370);

    final canPress = hasStarted && puzzleIncomplete;

    getValue().then((value) => puzzleBoolState = value);

    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: AnimatedAlign(
        alignment: FractionalOffset(
          (widget.tile.currentPosition.x - 1) / (size - 1),
          (widget.tile.currentPosition.y - 1) / (size - 1),
        ),
        duration: movementDuration,
        curve: Curves.easeOut,
        child: ResponsiveLayoutBuilder(
          small: (_, child) => SizedBox.square(
            key: Key('sac_puzzle_tile_small_${widget.tile.value}'),
            dimension: widget.tileSize,
            child: child,
          ),
          medium: (_, child) => SizedBox.square(
            key: Key('sac_puzzle_tile_medium_${widget.tile.value}'),
            dimension: widget.tileSize,
            child: child,
          ),
          large: (_, child) => SizedBox.square(
            key: Key('sac_puzzle_tile_large_${widget.tile.value}'),
            dimension: widget.tileSize,
            child: child,
          ),
          child: (_) => MouseRegion(
            onEnter: (_) {
              if (canPress && puzzleBoolState) {
                _controller.forward();
              }
            },
            onExit: (_) {
              if (canPress && puzzleBoolState) {
                _controller.reverse();
              }
            },
            child: ScaleTransition(
              key: Key('sac_puzzle_tile_scale_${widget.tile.value}'),
              scale: _scale,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: canPress && puzzleBoolState
                        ? () {
                            context.read<PuzzleBloc>().add(TileTapped(widget.tile));
                            unawaited(_audioPlayer?.replay());
                          }
                        : null,
                    icon: Image.asset(
                      theme.tileAssetForTile(widget.tile),
                      semanticLabel: context.l10n.puzzleTileLabelText(
                        widget.tile.value.toString(),
                        widget.tile.currentPosition.x.toString(),
                        widget.tile.currentPosition.y.toString(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        widget.tile.value.toString(),
                        style: TextStyle(
                          color: theme.backgroundColorPrimary,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

abstract class _TileFontSize {
  static double small = 36;
  static double medium = 50;
  static double large = 54;
}

class SimplePuzzleActionButton extends StatefulWidget {
  const SimplePuzzleActionButton({Key? key, AudioPlayerFactory? audioPlayer})
      : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<SimplePuzzleActionButton> createState() => _SimplePuzzleActionButtonState();
}

class _SimplePuzzleActionButtonState extends State<SimplePuzzleActionButton> {
  late final AudioPlayer _audioPlayer;
  Timer? _closeCountdownTimer;
  bool started = false;
  bool second = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget._audioPlayerFactory()..setAsset('assets/audio/click.mp3');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _closeCountdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select((CountdownBloc bloc) => bloc.state.status);
    final isLoading = status == CountdownStatus.loading;
    final isStarted = status == CountdownStatus.started;
    final state = context.watch<PuzzleBloc>().state;
    final text = isStarted ? context.l10n.restart : (isLoading ? context.l10n.getReady : context.l10n.startGame);
    final secondsElapsed = context.select((TimerBloc bloc) => bloc.state.secondsElapsed);
    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: AnimatedSwitcher(
        duration: PuzzleThemeAnimationDuration.textStyle,
        child: !isStarted
            ? PuzzleButton(
                onPressed: (state.puzzleStatus == PuzzleStatus.incomplete)
                    ? () async {
                        StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
                        context.read<AudioControlBloc>().add(const AudioStopped(false));
                        context.read<AudioControlBloc>().add(const AudioStopped(true));
                        unawaited(_audioPlayer.replay());
                        int a = preferences.getInt('currentIndex', defaultValue: 0).getValue();
                        bool stateStarted = preferences.getBool('stateStarted', defaultValue: true).getValue();
                        if ((a > 0) || (started != stateStarted)) {
                          context.read<TimerBloc>().add(const TimerStopped());
                          await showAppDialog<List<String>>(
                            barrierDismissible: false,
                            barrierColor: Colors.black,
                            context: context,
                            child: MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: context.read<SimpleThemeBloc>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<ThemeBloc>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<PuzzleBloc>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<TimerBloc>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<AudioControlBloc>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<CountdownBloc>(),
                                ),
                              ],
                              child: AbortDialog(
                                currentIndex: a,
                              ),
                            ),
                          ).then((value) {
                            if (value![0] == 'Close') {
                              context.read<TimerBloc>().add(const TimerReset());
                              setState(() {
                                preferences.setInt('totalMoves', 0);
                                preferences.setInt('currentIndex', 0);
                                preferences.setBool('canPress', false);
                                preferences.setBool('showComp', true);
                                preferences.setBool('showComp', true);
                                preferences.setBool('stateStarted', false);
                              });
                              context.read<AudioControlBloc>().add(const AudioStopped(false));
                              context.read<SimpleThemeBloc>().add(const SimpleThemeChanged(themeIndex: 0));
                              context.read<CountdownBloc>().add(const CountdownStopped());
                              context.read<PuzzleBloc>().add(
                                    const PuzzleInitialized(
                                      shufflePuzzle: false,
                                      size: 2,
                                    ),
                                  );
                              started = false;
                              second = true;
                            } else {
                              second = false;
                              context.read<TimerBloc>().add(TimerResume(secondsElapsed));
                            }
                          }).then((value) {});
                          return;
                        }
                        context.read<TimerBloc>().add(TimerResume(secondsElapsed));
                        setState(() {
                          preferences.setBool("canPress", true);
                          preferences.setBool('showComp', false);
                        });
                        await showAppDialog<List<String>>(
                          barrierDismissible: false,
                          barrierColor: Colors.black,
                          context: context,
                          child: MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<SimpleThemeBloc>(),
                              ),
                              BlocProvider.value(
                                value: context.read<ThemeBloc>(),
                              ),
                              BlocProvider.value(
                                value: context.read<PuzzleBloc>(),
                              ),
                              BlocProvider.value(
                                value: context.read<TimerBloc>(),
                              ),
                              BlocProvider.value(
                                value: context.read<AudioControlBloc>(),
                              ),
                              BlocProvider.value(
                                value: context.read<CountdownBloc>(),
                              ),
                            ],
                            child: PuzzleDialog(
                              currentIndex: a,
                            ),
                          ),
                        ).then(
                          (value) {
                            if (value![0] == 'Close') {
                              started = false;
                              second = false;
                              return;
                            } else {
                              context.read<TimerBloc>().add(const TimerReset());
                              _closeCountdownTimer = Timer(Duration(milliseconds: second ? 5100 : 3100), () {
                                Navigator.of(context).pop();
                              });
                              showAppDialog(
                                context: context,
                                child: MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(
                                      value: context.read<SimpleThemeBloc>(),
                                    ),
                                    BlocProvider.value(
                                      value: context.read<ThemeBloc>(),
                                    ),
                                    BlocProvider.value(
                                      value: context.read<PuzzleBloc>(),
                                    ),
                                    BlocProvider.value(
                                      value: context.read<TimerBloc>(),
                                    ),
                                    BlocProvider.value(
                                      value: context.read<AudioControlBloc>(),
                                    ),
                                    BlocProvider.value(
                                      value: context.read<CountdownBloc>(),
                                    ),
                                  ],
                                  child: const CountdownTimerDialog(),
                                ),
                                barrierDismissible: false,
                                barrierColor: Colors.black,
                              ).then((value) {
                                started = true;
                                second = true;
                              });
                              if (isStarted) {
                                context.read<PuzzleBloc>().add(
                                      const PuzzleInitialized(
                                        shufflePuzzle: false,
                                        size: 2,
                                      ),
                                    );
                              }
                            }
                          },
                        );
                      }
                    : () {},
                child: Text(
                  text,
                  style: PuzzleTextStyle.text,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tooltip(
                    key: ValueKey(status),
                    message: isStarted ? context.l10n.puzzleRestartTooltip : '',
                    verticalOffset: 40,
                    child: PuzzleRestartButton(
                        onPressed: (state.puzzleStatus == PuzzleStatus.incomplete)
                            ? () async {
                                context.read<AudioControlBloc>().add(const AudioStopped(false));
                                context.read<AudioControlBloc>().add(const AudioStopped(true));
                                unawaited(_audioPlayer.replay());
                                StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
                                int a = preferences.getInt('currentIndex', defaultValue: 0).getValue();
                                bool stateStarted = preferences.getBool('stateStarted', defaultValue: true).getValue();
                                if ((a > 0) || (started != stateStarted)) {
                                  context.read<TimerBloc>().add(const TimerStopped());
                                  await showAppDialog<List<String>>(
                                    barrierDismissible: false,
                                    barrierColor: Colors.black,
                                    context: context,
                                    child: MultiBlocProvider(
                                      providers: [
                                        BlocProvider.value(
                                          value: context.read<SimpleThemeBloc>(),
                                        ),
                                        BlocProvider.value(
                                          value: context.read<ThemeBloc>(),
                                        ),
                                        BlocProvider.value(
                                          value: context.read<PuzzleBloc>(),
                                        ),
                                        BlocProvider.value(
                                          value: context.read<TimerBloc>(),
                                        ),
                                        BlocProvider.value(
                                          value: context.read<AudioControlBloc>(),
                                        ),
                                        BlocProvider.value(
                                          value: context.read<CountdownBloc>(),
                                        ),
                                      ],
                                      child: AbortDialog(
                                        currentIndex: a,
                                      ),
                                    ),
                                  ).then((value) {
                                    if (value![0] == 'Close') {
                                      context.read<TimerBloc>().add(const TimerReset());
                                      setState(() {
                                        preferences.setInt('totalMoves', 0);
                                        preferences.setInt('currentIndex', 0);
                                        preferences.setBool('canPress', false);
                                        preferences.setBool('showComp', true);
                                        preferences.setBool('showComp', true);
                                        preferences.setBool('stateStarted', false);
                                      });
                                      context.read<AudioControlBloc>().add(const AudioStopped(false));
                                      context.read<SimpleThemeBloc>().add(const SimpleThemeChanged(themeIndex: 0));
                                      context.read<CountdownBloc>().add(const CountdownStopped());
                                      context.read<PuzzleBloc>().add(
                                            const PuzzleInitialized(
                                              shufflePuzzle: false,
                                              size: 2,
                                            ),
                                          );
                                      started = false;
                                      second = true;
                                    } else {
                                      second = false;
                                      context.read<TimerBloc>().add(TimerResume(secondsElapsed));
                                    }
                                  }).then((value) {});
                                  return;
                                }
                              }
                            : () {}),
                  ),
                  const Gap(8),
                  PuzzlePauseButton(
                    onPressed: (state.puzzleStatus == PuzzleStatus.incomplete)
                        ? () async {
                            context.read<AudioControlBloc>().add(const AudioStopped(false));
                            context.read<AudioControlBloc>().add(const AudioStopped(true));
                            unawaited(_audioPlayer.replay());
                            StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
                            int a = preferences.getInt('currentIndex', defaultValue: 0).getValue();
                            bool stateStarted = preferences.getBool('stateStarted', defaultValue: true).getValue();
                            if ((a > 0) || (started != stateStarted)) {
                              context.read<TimerBloc>().add(const TimerStopped());
                              await showAppDialog<List<String>>(
                                barrierDismissible: false,
                                barrierColor: Colors.black,
                                context: context,
                                child: MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(
                                      value: context.read<SimpleThemeBloc>(),
                                    ),
                                    BlocProvider.value(
                                      value: context.read<ThemeBloc>(),
                                    ),
                                    BlocProvider.value(
                                      value: context.read<PuzzleBloc>(),
                                    ),
                                    BlocProvider.value(
                                      value: context.read<TimerBloc>(),
                                    ),
                                    BlocProvider.value(
                                      value: context.read<AudioControlBloc>(),
                                    ),
                                    BlocProvider.value(
                                      value: context.read<CountdownBloc>(),
                                    ),
                                  ],
                                  child: PauseDialog(
                                    currentIndex: a,
                                    playerName: preferences.getString('nickName', defaultValue: '').getValue(),
                                    airTime: preferences.getString('airTime', defaultValue: '0').getValue(),
                                    waterTime: preferences.getString('waterTime', defaultValue: '0').getValue(),
                                    earthTime: preferences.getString('earthTime', defaultValue: '0').getValue(),
                                    fireTime: preferences.getString('fireTime', defaultValue: '0').getValue(),
                                  ),
                                ),
                              );
                              context.read<TimerBloc>().add(TimerResume(secondsElapsed));
                              return;
                            }
                          }
                        : () {},
                  ),
                ],
              ),
      ),
    );
  }
}

class SliderWidget extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final bool fullWidth;
  final double slideValue;

  const SliderWidget(
      {Key? key, this.sliderHeight = 48, this.max = 4, this.min = 0, this.fullWidth = false, required this.slideValue})
      : super(key: key);

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late int currentIndex = 0;

  Future<int> getIndex() async {
    StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
    return preferences.getInt('currentIndex', defaultValue: 0).getValue();
  }

  @override
  void initState() {
    super.initState();
    getIndex().then((value) => currentIndex = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((SimpleThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    var x = state.puzzle.getDimension();
    getIndex().then((value) => currentIndex = value);
    return AnimatedContainer(
      height: (widget.sliderHeight),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        gradient: LinearGradient(
            colors: [
              theme.backgroundColorPrimary.withOpacity(1),
              theme.backgroundColorSecondary.withOpacity(.2),
            ],
            begin: const FractionalOffset(1.0, 1.0),
            end: const FractionalOffset(0.0, 0.00),
            stops: [(((state.numberOfTilesLeft)) / (x * x)), 1.0],
            tileMode: TileMode.clamp),
      ),
      duration: PuzzleThemeAnimationDuration.backgroundColorChange,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: <Widget>[
            Icon(
              currentIndex == 0
                  ? Icons.border_all
                  : currentIndex == 1
                      ? Icons.air
                      : currentIndex == 2
                          ? Icons.water
                          : currentIndex == 3
                              ? Icons.landscape
                              : Icons.border_all,
              color: Colors.white,
              size: 24.0,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Center(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbColor: theme.backgroundColorPrimary,
                    activeTrackColor: Colors.white.withOpacity(1),
                    inactiveTrackColor: Colors.white.withOpacity(.5),
                    trackHeight: 4.0,
                    thumbShape: CustomSliderThumbCircle(
                      thumbRadius: 12,
                      min: widget.min,
                      max: widget.max,
                      currentIndex: currentIndex,
                    ),
                    overlayColor: Colors.white.withOpacity(.4),
                    activeTickMarkColor: Colors.white,
                    inactiveTickMarkColor: Colors.red.withOpacity(.7),
                  ),
                  child: Slider(
                    min: 0,
                    max: 4,
                    value: widget.slideValue,
                    onChanged: null,
                    divisions: 4,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Icon(
              currentIndex == 0
                  ? Icons.air
                  : currentIndex == 1
                      ? Icons.water
                      : currentIndex == 2
                          ? Icons.landscape
                          : currentIndex == 3
                              ? Icons.local_fire_department
                              : Icons.border_all,
              color: Colors.white,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;
  final int currentIndex;

  const CustomSliderThumbCircle({required this.thumbRadius, this.min = 0, this.max = 4, required this.currentIndex});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    TextSpan span = TextSpan(
      style: TextStyle(
        fontSize: thumbRadius * .8,
        fontWeight: FontWeight.w700,
        package: Icons.border_all.fontPackage,
        fontFamily: Icons.border_all.fontFamily,
        color: sliderTheme.thumbColor, //Text Color of Value on Thumb
      ),
      text: String.fromCharCode(
        currentIndex == 0
            ? Icons.air.codePoint
            : currentIndex == 1
                ? Icons.water.codePoint
                : currentIndex == 2
                    ? Icons.landscape.codePoint
                    : currentIndex == 3
                        ? Icons.local_fire_department.codePoint
                        : Icons.border_all.codePoint,
      ),
    );

    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter = Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, thumbRadius * .9, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}
