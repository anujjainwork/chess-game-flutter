import 'package:bloc/bloc.dart';
import 'package:chess/board/business/db/initial_board.dart';
import 'package:chess/board/data/repository_impl/move_validation.dart';
import 'package:flutter/material.dart';
import 'package:chess/board/data/model/cell_model.dart';

part 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit() : super(BoardInitial());

  List<BoardCellModel> _board = [];
  String _currentPlayer = 'white'; // Track the current player (white or black)

  void initializeBoard() {
    _board = generateInitialBoard();
    emit(BoardLoaded(_board, _currentPlayer));
  }

  List<BoardCellModel> get board => _board;
  String get currentPlayer => _currentPlayer;

  void selectPiece(int cellIndex) {
    final selectedCell = _board[cellIndex];
    if (selectedCell.hasPiece &&
        selectedCell.pieceEntity!.player == _currentPlayer) {
      emit(PieceSelected(cellIndex, _currentPlayer));
    }
  }

  void movePiece(int fromIndex, int toIndex) {
    final movingPiece = _board[fromIndex];
    final targetCell = _board[toIndex];

    // Check if the move is valid (based on turn and if the target cell is empty or has an opposing piece)
    if (!movingPiece.hasPiece ||
        movingPiece.pieceEntity!.player != _currentPlayer) return;

    if (targetCell.hasPiece &&
        targetCell.pieceEntity!.player == _currentPlayer) {
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
      _currentPlayer = _currentPlayer == 'white' ? 'black' : 'white';
      emit(PieceMoved(fromIndex, toIndex));
      emit(BoardLoaded(_board, _currentPlayer));
    } else {
      emit(InvalidMoveAttempted('move not valid'));
    }
  }
}
