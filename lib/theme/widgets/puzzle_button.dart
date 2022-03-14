import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class PuzzleButton extends StatefulWidget {
  const PuzzleButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;

  @override
  State<PuzzleButton> createState() => _PuzzleButtonState();
}

class _PuzzleButtonState extends State<PuzzleButton> {
  bool get isPlaying => _controller?.isActive ?? false;

  rive.StateMachineController? _controller;
  rive.SMIInput<double>? _numInputStart;

  void _startInit(rive.Artboard artboardStart) async {
    final controllerPause = rive.StateMachineController.fromArtboard(artboardStart, 'Start');
    artboardStart.addController(controllerPause!);
    _numInputStart = controllerPause.findInput('state');
    StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
    int currentIndex = preferences.getInt('currentIndex', defaultValue: 0).getValue();
    if (_numInputStart?.value != currentIndex) {
      _numInputStart?.value = currentIndex.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 98,
      height: 48,
      child: GestureDetector(
        onTap: () {
          widget.onPressed.call();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            rive.RiveAnimation.asset(
              'assets/rive/start.riv',
              onInit: _startInit,
            ),
            widget.child
          ],
        ),
      ),
    );
  }
}

class PuzzleRedButton extends StatefulWidget {
  const PuzzleRedButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;

  @override
  State<PuzzleRedButton> createState() => _PuzzleRedButtonState();
}

class _PuzzleRedButtonState extends State<PuzzleRedButton> {
  bool get isPlaying => _controller?.isActive ?? false;

  rive.StateMachineController? _controller;
  rive.SMIInput<double>? _numInputRed;

  void _redInit(rive.Artboard artboardRed) async {
    final controllerPause = rive.StateMachineController.fromArtboard(artboardRed, 'Red');
    artboardRed.addController(controllerPause!);
    _numInputRed = controllerPause.findInput('state');
    StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
    int currentIndex = preferences.getInt('currentIndex', defaultValue: 0).getValue();
    if (_numInputRed?.value != currentIndex) {
      _numInputRed?.value = currentIndex.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 98,
      height: 48,
      child: GestureDetector(
        onTap: () {
          widget.onPressed.call();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            rive.RiveAnimation.asset(
              'assets/rive/red.riv',
              onInit: _redInit,
            ),
            widget.child
          ],
        ),
      ),
    );
  }
}

class PuzzleGreenButton extends StatefulWidget {
  const PuzzleGreenButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;

  @override
  State<PuzzleGreenButton> createState() => _PuzzleGreenButtonState();
}

class _PuzzleGreenButtonState extends State<PuzzleGreenButton> {
  bool get isPlaying => _controller?.isActive ?? false;

  rive.StateMachineController? _controller;
  rive.SMIInput<double>? _numInputGreen;

  void _greenInit(rive.Artboard artboardGreen) async {
    final controllerPause = rive.StateMachineController.fromArtboard(artboardGreen, 'Green');
    artboardGreen.addController(controllerPause!);
    _numInputGreen = controllerPause.findInput('state');
    StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
    int currentIndex = preferences.getInt('currentIndex', defaultValue: 0).getValue();
    if (_numInputGreen?.value != currentIndex) {
      _numInputGreen?.value = currentIndex.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 98,
      height: 48,
      child: GestureDetector(
        onTap: () {
          widget.onPressed.call();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            rive.RiveAnimation.asset(
              'assets/rive/green.riv',
              onInit: _greenInit,
            ),
            widget.child
          ],
        ),
      ),
    );
  }
}

class PuzzlePauseButton extends StatefulWidget {
  const PuzzlePauseButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  State<PuzzlePauseButton> createState() => _PuzzlePauseButtonState();
}

class _PuzzlePauseButtonState extends State<PuzzlePauseButton> {
  bool get isPlaying => _controller?.isActive ?? false;

  rive.StateMachineController? _controller;
  rive.SMIInput<double>? _numInputPause;

  void _pauseInit(rive.Artboard artboardPause) async {
    final controllerPause = rive.StateMachineController.fromArtboard(artboardPause, 'Pause');
    artboardPause.addController(controllerPause!);
    _numInputPause = controllerPause.findInput('state');
    StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
    int currentIndex = preferences.getInt('currentIndex', defaultValue: 0).getValue();
    if (_numInputPause?.value != currentIndex) {
      _numInputPause?.value = currentIndex.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: GestureDetector(
        onTap: () {
          widget.onPressed.call();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            rive.RiveAnimation.asset(
              'assets/rive/pause.riv',
              onInit: _pauseInit,
            ),
          ],
        ),
      ),
    );
  }
}

class PuzzleRestartButton extends StatefulWidget {
  const PuzzleRestartButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  State<PuzzleRestartButton> createState() => _PuzzleRestartButtonState();
}

class _PuzzleRestartButtonState extends State<PuzzleRestartButton> {
  bool get isPlaying => _controller?.isActive ?? false;

  rive.StateMachineController? _controller;
  rive.SMIInput<double>? _numInputRestart;

  void _restartInit(rive.Artboard artboardRestart) async {
    final controllerRestart = rive.StateMachineController.fromArtboard(artboardRestart, 'Restart');
    artboardRestart.addController(controllerRestart!);
    _numInputRestart = controllerRestart.findInput('state');
    StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
    int currentIndex = preferences.getInt('currentIndex', defaultValue: 0).getValue();
    if (_numInputRestart?.value != currentIndex) {
      _numInputRestart?.value = currentIndex.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: GestureDetector(
        onTap: () {
          widget.onPressed.call();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            rive.RiveAnimation.asset(
              'assets/rive/restart.riv',
              onInit: _restartInit,
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedTextButton extends ImplicitlyAnimatedWidget {
  const AnimatedTextButton(
      {Key? key,
      required this.child,
      required this.style,
      required this.onPressed,
      required Duration duration,
      Curve curve = Curves.linear,
      VoidCallback? onEnd})
      : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final Widget child;
  final ButtonStyle style;
  final VoidCallback onPressed;

  @override
  AnimatedWidgetBaseState<AnimatedTextButton> createState() => _AnimatedTextButtonState();
}

class _AnimatedTextButtonState extends AnimatedWidgetBaseState<AnimatedTextButton> {
  ButtonStyleTween? _style;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      child: widget.child,
      style: _style!.evaluate(animation),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _style = visitor(_style, widget.style, (dynamic value) => ButtonStyleTween(begin: value as ButtonStyle))
        as ButtonStyleTween?;
  }
}

class ButtonStyleTween extends Tween<ButtonStyle> {
  ButtonStyleTween({ButtonStyle? begin, ButtonStyle? end}) : super(begin: begin, end: end);

  @override
  ButtonStyle lerp(double t) => ButtonStyle.lerp(begin, end, t)!;
}
