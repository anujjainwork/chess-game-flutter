import 'package:chessmate/common/utils.dart';
import 'package:chessmate/features/1v1_mode/cubit/one_vs_one_cubit.dart';
import 'package:chessmate/features/1vsBot/bot/logic/one_vs_bot_cubit.dart';
import 'package:chessmate/features/1vsBot/presentation/bot_widget.dart';
import 'package:chessmate/features/board/business/enums/game_modes_enum.dart';
import 'package:chessmate/features/board/business/enums/player_type_enum.dart';
import 'package:chessmate/features/board/data/model/cell_model.dart';
import 'package:chessmate/features/board/logic/bloc/board_logic_bloc.dart';
import 'package:chessmate/features/board/logic/bloc/game_status_bloc.dart';
import 'package:chessmate/features/board/logic/cubit/move_history_cubit.dart';
import 'package:chessmate/common/widgets/board_widget.dart';
import 'package:chessmate/common/widgets/captured_piece_widget.dart';
import 'package:chessmate/common/widgets/move_history_widget.dart';
import 'package:chessmate/common/widgets/resign_draw_widget.dart';
import 'package:chessmate/common/widgets/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget getBoardFullWidget(
    BuildContext context,
    BoardLogicBloc bloc,
    BoardLogicState state,
    GameStatusBloc gameStatusBloc,
    MoveHistoryCubit moveHistoryCubit,
    OneVsOneCubit? oneVsOneCubit,
    OneVsBotCubit? oneVsBotCubit
    ) {
      final currentPlayer = state.props[0] as PlayerType;
  return GestureDetector(
    onTap: () {
      if(state is PieceSelected){
        bloc.add(DeselectPiece());
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(bloc.gameMode == GameMode.oneVsOne)  Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Opacity(
                opacity: currentPlayer == PlayerType.black ? 1 : 0.2,
                child: getMoveHistoryWidgetBlack(context,
                    MainAxisAlignment.spaceEvenly, moveHistoryCubit,currentPlayer),
              ),
              getResignDrawWidgets(
                  context, MainAxisAlignment.spaceEvenly, gameStatusBloc, false, bloc.gameMode),
            ],
          ),
          SizedBox(
            height: getDynamicHeight(context, 2),
          ),
          if(bloc.gameMode == GameMode.oneVsOne) Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getCapturedPiecesWidget(bloc.capturedPiecesBlack, context, true),
              getTimerWidget(false),
            ],
          ),
          if(bloc.gameMode == GameMode.oneVsBot) Column(
            children: [
              getBotWidget(context),
              SizedBox(height: getDynamicHeight(context, 5),),
              getCapturedPiecesWidget(bloc.capturedPiecesBlack, context, true)
            ],
          ),
          SizedBox(
            height: getDynamicHeight(context, 2),
          ),
          BlocBuilder<MoveHistoryCubit, MoveHistoryState>(
            builder: (context, moveHistoryState) {
              if (moveHistoryState is MoveUndo||moveHistoryState is MoveRedo) {
                if(oneVsOneCubit!=null) {
                  return getBoardGameWidget(
                    moveHistoryState.props[0] as List<BoardCellModel>,
                    bloc,
                    state,
                    moveHistoryState,
                    oneVsOneCubit,
                    oneVsBotCubit,
                    context);
                }
                if(oneVsBotCubit!=null){
                  return getBoardGameWidget(
                    moveHistoryState.props[0] as List<BoardCellModel>,
                    bloc,
                    state,
                    moveHistoryState,
                    oneVsOneCubit,
                    oneVsBotCubit,
                    context);
                }
              }
              return getBoardGameWidget(bloc.board, bloc, state, moveHistoryState,oneVsOneCubit,oneVsBotCubit,context);
            },
          ),
          // getBoardGameWidget(bloc.board, bloc, state, context),
          SizedBox(
            height: getDynamicHeight(context, 2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if(bloc.gameMode == GameMode.oneVsOne) getTimerWidget(true),
              getCapturedPiecesWidget(bloc.capturedPiecesWhite, context, false),
            ],
          ),
          SizedBox(
            height: getDynamicHeight(context, 2),
          ),
          Row(
            mainAxisAlignment:  bloc.gameMode == GameMode.oneVsOne
            ? MainAxisAlignment.end
            : MainAxisAlignment.center,
            children: [
              getResignDrawWidgets(
                  context, MainAxisAlignment.spaceEvenly, gameStatusBloc, true, bloc.gameMode),
              Opacity(
                opacity: currentPlayer == PlayerType.white ? 1 : 0.2,
                child: getMoveHistoryWidgetWhite(context,
                    MainAxisAlignment.spaceEvenly, moveHistoryCubit,currentPlayer),
              )
            ],
          ),
        ],
      )),);
}
