import 'package:chess/board/presentation/bloc/board_logic_bloc.dart';
import 'package:chess/board/presentation/cubit/timer_cubit.dart';
import 'package:chess/board/presentation/widget/board_widget.dart';
import 'package:chess/board/presentation/widget/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardGameView extends StatelessWidget {
  const BoardGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TimerCubit>(
          create: (_) => TimerCubit(),
        ),
        BlocProvider<BoardLogicBloc>(
            create: (context) =>
                BoardLogicBloc(timerCubit: context.read<TimerCubit>())
                  ..add(InitializeBoard())),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getTimerWidget(false),
              // Chessboard
              Center(child: BlocBuilder<BoardLogicBloc, BoardLogicState>(
                builder: (context, state) {
                  final bloc = context.read<BoardLogicBloc>();
                  if (state is BoardLogicInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BoardLoaded ||
                      state is PieceSelected ||
                      state is PieceDeselected ||
                      state is ValidMovesHighlighted) {
                    // Ensure the board is always displayed
                    return getBoardGameWidget(bloc.board, bloc, state);
                  } else if (state is InvalidMoveAttempted) {
                    return getBoardGameWidget(bloc.board, bloc, state);
                  } else {
                    return const Center(child: Text('Something went wrong!'));
                  }
                },
              )),
              getTimerWidget(true),
            ],
          ),
        ),
      ),
    );
  }
}
