part of 'board_cubit.dart';

@immutable
sealed class BoardState {}

final class BoardInitial extends BoardState {}

final class BoardLoaded extends BoardState {
  final List<BoardCellModel> board;

  BoardLoaded(this.board);
}

final class PieceSelected extends BoardState {}

final class PiecePositionChanged extends BoardState {}
