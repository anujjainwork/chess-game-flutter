part of 'move_history_cubit.dart';

sealed class MoveHistoryState extends Equatable {
  const MoveHistoryState();

  @override
  List<Object> get props => [];
}

final class MoveHistoryInitial extends MoveHistoryState {}

final class MoveUndo extends MoveHistoryState {
  final List<BoardCellModel> updatedBoard;
  @override
  List<Object> get props => [updatedBoard];

  const MoveUndo({required this.updatedBoard});
}

final class MoveRedo extends MoveHistoryState {
  final List<BoardCellModel> updatedBoard;
  @override
  List<Object> get props => [updatedBoard];

  MoveRedo({required this.updatedBoard});
}

final class CannotUndo extends MoveHistoryState {}

final class CannotRedo extends MoveHistoryState {}
