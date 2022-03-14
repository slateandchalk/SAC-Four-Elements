part of 'audio_control_bloc.dart';

class AudioControlState extends Equatable {
  const AudioControlState({this.muted = true, this.stopped = true});

  final bool muted;
  final bool stopped;

  @override
  List<Object?> get props => [muted, stopped];
}
