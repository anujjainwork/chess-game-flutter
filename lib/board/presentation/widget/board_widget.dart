import 'package:chess/board/data/model/cell_model.dart';
import 'package:chess/common/colors.dart';
import 'package:chess/pieces/map_piece_icons.dart';
import 'package:flutter/material.dart';

Widget getBoardGameWidget(List<BoardCellModel> boardCellModel) {
  return Center(
    child: AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemBuilder: (context, index) {
          bool isWhite = (index ~/ 8 + index % 8) % 2 == 0;
          return GestureDetector(
            onTap: () {
              print('${index}th cell tapped');
            },
            child: Container(
              color: isWhite ? AppColors.lightCellColor : AppColors.blackCellColor,
              child: boardCellModel[index].hasPiece
                  ? getPieceIcon(boardCellModel[index].pieceId ?? '')
                  : null,
            ),
          );
        },
        itemCount: 64,
        physics: const NeverScrollableScrollPhysics(),
      ),
    ),
  );
}
