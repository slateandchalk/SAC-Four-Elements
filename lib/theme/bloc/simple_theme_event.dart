part of 'simple_theme_bloc.dart';

abstract class SimpleThemeEvent extends Equatable {
  const SimpleThemeEvent();
}

class SimpleThemeChanged extends SimpleThemeEvent {
  const SimpleThemeChanged({required this.themeIndex});

  final int themeIndex;

  @override
  List<Object> get props => [themeIndex];
}
