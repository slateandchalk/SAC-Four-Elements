import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart' as rive;
import 'package:sac_slide_puzzle/audio_control/audio_control.dart';
import 'package:sac_slide_puzzle/countdown/countdown.dart';
import 'package:sac_slide_puzzle/l10n/l10n.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/models/models.dart';
import 'package:sac_slide_puzzle/puzzle/puzzle.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';
import 'package:sac_slide_puzzle/timer/timer.dart';
import 'package:sac_slide_puzzle/typography/typography.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SimpleThemeBloc(
            themes: const [
              AirTheme(),
              WaterTheme(),
              EarthTheme(),
              FireTheme(),
            ],
          ),
        ),
        BlocProvider(
          create: (_) => CountdownBloc(
            secondsToBegin: 3,
            ticker: const Ticker(),
          ),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(
            themes: [
              context.read<SimpleThemeBloc>().state.theme,
              const SacTheme(),
            ],
          ),
        ),
        BlocProvider(
          create: (_) => TimerBloc(
            ticker: const Ticker(),
          ),
        ),
        BlocProvider(
          create: (_) => AudioControlBloc(),
        ),
      ],
      child: const PuzzleView(),
    );
  }
}

class PuzzleView extends StatefulWidget {
  const PuzzleView({Key? key}) : super(key: key);

  @override
  State<PuzzleView> createState() => _PuzzleViewState();
}

class _PuzzleViewState extends State<PuzzleView> {
  @override
  Widget build(BuildContext context) {
    final theme = context.select((SimpleThemeBloc bloc) => bloc.state.theme);

    return Scaffold(
      body: BlocListener<SimpleThemeBloc, SimpleThemeState>(
        listener: (context, state) async {
          final currentTheme = context.read<SimpleThemeBloc>().state.theme;
          context.read<ThemeBloc>().add(ThemeUpdated(theme: currentTheme));
        },
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TimerBloc(
                ticker: const Ticker(),
              ),
            ),
            BlocProvider(
              create: (context) => PuzzleBloc(2)
                ..add(
                  const PuzzleInitialized(shufflePuzzle: false, size: 2),
                ),
            ),
          ],
          child: AnimatedContainer(
            duration: PuzzleThemeAnimationDuration.backgroundColorChange,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                stops: const [0.1, 0.9],
                colors: [
                  theme.backgroundColorSecondary,
                  theme.backgroundColorPrimary,
                ],
              ),
            ),
            child: const _Puzzle(
              key: Key('puzzle_view_puzzle'),
            ),
          ),
        ),
      ),
    );
  }
}

class _Puzzle extends StatefulWidget {
  const _Puzzle({Key? key}) : super(key: key);

  @override
  State<_Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<_Puzzle> {
  rive.SMIInput<double>? _numInputMountain;
  rive.SMIInput<double>? _numInputLandscape;

  void _mountainInit(rive.Artboard artboardMountain) {
    final controllerMountain = rive.StateMachineController.fromArtboard(artboardMountain, 'Mountain');
    artboardMountain.addController(controllerMountain!);
    _numInputMountain = controllerMountain.findInput('state');
  }

  void _landscapeInit(rive.Artboard artboardLandscape) {
    final controllerLandscape = rive.StateMachineController.fromArtboard(artboardLandscape, 'Landscape');
    artboardLandscape.addController(controllerLandscape!);
    _numInputLandscape = controllerLandscape.findInput('state');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
        final state = context.watch<PuzzleBloc>().state;
        return Stack(
          children: [
            BlocListener<SimpleThemeBloc, SimpleThemeState>(
              listener: (BuildContext context, state) async {
                StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
                int currentIndex = preferences.getInt('currentIndex', defaultValue: 0).getValue();
                if (_numInputMountain?.value != currentIndex) {
                  _numInputMountain?.value = currentIndex.toDouble();
                  _numInputLandscape?.value = currentIndex.toDouble();
                }
              },
              child: Stack(
                children: [
                  theme.layoutDelegate.backgroundBottomMountainBuilder(state, MediaQuery.of(context), _mountainInit),
                  theme.layoutDelegate.backgroundBottomLandscapeBuilder(state, MediaQuery.of(context), _landscapeInit),
                ],
              ),
            ),
            theme.layoutDelegate.backgroundTopBuilder(state, MediaQuery.of(context)),
            //theme.layoutDelegate.backgroundBuilder(state),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: const [
                    _PuzzleHeader(
                      key: Key('puzzle_header'),
                    ),
                    _PuzzleSections(
                      key: Key('puzzle_sections'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PuzzleHeader extends StatelessWidget {
  const _PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ResponsiveLayoutBuilder(
        small: (context, child) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _PuzzleLogo(),
              _PuzzleMenu(),
            ],
          ),
        ),
        medium: (context, child) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _PuzzleLogo(),
              _PuzzleMenu(),
            ],
          ),
        ),
        large: (context, child) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _PuzzleLogo(),
              _PuzzleMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PuzzleSections extends StatelessWidget {
  const _PuzzleSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, child) => const Align(
        child: PuzzleBoard(),
        alignment: Alignment.center,
      ),
      medium: (context, child) => const Align(
        child: PuzzleBoard(),
        alignment: Alignment.center,
      ),
      large: (context, child) => const Align(
        child: PuzzleBoard(),
        alignment: Alignment.center,
      ),
    );
  }
}

class _PuzzleLogo extends StatelessWidget {
  const _PuzzleLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return AppLogo(
      key: puzzleLogoKey,
      isColored: theme.isLogoColored,
    );
  }
}

class PuzzleBoard extends StatefulWidget {
  const PuzzleBoard({Key? key}) : super(key: key);

  @override
  State<PuzzleBoard> createState() => _PuzzleBoardState();
}

class _PuzzleBoardState extends State<PuzzleBoard> {
  Timer? _completePuzzleTimer;
  late int b = 0;
  late int c = 0;
  late ConfettiController _controllerCenter;

  Future<int> getValue() async {
    StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
    return preferences.getInt('currentIndex', defaultValue: 0).getValue();
  }

  @override
  void initState() {
    super.initState();
    getValue().then((value) => b = value);
    getValue().then((value) => c = value);
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _completePuzzleTimer?.cancel();
    super.dispose();
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);
    final state = context.watch<PuzzleBloc>().state;
    final status = context.select((CountdownBloc bloc) => bloc.state.status);
    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();
    return BlocListener<PuzzleBloc, PuzzleState>(
      listener: (context, state) async {
        StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;

        int a = preferences.getInt('currentIndex', defaultValue: 0).getValue();
        getValue().then((value) => b = value);
        if (state.puzzleStatus == PuzzleStatus.complete) {
          _controllerCenter.play();
          _completePuzzleTimer = Timer(const Duration(milliseconds: 5000), () async {
            if (a <= 3) {
              setState(() {
                a++;
                preferences.setInt('currentIndex', a);
              });
              context.read<SimpleThemeBloc>().add(SimpleThemeChanged(themeIndex: a > 3 ? 3 : a));
              context.read<PuzzleBloc>().add(
                    PuzzleInitialized(
                        shufflePuzzle: false,
                        size: a == 0
                            ? 2
                            : a == 1
                                ? 3
                                : a == 2
                                    ? 4
                                    : a == 3
                                        ? 5
                                        : 2),
                  );
            }
          });
        }
      },
      child: Column(
        children: [
          Stack(
            children: [
              theme.layoutDelegate.boardBuilder(
                  size,
                  b == 0
                      ? _boardSizeAir
                      : b == 1
                          ? _boardSizeWater
                          : b == 2
                              ? _boardSizeEarth
                              : b == 3
                                  ? _boardSizeFire
                                  : _boardSizeAir,
                  b == 0
                      ? 240
                      : b == 1
                          ? 180
                          : b == 2
                              ? 120
                              : b == 3
                                  ? 104
                                  : 240,
                  puzzle.tiles
                      .map(
                        (tile) => _PuzzleTile(
                          key: Key('puzzle_tile_${tile.value.toString()}'),
                          tile: tile,
                          tileSize: b == 0
                              ? _tileSizeAir
                              : b == 1
                                  ? _tileSizeWater
                                  : b == 2
                                      ? _tileSizeEarth
                                      : b == 3
                                          ? _tileSizeFire
                                          : _tileSizeAir,
                        ),
                      )
                      .toList(),
                  b.toDouble(),
                  b == 0
                      ? _outSizeAir
                      : b == 1
                          ? _outSizeWater
                          : b == 2
                              ? _outSizeEarth
                              : b == 3
                                  ? _outSizeFire
                                  : _outSizeAir,
                  state,
                  status),
              Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  numberOfParticles: 10,
                  emissionFrequency: 0.01,
                  maxBlastForce: 20,
                  minBlastForce: 5,
                  confettiController: _controllerCenter,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
                  createParticlePath: drawStar,
                ),
              ),
            ],
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}

Map<String, int> _outSizeAir = {"small": 124, "medium": 178, "large": 192}; //232

Map<String, int> _outSizeWater = {"small": 188, "medium": 268, "large": 292}; //352

Map<String, int> _outSizeEarth = {"small": 252, "medium": 358, "large": 392};

Map<String, int> _outSizeFire = {"small": 312, "medium": 448, "large": 492}; //502

Map<String, int> _boardSizeAir = {"small": 312, "medium": 448, "large": 492}; //232

Map<String, int> _boardSizeWater = {"small": 312, "medium": 448, "large": 492}; //352

Map<String, int> _boardSizeEarth = {"small": 312, "medium": 448, "large": 492};

Map<String, int> _boardSizeFire = {"small": 312, "medium": 448, "large": 492}; //502

Map<String, int> _tileSizeAir = {"small": 60, "medium": 86, "large": 94};

Map<String, int> _tileSizeWater = {"small": 60, "medium": 86, "large": 94};

Map<String, int> _tileSizeEarth = {"small": 60, "medium": 86, "large": 94};

Map<String, int> _tileSizeFire = {"small": 60, "medium": 86, "large": 94};

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({Key? key, required this.tile, required this.tileSize}) : super(key: key);

  final Tile tile;
  final dynamic tileSize;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    return tile.isWhitespace
        ? theme.layoutDelegate.whitespaceTileBuilder()
        : theme.layoutDelegate.tileBuilder(tile, tileSize, state);
  }
}

class _PuzzleMenu extends StatelessWidget {
  const _PuzzleMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themes = context.select((ThemeBloc bloc) => bloc.state.themes);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PuzzleMenuItem(themeIndex: 0, theme: themes[0], name: 'Game'),
        _PuzzleMenuItem(themeIndex: 1, theme: themes[1], name: 'Score'),
        AudioControl(
          key: audioControlKey,
        ),
      ],
    );
  }
}

class _PuzzleMenuItem extends StatelessWidget {
  const _PuzzleMenuItem({Key? key, required this.theme, required this.themeIndex, required this.name})
      : super(key: key);

  final PuzzleTheme theme;
  final int themeIndex;
  final String name;

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final simpleTheme = context.select((SimpleThemeBloc bloc) => bloc.state.theme);
    final isCurrentTheme = theme == currentTheme;
    return ResponsiveLayoutBuilder(
      small: (_, child) => Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Tooltip(
          message: theme != currentTheme && name == 'Score' ? context.l10n.puzzleChangeTooltip : '',
          child: IconButton(
            onPressed: () async {
              if (theme == currentTheme) {
                return;
              }
              StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
              preferences.setInt('currentIndex', 0);
              context.read<TimerBloc>().add(const TimerReset());
              context.read<ThemeBloc>().add(ThemeChanged(themeIndex: themeIndex));
              context.read<SimpleThemeBloc>().add(const SimpleThemeChanged(themeIndex: 0));
              context.read<CountdownBloc>().add(const CountdownStopped());
              context.read<PuzzleBloc>().add(
                    const PuzzleInitialized(shufflePuzzle: false, size: 2),
                  );
            },
            icon: Icon(
              name == 'Game' ? Icons.gamepad : Icons.score,
              color: isCurrentTheme ? simpleTheme.menuActiveColor : simpleTheme.menuInactiveColor,
            ),
          ),
        ),
      ),
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final leftPadding = currentSize != ResponsiveLayoutSize.small ? 40.0 : 8.0;
        return Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Tooltip(
            message: theme != currentTheme && name == 'Score' ? context.l10n.puzzleChangeTooltip : '',
            child: TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero)
                  .copyWith(overlayColor: MaterialStateProperty.all(Colors.transparent)),
              onPressed: () async {
                if (theme == currentTheme) {
                  return;
                }
                StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
                preferences.setInt('currentIndex', 0);
                context.read<TimerBloc>().add(const TimerReset());
                context.read<ThemeBloc>().add(ThemeChanged(themeIndex: themeIndex));
                context.read<SimpleThemeBloc>().add(const SimpleThemeChanged(themeIndex: 0));
                context.read<CountdownBloc>().add(const CountdownStopped());
                context.read<PuzzleBloc>().add(
                      const PuzzleInitialized(shufflePuzzle: false, size: 2),
                    );
              },
              child: AnimatedDefaultTextStyle(
                duration: PuzzleThemeAnimationDuration.backgroundColorChange,
                style: PuzzleTextStyle.text
                    .copyWith(color: isCurrentTheme ? simpleTheme.menuActiveColor : simpleTheme.menuInactiveColor),
                child: Text(name),
              ),
            ),
          ),
        );
      },
    );
  }
}

final audioControlKey = GlobalKey(debugLabel: 'audio_control');

final puzzleLogoKey = GlobalKey(debugLabel: 'puzzle_logo');

final puzzleNameKey = GlobalKey(debugLabel: 'puzzle_name');

final puzzleTitleKey = GlobalKey(debugLabel: 'puzzle_title');

final numberOfMovesAndTilesLeftKey = GlobalKey(debugLabel: 'number_of_moves_and_tiles_left');
