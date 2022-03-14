import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sac_slide_puzzle/models/models.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerState()) {
    on<TimerStarted>(_onTimerStated);
    on<TimerTicked>(_onTimerTicked);
    on<TimerStopped>(_onTimerStopped);
    on<TimerReset>(_onTimerReset);
    on<TimerResume>(_onTimerResume);
  }

  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  void _onTimerStated(TimerStarted event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick()
        .listen((secondsElapsed) => add(TimerTicked(secondsElapsed)));
    emit(state.copyWith(isRunning: true));
  }

  void _onTimerTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(state.copyWith(secondsElapsed: event.secondsElapsed));
  }

  void _onTimerStopped(TimerStopped event, Emitter<TimerState> emit) {
    _tickerSubscription?.pause();
    emit(state.copyWith(isRunning: false));
  }

  void _onTimerReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(state.copyWith(secondsElapsed: 0));
  }

  void _onTimerResume(TimerResume event, Emitter<TimerState> emit) {
    _tickerSubscription?.resume();
    emit(state.copyWith(secondsElapsed: event.secondsElapsed));
  }
}
