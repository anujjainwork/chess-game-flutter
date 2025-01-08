import 'package:bloc/bloc.dart';
import 'package:chess/board/business/db/initial_board.dart';
import 'package:flutter/material.dart';
import 'package:chess/board/data/model/cell_model.dart';

part 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit() : super(BoardInitial());

  List<BoardCellModel> _board = [];

  // Initialize the board
  void initializeBoard() {
    _board = generateInitialBoard();
    emit(BoardLoaded(_board));
  }

  List<BoardCellModel> get board => _board;
}
