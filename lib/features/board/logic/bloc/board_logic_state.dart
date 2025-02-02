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
  @override
  List<Object> get props => [currentPlayer];
}

final class PieceSelected extends BoardLogicState {
  final int selectedCellIndex;
  final PlayerType currentPlayer;
  final List<BoardCellModel> board;

  PieceSelected(this.selectedCellIndex, this.currentPlayer, this.board);
  @override
  List<Object> get props => [currentPlayer];
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
  final int kingIndex;
  IsCheckState(this.currentPlayer, this.board,this.kingIndex);
  @override
  List<Object> get props => [currentPlayer, kingIndex];
}

class ValidMovesHighlighted extends BoardLogicState {
  final PlayerType currentPlayer;
  final int selectedCellIndex;
  final List<int> validMoves;
  final List<BoardCellModel> board;
  final bool isInCheck;

  ValidMovesHighlighted(this.currentPlayer,this.selectedCellIndex, this.validMoves, this.board, this.isInCheck);

  @override
  List<Object> get props => [currentPlayer,selectedCellIndex, validMoves, board];
}


final class InvalidMoveAttempted extends BoardLogicState {
  final String reason;
  final bool isInCheck;
  final PlayerType currentPlayer;

  InvalidMoveAttempted(this.reason, this.isInCheck, this.currentPlayer);
  
  @override
  List<Object> get props => [currentPlayer];
}