part of 'audio_control_bloc.dart';

abstract class AudioControlEvent extends Equatable {
  const AudioControlEvent();

  @override
  List<Object> get props => [];
}

class AudioToggled extends AudioControlEvent {}

class AudioStopped extends AudioControlEvent {
  const AudioStopped(this.stopped);

  final bool stopped;
}
