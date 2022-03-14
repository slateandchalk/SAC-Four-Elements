import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'audio_control_event.dart';
part 'audio_control_state.dart';

class AudioControlBloc extends Bloc<AudioControlEvent, AudioControlState> {
  AudioControlBloc() : super(const AudioControlState()) {
    on<AudioToggled>(_onAudioToggled);
    on<AudioStopped>(_onAudioStopped);
  }

  void _onAudioToggled(AudioToggled event, Emitter<AudioControlState> emit) {
    emit(AudioControlState(muted: !state.muted));
  }

  void _onAudioStopped(AudioStopped event, Emitter<AudioControlState> emit) {
    emit(AudioControlState(stopped: event.stopped));
  }
}
