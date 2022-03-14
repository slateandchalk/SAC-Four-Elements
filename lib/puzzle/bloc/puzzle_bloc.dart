import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sac_slide_puzzle/models/models.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc(this._size, {this.random}) : super(const PuzzleState()) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<TileTapped>(_onTileTapped);
    on<PuzzleReset>(_onPuzzleReset);
  }

  int _size;
  final Random? random;

  void _onPuzzleInitialized(
      PuzzleInitialized event, Emitter<PuzzleState> emit) {
    final puzzle = _generatePuzzle(event.size, shuffle: event.shufflePuzzle);
    _size = event.size;
    emit(PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles()));
  }

  void _onTileTapped(TileTapped event, Emitter<PuzzleState> emit) {
    final tappedTile = event.tile;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(tappedTile)) {
        final mutablePuzzle = Puzzle(tiles: [...state.puzzle.tiles]);
        final puzzle = mutablePuzzle.moveTiles(tappedTile, []);
        if (puzzle.isComplete()) {
          emit(state.copyWith(
              puzzle: puzzle.sort(),
              puzzleStatus: PuzzleStatus.complete,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile));
        } else {
          emit(state.copyWith(
              puzzle: puzzle.sort(),
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile));
        }
      } else {
        emit(
          state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
        );
      }
    } else {
      emit(
        state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
      );
    }
  }

  void _onPuzzleReset(PuzzleReset event, Emitter<PuzzleState> emit) {
    final puzzle = _generatePuzzle(_size);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  Puzzle _generatePuzzle(int size, {bool shuffle = true}) {
    final correctPosition = <Position>[];
    final currentPosition = <Position>[];
    var whitespacePosition = Position(x: size, y: size);

    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        if (x == size && y == size) {
          correctPosition.add(whitespacePosition);
          currentPosition.add(whitespacePosition);
        } else {
          final position = Position(x: x, y: y);
          correctPosition.add(position);
          currentPosition.add(position);
        }
      }
    }

    if (shuffle) {
      currentPosition.shuffle(random);
    }

    var tiles = _generateTileFromList(size, correctPosition, currentPosition);

    var puzzle = Puzzle(tiles: tiles);

    if (shuffle) {
      while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
        currentPosition.shuffle(random);
        tiles = _generateTileFromList(size, correctPosition, currentPosition);
        puzzle = Puzzle(tiles: tiles);
      }
    }
    return puzzle;
  }

  List<Tile> _generateTileFromList(int size, List<Position> correctPosition,
      List<Position> currentPosition) {
    final whitespacePosition = Position(x: size, y: size);
    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            value: i,
            correctPosition: whitespacePosition,
            currentPosition: currentPosition[i - 1],
            isWhitespace: true,
          )
        else
          Tile(
            value: i,
            correctPosition: correctPosition[i - 1],
            currentPosition: currentPosition[i - 1],
          )
    ];
  }
}
