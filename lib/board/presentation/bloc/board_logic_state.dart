part of 'board_logic_bloc.dart';

sealed class BoardLogicState extends Equatable {
  const BoardLogicState();
  
  @override
  List<Object> get props => [];
}
final class BoardLogicInitial extends BoardLogicState {}

final class BoardLoaded extends BoardLogicState {
  final List<BoardCellModel> board;
  final PlayerType currentPlayer;

  BoardLoaded(this.board, this.currentPlayer);
}

final class PieceSelected extends BoardLogicState {
  final int selectedCellIndex;
  final PlayerType currentPlayer;

  PieceSelected(this.selectedCellIndex, this.currentPlayer);
}

final class PieceDeselected extends BoardLogicState{
}

final class PieceMoved extends BoardLogicState {
  final int fromIndex;
  final int toIndex;

  PieceMoved(this.fromIndex, this.toIndex);
}

final class InvalidMoveAttempted extends BoardLogicState {
  final String reason;

  InvalidMoveAttempted(this.reason);
}
