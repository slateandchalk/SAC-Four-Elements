part of 'simple_theme_bloc.dart';

class SimpleThemeState extends Equatable {
  const SimpleThemeState({
    required this.themes,
    this.theme = const AirTheme(),
  });

  /// The list of all available [SimpleTheme]s.
  final List<SimpleTheme> themes;

  /// Currently selected [SimpleTheme].
  final SimpleTheme theme;

  @override
  List<Object> get props => [themes, theme];

  SimpleThemeState copyWith({
    List<SimpleTheme>? themes,
    SimpleTheme? theme,
  }) {
    return SimpleThemeState(
      themes: themes ?? this.themes,
      theme: theme ?? this.theme,
    );
  }
}
