import 'package:chess/common/utils.dart';
import 'package:chess/features/board/presentation/bloc/board_logic_bloc.dart';
import 'package:chess/features/board/presentation/bloc/game_status_bloc.dart';
import 'package:chess/features/board/presentation/widget/board_widget.dart';
import 'package:chess/features/board/presentation/widget/captured_piece_widget.dart';
import 'package:chess/features/board/presentation/widget/resign_draw_widget.dart';
import 'package:chess/features/board/presentation/widget/timer_widget.dart';
import 'package:flutter/material.dart';

Widget getBoardFullWidget(
    BuildContext context, BoardLogicBloc bloc, BoardLogicState state, GameStatusBloc gameStatusBloc) {
  return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getResignDrawWidgets(context, MainAxisAlignment.end,gameStatusBloc,false),
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
          getBoardGameWidget(bloc.board, bloc, state, context),
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
          getResignDrawWidgets(context, MainAxisAlignment.end,gameStatusBloc,true),
        ],
      ));
}
