import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:sac_slide_puzzle/helpers/helpers.dart';
import 'package:sac_slide_puzzle/l10n/l10n.dart';
import 'package:sac_slide_puzzle/puzzle/puzzle.dart';

class App extends StatefulWidget {
  const App({Key? key, ValueGetter<PlatformHelper>? platformHelperFactory})
      : _platformHelperFactory = platformHelperFactory ?? getPlatformHelper,
        super(key: key);

  final ValueGetter<PlatformHelper> _platformHelperFactory;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  static const localAssetsPrefix = 'assets/';

  static final audioAssets = [
    'assets/audio/shuffle.mp3',
    'assets/audio/click.mp3',
    'assets/audio/success.mp3',
    'assets/audio/tile_move.mp3',
  ];

  late final PlatformHelper _platformHelper;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _platformHelper = widget._platformHelperFactory();

    _timer = Timer(const Duration(milliseconds: 20), () {
      for (var i = 1; i <= 3; i++) {
        precacheImage(
          Image.asset('assets/images/air/$i.png').image,
          context,
        );
      }
      for (var i = 1; i <= 8; i++) {
        precacheImage(
          Image.asset('assets/images/water/$i.png').image,
          context,
        );
      }
      for (var i = 1; i <= 15; i++) {
        precacheImage(
          Image.asset('assets/images/earth/$i.png').image,
          context,
        );
      }
      for (var i = 1; i <= 24; i++) {
        precacheImage(
          Image.asset('assets/images/fire/$i.png').image,
          context,
        );
      }
      precacheImage(
        Image.asset('assets/images/success.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/logo_white.png').image,
        context,
      );

      for (final audioAsset in audioAssets) {
        prefetchToMemory(audioAsset);
      }
      prefetchToMemory('assets/audio/air.mp3');
      prefetchToMemory('assets/audio/water.mp3');
      prefetchToMemory('assets/audio/earth.mp3');
      prefetchToMemory('assets/audio/fire.mp3');
    });
  }

  Future<void> prefetchToMemory(String filePath) async {
    if (_platformHelper.isWeb) {
      await http.get(Uri.parse('$localAssetsPrefix$filePath'));
      return;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Four Elements',
          home: const PuzzlePage(),
          theme: ThemeData(
            appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
            colorScheme: ColorScheme.fromSwatch(
              accentColor: const Color(0xFF13B9FF),
            ),
          ),
          localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate],
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}

class AppBuilder extends StatefulWidget {
  final Function(BuildContext) builder;

  const AppBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  AppBuilderState createState() => AppBuilderState();

  static AppBuilderState? of(BuildContext context) {
    return context.findAncestorStateOfType<AppBuilderState>();
  }
}

class AppBuilderState extends State<AppBuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  void rebuild() {
    setState(() {});
  }
}
