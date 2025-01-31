import 'package:chess/features/1v1_mode/cubit/one_vs_one_cubit.dart';
import 'package:chess/features/1vsBot/bot/logic/one_vs_bot_cubit.dart';
import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:chess/features/board/data/model/cell_model.dart';
import 'package:chess/features/board/logic/bloc/board_logic_bloc.dart';
import 'package:chess/common/colors.dart';
import 'package:chess/common/utils.dart';
import 'package:chess/common/map_piece_icons.dart';
import 'package:chess/features/board/logic/cubit/move_history_cubit.dart';
import 'package:flutter/material.dart';

Widget getBoardGameWidget(
    List<BoardCellModel> initialBoard,
    BoardLogicBloc bloc,
    BoardLogicState state,
    MoveHistoryState moveHistoryState,
    OneVsOneCubit? oneVsOneCubit,
    OneVsBotCubit? oneVsBotCubit,
    BuildContext context) {
  List<BoardCellModel> board = initialBoard;
  int? selectedCellIndex;
  List<int>? validMoves;
  List<int>? attackingPiecesIndices;

  if (moveHistoryState is MoveRedo || moveHistoryState is MoveUndo) {
    initialBoard = moveHistoryState.props[0] as List<BoardCellModel>;
  } else if (state is BoardLoaded) {
    board = state.board;
  } else if (state is ValidMovesHighlighted) {
    board = state.board;
    selectedCellIndex = state.selectedCellIndex;
    validMoves = state.validMoves;
  } else if (state is PieceSelected) {
    board = state.board;
    selectedCellIndex = state.selectedCellIndex;
  } else if (state is IsCheckState) {
    board = state.board;
  }

  final labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  final rowLabels = ['8', '7', '6', '5', '4', '3', '2', '1'];

  // Dynamically calculate board and cell sizes
  final double boardSize =
      getDynamicWidth(context, 85); // Use 85% of the screen width for the board
  final double cellSize = boardSize / 8;
  final double labelSize =
      getDynamicHeight(context, 4); // Adjust percentage for label size

  return Center(
    child: Container(
      padding: EdgeInsets.symmetric(vertical: getDynamicHeight(context, 1.5)),
      width: getDynamicWidth(context, 97), // Outer container width
      decoration: BoxDecoration(
          color: AppColors.boxColor1,
          borderRadius: BorderRadius.circular(12.0),
          gradient: AppColors.boardWidgetGradient),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row labels (8 to 1)
              Column(
                children: List.generate(8, (index) {
                  return SizedBox(
                    height: cellSize, // Match cell size
                    width: labelSize,
                    child: Center(
                      child: Text(
                        rowLabels[index],
                        style: TextStyle(
                            fontSize: labelSize * 0.4, color: Colors.white),
                      ),
                    ),
                  );
                }),
              ),
              // Chessboard
              SizedBox(
                width: boardSize,
                height: boardSize,
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
                          print('1v1 selected');
                          if(oneVsOneCubit!=null) oneVsOneCubit.selectPieceEvent(index, attackingPiecesIndices);
                          print('1vbot selected');
                          if(oneVsBotCubit!=null) oneVsBotCubit.selectPieceEvent(index, attackingPiecesIndices);
                          // bloc.add(SelectPiece(index, attackingPiecesIndices));
                        } else if (selectedCellIndex == index) {
                          if(oneVsOneCubit!=null) oneVsOneCubit.deselectPieceEvent();
                          if(oneVsBotCubit!=null) oneVsBotCubit.deselectPieceEvent();
                          // bloc.add(DeselectPiece());
                        } else {
                          bloc.add(MovePiece(selectedCellIndex, index));
                        }
                      },
                      child: Container(
                        width: cellSize,
                        height: cellSize,
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
                            ? Transform.rotate(
                                angle: board[index].pieceEntity!.playerType ==
                                        PlayerType.white
                                    ? 0
                                    : 3.14159,
                                child: Center(
                                  child: getPieceIcon(
                                      board[index].pieceEntity!.pieceId),
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Column labels (A to H)
          SizedBox(
              height: getDynamicHeight(
                  context, 1.5)), // Padding between board and column labels
          Row(
            children: [
              SizedBox(
                  width: labelSize), // Fixed width to align with row labels
              SizedBox(
                width: boardSize,
                child: Row(
                  children: List.generate(8, (index) {
                    return SizedBox(
                      width: cellSize, // Match cell size
                      height:
                          labelSize * 0.8, // Adjust height for column labels
                      child: Center(
                        child: Text(
                          labels[index],
                          style: TextStyle(
                              fontSize: labelSize * 0.4, color: Colors.white),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
