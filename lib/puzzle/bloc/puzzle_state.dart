part of 'puzzle_bloc.dart';

enum PuzzleStatus { incomplete, complete }

enum TileMovementStatus { nothingTapped, cannotBeMoved, moved }

class PuzzleState extends Equatable {
  const PuzzleState(
      {this.puzzle = const Puzzle(tiles: []),
      this.puzzleStatus = PuzzleStatus.incomplete,
      this.tileMovementStatus = TileMovementStatus.nothingTapped,
      this.numberOfCorrectTiles = 0,
      this.numberOfMoves = 0,
      this.lastTappedTile});

  final Puzzle puzzle;

  final PuzzleStatus puzzleStatus;

  final TileMovementStatus tileMovementStatus;

  final int numberOfCorrectTiles;

  final int numberOfMoves;

  final Tile? lastTappedTile;

  int get numberOfTilesLeft => puzzle.tiles.length - numberOfCorrectTiles - 1;

  PuzzleState copyWith({
    Puzzle? puzzle,
    PuzzleStatus? puzzleStatus,
    TileMovementStatus? tileMovementStatus,
    int? numberOfCorrectTiles,
    int? numberOfMoves,
    Tile? lastTappedTile,
  }) {
    return PuzzleState(
      puzzle: puzzle ?? this.puzzle,
      puzzleStatus: puzzleStatus ?? this.puzzleStatus,
      tileMovementStatus: tileMovementStatus ?? this.tileMovementStatus,
      numberOfCorrectTiles: numberOfCorrectTiles ?? this.numberOfCorrectTiles,
      numberOfMoves: numberOfMoves ?? this.numberOfMoves,
      lastTappedTile: lastTappedTile ?? this.lastTappedTile,
    );
  }

  @override
  List<Object?> get props => [
        puzzle,
        puzzleStatus,
        tileMovementStatus,
        numberOfCorrectTiles,
        numberOfMoves,
        lastTappedTile
      ];
}
