import 'package:chess/board/business/enums/player_type_enum.dart';
import 'package:chess/board/data/model/cell_model.dart';
import 'package:chess/board/presentation/cubit/board_cubit.dart';
import 'package:chess/common/colors.dart';
import 'package:chess/pieces/map_piece_icons.dart';
import 'package:flutter/material.dart';

Widget getBoardGameWidget(
    List<BoardCellModel> board, BoardCubit cubit, BoardState state) {
  int? selectedCellIndex;
  PlayerType? currentPlayer;

  if (state is PieceSelected) {
    selectedCellIndex = state.selectedCellIndex;
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

          // Highlight selected cell
          final isSelected = selectedCellIndex == index;

          return GestureDetector(
            onTap: () {
              if (selectedCellIndex == null) {
                // Select a piece
                cubit.selectPiece(index);
              } else if (selectedCellIndex == index) {
                // Deselect the piece
                cubit.emit(BoardLoaded(board,currentPlayer!));
              } else {
                // Attempt to move the piece
                cubit.movePiece(selectedCellIndex!, index);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blueAccent // Highlight selected cell
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
