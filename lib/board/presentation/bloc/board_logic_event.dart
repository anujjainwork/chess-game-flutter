part of 'board_logic_bloc.dart';

sealed class BoardLogicEvent extends Equatable {
  const BoardLogicEvent();

  @override
  List<Object?> get props => [];
}
class InitializeBoard extends BoardLogicEvent {}

class SelectPiece extends BoardLogicEvent {
  final int cellIndex;

  SelectPiece(this.cellIndex);

  @override
  List<Object?> get props => [cellIndex];
}
class DeselectPiece extends BoardLogicEvent{
}

class MovePiece extends BoardLogicEvent {
  final int fromIndex;
  final int toIndex;

  MovePiece(this.fromIndex, this.toIndex);

  @override
  List<Object?> get props => [fromIndex, toIndex];
}

class PlayerIsInCheck extends BoardLogicEvent {
  final PlayerType playerType;
  PlayerIsInCheck(this.playerType);
}