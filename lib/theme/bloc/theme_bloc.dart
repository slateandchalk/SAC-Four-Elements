import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({required List<PuzzleTheme> themes})
      : super(ThemeState(themes: themes)) {
    on<ThemeChanged>(_onThemeChanged);
    on<ThemeUpdated>(_onThemeUpdated);
  }

  void _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) {
    emit(state.copyWith(theme: state.themes[event.themeIndex]));
  }

  void _onThemeUpdated(ThemeUpdated event, Emitter<ThemeState> emit) {
    final themeIndex =
        state.themes.indexWhere((theme) => theme.name == event.theme.name);
    if (themeIndex != -1) {
      final newTheme = [...state.themes];
      newTheme[themeIndex] = event.theme;
      emit(state.copyWith(themes: newTheme, theme: event.theme));
    }
  }
}
