import 'package:chess/features/1v1_mode/cubit/one_vs_one_cubit.dart';
import 'package:chess/features/board/logic/bloc/board_logic_bloc.dart';
import 'package:chess/features/board/logic/bloc/game_status_bloc.dart';
import 'package:chess/features/board/logic/cubit/move_history_cubit.dart';
import 'package:chess/common/widgets/board_full_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

BlocBuilder boardGameBlocBuilder(GameStatusBloc gameStatusBloc,MoveHistoryCubit moveHistoryCubit,OneVsOneCubit oneVsOneCubit) {
  return BlocBuilder<BoardLogicBloc, BoardLogicState>(
    builder: (context, boardState) {
      final bloc = context.read<BoardLogicBloc>();
      if (boardState is BoardLogicInitial) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (boardState is BoardLoaded ||
          boardState is PieceSelected ||
          boardState is PieceDeselected ||
          boardState is ValidMovesHighlighted ||
          boardState is IsCheckState) {
        return getBoardFullWidget(context, bloc, boardState,gameStatusBloc,moveHistoryCubit,oneVsOneCubit);
      } else if (boardState is InvalidMoveAttempted) {
        return getBoardFullWidget(context, bloc, boardState,gameStatusBloc,moveHistoryCubit,oneVsOneCubit);
      } else {
        return const Center(
          child: Text('Something went wrong!'),
        );
      }
    },
  );
}
