part of 'countdown_bloc.dart';

enum CountdownStatus { notStarted, loading, started }

class CountdownState extends Equatable {
  const CountdownState({
    required this.secondsToBegin,
    this.isCountdownRunning = false,
  });

  final bool isCountdownRunning;
  final int secondsToBegin;

  CountdownStatus get status => isCountdownRunning && secondsToBegin > 0
      ? CountdownStatus.loading
      : (secondsToBegin == 0
          ? CountdownStatus.started
          : CountdownStatus.notStarted);

  @override
  List<Object> get props => [isCountdownRunning, secondsToBegin];

  CountdownState copyWith({
    bool? isCountdownRunning,
    int? secondsToBegin,
  }) {
    return CountdownState(
      isCountdownRunning: isCountdownRunning ?? this.isCountdownRunning,
      secondsToBegin: secondsToBegin ?? this.secondsToBegin,
    );
  }
}
