part of 'puzzle_bloc.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();

  @override
  List<Object?> get props => [];
}

class PuzzleInitialized extends PuzzleEvent {
  const PuzzleInitialized({required this.shufflePuzzle, required this.size});

  final bool shufflePuzzle;
  final int size;

  @override
  List<Object?> get props => [shufflePuzzle, size];
}

class TileTapped extends PuzzleEvent {
  const TileTapped(this.tile);
  final Tile tile;

  @override
  List<Object?> get props => [tile];
}

class PuzzleReset extends PuzzleEvent {
  const PuzzleReset();
}
