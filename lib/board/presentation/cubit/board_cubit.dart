import 'package:bloc/bloc.dart';
import 'package:chess/board/business/db/initial_board.dart';
import 'package:chess/board/business/enums/player_type_enum.dart';
import 'package:chess/board/data/repository_impl/move_validation.dart';
import 'package:chess/board/presentation/cubit/timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:chess/board/data/model/cell_model.dart';

part 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  final TimerCubit timerCubit;
  BoardCubit({required this.timerCubit}) : super(BoardInitial());

  List<BoardCellModel> _board = [];
  PlayerType _currentPlayer = PlayerType.white;

  void initializeBoard() {
    _board = generateInitialBoard();
    emit(BoardLoaded(_board, _currentPlayer));
    timerCubit.startTimer(_currentPlayer);  // Start the timer for the initial player
  }

  List<BoardCellModel> get board => _board;
  PlayerType get currentPlayer => _currentPlayer;

  void selectPiece(int cellIndex) {
    final selectedCell = _board[cellIndex];
    if (selectedCell.hasPiece &&
        selectedCell.pieceEntity!.playerType == _currentPlayer) {
      emit(PieceSelected(cellIndex, _currentPlayer));
    }
  }

  void movePiece(int fromIndex, int toIndex) {
    final movingPiece = _board[fromIndex];
    final targetCell = _board[toIndex];

    if (!movingPiece.hasPiece ||
        movingPiece.pieceEntity!.playerType != _currentPlayer) return;

    if (targetCell.hasPiece &&
        targetCell.pieceEntity!.playerType == _currentPlayer) {
      return;
    }

    var isValid = isValidMove(
      rank: movingPiece.pieceEntity!.rank,
      player: movingPiece.pieceEntity!.player,
      fromIndex: fromIndex,
      toIndex: toIndex,
      board: _board,
    );
    if (isValid) {
      _board[toIndex] = BoardCellModel(
        cellPosition: toIndex,
        hasPiece: true,
        pieceEntity: movingPiece.pieceEntity,
      );

      _board[fromIndex] = BoardCellModel(
        cellPosition: fromIndex,
        hasPiece: false,
        pieceEntity: null,
      );
      _currentPlayer = _currentPlayer == PlayerType.white ? PlayerType.black : PlayerType.white;
      emit(PieceMoved(fromIndex, toIndex));
      emit(BoardLoaded(_board, _currentPlayer));

      // Start the timer for the next player
      timerCubit.startTimer(_currentPlayer);
    } else {
      emit(InvalidMoveAttempted('move not valid'));
    }
  }
}
