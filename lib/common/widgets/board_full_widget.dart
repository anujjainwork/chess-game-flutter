import 'package:chess/common/utils.dart';
import 'package:chess/features/1v1_mode/cubit/one_vs_one_cubit.dart';
import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:chess/features/board/data/model/cell_model.dart';
import 'package:chess/features/board/logic/bloc/board_logic_bloc.dart';
import 'package:chess/features/board/logic/bloc/game_status_bloc.dart';
import 'package:chess/features/board/logic/cubit/move_history_cubit.dart';
import 'package:chess/common/widgets/board_widget.dart';
import 'package:chess/common/widgets/captured_piece_widget.dart';
import 'package:chess/common/widgets/move_history_widget.dart';
import 'package:chess/common/widgets/resign_draw_widget.dart';
import 'package:chess/common/widgets/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget getBoardFullWidget(
    BuildContext context,
    BoardLogicBloc bloc,
    BoardLogicState state,
    GameStatusBloc gameStatusBloc,
    MoveHistoryCubit moveHistoryCubit,
    OneVsOneCubit oneVsOneCubit) {
      final currentPlayer = state.props[0] as PlayerType;
  return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Opacity(
                opacity: currentPlayer == PlayerType.black ? 1 : 0.2,
                child: getMoveHistoryWidgetBlack(context,
                    MainAxisAlignment.spaceEvenly, moveHistoryCubit,currentPlayer),
              ),
              getResignDrawWidgets(
                  context, MainAxisAlignment.spaceEvenly, gameStatusBloc, false),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getCapturedPiecesWidget(bloc.capturedPiecesBlack, context, true),
              getTimerWidget(false),
            ],
          ),
          SizedBox(
            height: getDynamicHeight(context, 2),
          ),
          BlocBuilder<MoveHistoryCubit, MoveHistoryState>(
            builder: (context, moveHistoryState) {
              if (moveHistoryState is MoveUndo||moveHistoryState is MoveRedo) {
                return getBoardGameWidget(
                    moveHistoryState.props[0] as List<BoardCellModel>,
                    bloc,
                    state,
                    moveHistoryState,
                    oneVsOneCubit,
                    context);
              }
              return getBoardGameWidget(bloc.board, bloc, state, moveHistoryState,oneVsOneCubit,context);
            },
          ),
          // getBoardGameWidget(bloc.board, bloc, state, context),
          SizedBox(
            height: getDynamicHeight(context, 2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getTimerWidget(true),
              getCapturedPiecesWidget(bloc.capturedPiecesWhite, context, false),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              getResignDrawWidgets(
                  context, MainAxisAlignment.spaceEvenly, gameStatusBloc, true),
              Opacity(
                opacity: currentPlayer == PlayerType.white ? 1 : 0.2,
                child: getMoveHistoryWidgetWhite(context,
                    MainAxisAlignment.spaceEvenly, moveHistoryCubit,currentPlayer),
              )
            ],
          ),
        ],
      ));
}
