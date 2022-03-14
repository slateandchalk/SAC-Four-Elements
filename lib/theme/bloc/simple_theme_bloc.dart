import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';

part 'simple_theme_event.dart';
part 'simple_theme_state.dart';

class SimpleThemeBloc extends Bloc<SimpleThemeEvent, SimpleThemeState> {
  SimpleThemeBloc({required List<SimpleTheme> themes})
      : super(SimpleThemeState(themes: themes)) {
    on<SimpleThemeChanged>(_onSimpleThemeChanged);
  }

  void _onSimpleThemeChanged(
    SimpleThemeChanged event,
    Emitter<SimpleThemeState> emit,
  ) {
    emit(state.copyWith(theme: state.themes[event.themeIndex]));
  }
}
