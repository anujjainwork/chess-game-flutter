import 'package:bloc/bloc.dart';
import 'package:chess/features/board/business/db/initial_board.dart';
import 'package:chess/features/board/data/model/cell_model.dart';
import 'package:equatable/equatable.dart';

part 'move_history_state.dart';

class MoveHistoryCubit extends Cubit<MoveHistoryState> {
  MoveHistoryCubit() : super(MoveHistoryInitial());

  List<List<BoardCellModel>> undoStack = [generateInitialBoard()];
  List<List<BoardCellModel>> redoStack = [];

  void makeMove(List<BoardCellModel> newBoard) {
    undoStack.add(newBoard); // Save current state
    redoStack.clear(); // Clear redo stack after a new move
  }

  void undoMove() {
    if (undoStack.length > 1) {
      redoStack.add(undoStack.removeLast()); // Save current state in redo stack
      emit(MoveUndo(updatedBoard: List.from(undoStack.last))); // Emit previous state
    }
  }

  void redoMove() {
    if (redoStack.isNotEmpty) {
      final nextBoard = redoStack.removeLast();
      undoStack.add(nextBoard); // Save current state in undo stack
      emit(MoveRedo(updatedBoard: List.from(nextBoard))); // Emit next state
    } else {
      emit(CannotRedo());
    }
  }

  bool canUndo() => undoStack.length > 1;
  bool canRedo() => redoStack.isNotEmpty;
}
