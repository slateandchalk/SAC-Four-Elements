import 'package:equatable/equatable.dart';
import 'package:sac_slide_puzzle/models/models.dart';

class Tile extends Equatable {
  const Tile(
      {required this.value,
      required this.correctPosition,
      required this.currentPosition,
      this.isWhitespace = false});

  final int value;
  final Position correctPosition;
  final Position currentPosition;
  final bool isWhitespace;

  Tile copyWith({required Position currentPosition}) {
    return Tile(
      value: value,
      correctPosition: correctPosition,
      currentPosition: currentPosition,
      isWhitespace: isWhitespace,
    );
  }

  @override
  List<Object?> get props => [
        value,
        currentPosition,
        correctPosition,
        isWhitespace,
      ];
}
