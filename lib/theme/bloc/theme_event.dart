part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class ThemeChanged extends ThemeEvent {
  const ThemeChanged({required this.themeIndex});

  final int themeIndex;

  @override
  List<Object?> get props => [themeIndex];
}

class ThemeUpdated extends ThemeEvent {
  const ThemeUpdated({required this.theme});

  final PuzzleTheme theme;

  @override
  List<Object?> get props => [theme];
}
