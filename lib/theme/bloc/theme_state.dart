part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState({required this.themes, this.theme = const AirTheme()});

  final List<PuzzleTheme> themes;
  final PuzzleTheme theme;

  @override
  List<Object?> get props => [themes, theme];

  ThemeState copyWith({List<PuzzleTheme>? themes, PuzzleTheme? theme}) {
    return ThemeState(
        themes: themes ?? this.themes, theme: theme ?? this.theme);
  }
}
