part of 'board_logic_bloc.dart';

sealed class BoardLogicState extends Equatable {
  const BoardLogicState();
  
  @override
  List<Object> get props => [];

  get isInCheck => null;
}
final class BoardLogicInitial extends BoardLogicState {}

final class BoardLoaded extends BoardLogicState {
  final List<BoardCellModel> board;
  final PlayerType currentPlayer;
  final List<PieceEntity> capturedPiecesWhite;
  final List<PieceEntity> capturedPiecesBlack;

  BoardLoaded(this.board, this.currentPlayer, this.capturedPiecesWhite, this.capturedPiecesBlack);
}

final class PieceSelected extends BoardLogicState {
  final int selectedCellIndex;
  final PlayerType currentPlayer;
  final List<BoardCellModel> board;

  PieceSelected(this.selectedCellIndex, this.currentPlayer, this.board);
}

final class PieceDeselected extends BoardLogicState{
}

final class PieceMoved extends BoardLogicState {
  final int fromIndex;
  final int toIndex;

  PieceMoved(this.fromIndex, this.toIndex);
}
final class IsCheckState extends BoardLogicState{
  final PlayerType currentPlayer;
  // final List<int> attackingPieceIndices;
  final List<BoardCellModel> board;
  IsCheckState(this.currentPlayer, this.board,);
}

class ValidMovesHighlighted extends BoardLogicState {
  final int selectedCellIndex;
  final List<int> validMoves;
  final List<BoardCellModel> board;
  final bool isInCheck;

  ValidMovesHighlighted(this.selectedCellIndex, this.validMoves, this.board, this.isInCheck);

  @override
  List<Object> get props => [selectedCellIndex, validMoves, board];
}


final class InvalidMoveAttempted extends BoardLogicState {
  final String reason;
  final bool isInCheck;

  InvalidMoveAttempted(this.reason, this.isInCheck);
}