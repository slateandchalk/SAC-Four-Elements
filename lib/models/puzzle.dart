import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:sac_slide_puzzle/models/models.dart';

class Puzzle extends Equatable {
  const Puzzle({required this.tiles});

  final List<Tile> tiles;

  int getDimension() {
    return sqrt(tiles.length).toInt();
  }

  Tile getWhitespaceTile() {
    return tiles.singleWhere((tile) => tile.isWhitespace);
  }

  int getNumberOfCorrectTiles() {
    final whitespaceTile = getWhitespaceTile();
    var numberOfCorrectTiles = 0;
    for (final tile in tiles) {
      if (tile != whitespaceTile) {
        if (tile.currentPosition == tile.correctPosition) {
          numberOfCorrectTiles++;
        }
      }
    }
    return numberOfCorrectTiles;
  }

  bool isComplete() {
    return (tiles.length - 1) - getNumberOfCorrectTiles() == 0;
  }

  bool isTileMovable(Tile tile) {
    final whitespaceTile = getWhitespaceTile();

    if (tile == whitespaceTile) {
      return false;
    }

    if (whitespaceTile.currentPosition.x != tile.currentPosition.x &&
        whitespaceTile.currentPosition.y != tile.currentPosition.y) {
      return false;
    }

    return true;
  }

  bool isSolvable() {
    final size = getDimension();
    final height = tiles.length ~/ size;

    assert(
      size * height == tiles.length,
      'tiles must be equal to size * height',
    );

    final inversions = countInversions();

    if (size.isOdd) {
      return inversions.isEven;
    }

    final whitespace = tiles.singleWhere((tile) => tile.isWhitespace);
    final whitespaceRow = whitespace.currentPosition.y;

    if (((height - whitespaceRow) + 1).isOdd) {
      return inversions.isEven;
    } else {
      return inversions.isOdd;
    }
  }

  int countInversions() {
    var count = 0;
    for (var a = 0; a < tiles.length; a++) {
      final tileA = tiles[a];

      if (tileA.isWhitespace) {
        continue;
      }

      for (var b = a + 1; b < tiles.length; b++) {
        final tileB = tiles[b];
        if (isInversion(tileA, tileB)) {
          count++;
        }
      }
    }
    return count;
  }

  bool isInversion(Tile a, Tile b) {
    if (!b.isWhitespace && a.value != b.value) {
      if (b.value < a.value) {
        return b.currentPosition.compareTo(a.currentPosition) > 0;
      } else {
        return a.currentPosition.compareTo(b.currentPosition) > 0;
      }
    }
    return false;
  }

  Puzzle moveTiles(Tile tile, List<Tile> tilesToSwap) {
    final whitespaceTile = getWhitespaceTile();
    final deltaX = whitespaceTile.currentPosition.x - tile.currentPosition.x;
    final deltaY = whitespaceTile.currentPosition.y - tile.currentPosition.y;

    if ((deltaX.abs() + deltaY.abs()) > 1) {
      final shiftPointX = tile.currentPosition.x + deltaX.sign;
      final shiftPointY = tile.currentPosition.y + deltaY.sign;
      final tileToSwapWith = tiles.singleWhere(
        (tile) =>
            tile.currentPosition.x == shiftPointX &&
            tile.currentPosition.y == shiftPointY,
      );
      tilesToSwap.add(tile);
      return moveTiles(tileToSwapWith, tilesToSwap);
    } else {
      tilesToSwap.add(tile);
      return _swapTiles(tilesToSwap);
    }
  }

  Puzzle _swapTiles(List<Tile> tilesToSwap) {
    for (final tileToSwap in tilesToSwap.reversed) {
      final tileIndex = tiles.indexOf(tileToSwap);
      final tile = tiles[tileIndex];
      final whitespaceTile = getWhitespaceTile();
      final whitespaceTileIndex = tiles.indexOf(whitespaceTile);

      tiles[tileIndex] =
          tile.copyWith(currentPosition: whitespaceTile.currentPosition);
      tiles[whitespaceTileIndex] =
          whitespaceTile.copyWith(currentPosition: tile.currentPosition);
    }
    return Puzzle(tiles: tiles);
  }

  Puzzle sort() {
    final sortedTiles = tiles.toList()
      ..sort((tileA, tileB) {
        return tileA.currentPosition.compareTo(tileB.currentPosition);
      });
    return Puzzle(tiles: sortedTiles);
  }

  @override
  List<Object?> get props => [tiles];
}
