import 'package:chess/board/business/enums/player_type_enum.dart';
import 'package:chess/board/data/model/cell_model.dart';
import 'package:chess/board/presentation/bloc/board_logic_bloc.dart';
import 'package:chess/common/colors.dart';
import 'package:chess/pieces/map_piece_icons.dart';
import 'package:flutter/material.dart';

Widget getBoardGameWidget(
    List<BoardCellModel> initialBoard, BoardLogicBloc bloc, BoardLogicState state) {
  List<BoardCellModel> board = initialBoard; 
  int? selectedCellIndex;
  PlayerType? currentPlayer;
  List<int>? validMoves;
  List<int>? attackingPiecesIndices;
  
  if (state is BoardLoaded) {
    board = state.board;
    currentPlayer = state.currentPlayer;
  } else if (state is ValidMovesHighlighted) {
    board = state.board; // Always use the latest board state
    selectedCellIndex = state.selectedCellIndex;
    validMoves = state.validMoves;
  } else if (state is PieceSelected) {
    board = state.board;
    selectedCellIndex = state.selectedCellIndex;
    currentPlayer = state.currentPlayer;
  }
  else if(state is IsCheckState){
    board = state.board;
    currentPlayer = state.currentPlayer;
  }

  return Center(
    child: AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemCount: 64,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          bool isWhite = (index ~/ 8 + index % 8) % 2 == 0;

          final isSelected = selectedCellIndex == index;
          final isValidMove = validMoves?.contains(index) ?? false;

          return GestureDetector(
            onTap: () {
              if (selectedCellIndex == null) {
                bloc.add(SelectPiece(index,attackingPiecesIndices));
              } else if (selectedCellIndex == index) {
                bloc.add(DeselectPiece());
              } else {
                bloc.add(MovePiece(selectedCellIndex, index));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blueAccent
                    : isValidMove
                        ? Colors.green[100]
                        : (isWhite
                            ? AppColors.lightCellColor
                            : AppColors.blackCellColor),
              ),
              child: board[index].hasPiece
                  ? Center(
                      child: getPieceIcon(board[index].pieceEntity!.pieceId),
                    )
                  : null,
            ),
          );
        },
      ),
    ),
  );
}
