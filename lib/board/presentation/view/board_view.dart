import 'package:chess/board/presentation/cubit/board_cubit.dart';
import 'package:chess/board/presentation/widget/board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardGameView extends StatelessWidget {
  const BoardGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BoardCubit()..initializeBoard(),
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<BoardCubit, BoardState>(
            builder: (context, state) {
              final cubit = context.read<BoardCubit>();
              if (state is BoardInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BoardLoaded || state is PieceSelected) {
                return getBoardGameWidget(cubit.board, cubit, state);
              } else if(state is InvalidMoveAttempted){
                return getBoardGameWidget(cubit.board, cubit, state);
              }
              else{
                return const Center(child: Text('Something went wrong!'));
              }
            },
          ),
        ),
      ),
    );
  }
}
