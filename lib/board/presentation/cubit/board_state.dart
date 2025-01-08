part of 'board_cubit.dart';

@immutable
sealed class BoardState {}

final class BoardInitial extends BoardState {}

final class BoardLoaded extends BoardState {
  final List<BoardCellModel> board;
  final String currentPlayer;

  BoardLoaded(this.board, this.currentPlayer);
}

final class PieceSelected extends BoardState {
  final int selectedCellIndex;
  final String currentPlayer;

  PieceSelected(this.selectedCellIndex,this.currentPlayer);
}

final class PieceMoved extends BoardState {
  final int fromIndex;
  final int toIndex;

  PieceMoved(this.fromIndex, this.toIndex);
}
final class InvalidMoveAttempted extends BoardState {
  final String reason;

  InvalidMoveAttempted(this.reason);
}

