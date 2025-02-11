import 'package:chessmate/features/1v1_mode/cubit/one_vs_one_cubit.dart';
import 'package:chessmate/features/1vsBot/bot/logic/one_vs_bot_cubit.dart';
import 'package:chessmate/features/board/logic/bloc/board_logic_bloc.dart';
import 'package:chessmate/features/board/logic/bloc/game_status_bloc.dart';
import 'package:chessmate/features/board/logic/cubit/move_history_cubit.dart';
import 'package:chessmate/common/widgets/board_full_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

BlocBuilder boardGameBlocBuilder(
    GameStatusBloc gameStatusBloc,
    MoveHistoryCubit moveHistoryCubit,
    OneVsOneCubit? oneVsOneCubit,
    OneVsBotCubit? oneVsBotCubit,
    ) {
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
        if(oneVsOneCubit!=null) return getBoardFullWidget(context, bloc, boardState,gameStatusBloc,moveHistoryCubit,oneVsOneCubit,null);
        if(oneVsBotCubit!=null) return getBoardFullWidget(context, bloc, boardState,gameStatusBloc,moveHistoryCubit,null,oneVsBotCubit);
        return const Center(
          child: Text('Something went wrong!'),
        );
      } else if (boardState is InvalidMoveAttempted) {
        if(oneVsOneCubit!=null) return getBoardFullWidget(context, bloc, boardState,gameStatusBloc,moveHistoryCubit,oneVsOneCubit,null);
        if(oneVsBotCubit!=null) return getBoardFullWidget(context, bloc, boardState,gameStatusBloc,moveHistoryCubit,null,oneVsBotCubit);
        return const Center(
          child: Text('Something went wrong!'),
        );
      } else {
        return const Center(
          child: Text('Something went wrong!'),
        );
      }
    },
  );
}
