import 'package:chess/features/board/presentation/bloc/board_logic_bloc.dart';
import 'package:chess/features/board/presentation/widget/board_full_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

BlocBuilder boardGameBlocBuilder() {
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
        return getBoardFullWidget(context, bloc, boardState);
      } else if (boardState is InvalidMoveAttempted) {
        return getBoardFullWidget(context, bloc, boardState);
      } else {
        return const Center(
          child: Text('Something went wrong!'),
        );
      }
    },
  );
}
