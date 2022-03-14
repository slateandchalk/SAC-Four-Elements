import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sac_slide_puzzle/models/models.dart';

part 'countdown_event.dart';
part 'countdown_state.dart';

class CountdownBloc extends Bloc<CountdownEvent, CountdownState> {
  CountdownBloc({
    required this.secondsToBegin,
    required Ticker ticker,
  })  : _ticker = ticker,
        super(CountdownState(secondsToBegin: secondsToBegin)) {
    on<CountdownStarted>(_onCountdownStarted);
    on<CountdownTicked>(_onCountdownTicked);
    on<CountdownStopped>(_onCountdownStopped);
    on<CountdownReset>(_onCountdownReset);
  }

  final int secondsToBegin;

  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _startTicker() {
    _tickerSubscription?.cancel();
    _tickerSubscription =
        _ticker.tick().listen((_) => add(const CountdownTicked()));
  }

  void _onCountdownStarted(
    CountdownStarted event,
    Emitter<CountdownState> emit,
  ) {
    _startTicker();
    emit(
      state.copyWith(
        isCountdownRunning: true,
        secondsToBegin: secondsToBegin,
      ),
    );
  }

  void _onCountdownTicked(
    CountdownTicked event,
    Emitter<CountdownState> emit,
  ) {
    if (state.secondsToBegin == 0) {
      _tickerSubscription?.pause();
      emit(state.copyWith(isCountdownRunning: false));
    } else {
      emit(state.copyWith(secondsToBegin: state.secondsToBegin - 1));
    }
  }

  void _onCountdownStopped(
    CountdownStopped event,
    Emitter<CountdownState> emit,
  ) {
    _tickerSubscription?.pause();
    emit(
      state.copyWith(
        isCountdownRunning: false,
        secondsToBegin: secondsToBegin,
      ),
    );
  }

  void _onCountdownReset(
    CountdownReset event,
    Emitter<CountdownState> emit,
  ) {
    _startTicker();
    emit(
      state.copyWith(
        isCountdownRunning: true,
        secondsToBegin: event.secondsToBegin ?? secondsToBegin,
      ),
    );
  }
}
