import 'package:chess/board/presentation/cubit/board_cubit.dart';
import 'package:chess/board/presentation/cubit/timer_cubit.dart';
import 'package:chess/board/presentation/widget/board_widget.dart';
import 'package:chess/board/presentation/widget/timer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        BlocProvider<BoardCubit>(
          create: (context) =>
              BoardCubit(timerCubit: context.read<TimerCubit>())
                ..initializeBoard(),
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getTimerWidget(false),
              // Chessboard
              Center(
                child: BlocBuilder<BoardCubit, BoardState>(
                  builder: (context, state) {
                    final cubit = context.read<BoardCubit>();
                    if (state is BoardInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BoardLoaded || state is PieceSelected) {
                      return getBoardGameWidget(cubit.board, cubit, state);
                    } else if (state is InvalidMoveAttempted) {
                      return getBoardGameWidget(cubit.board, cubit, state);
                    } else {
                      return const Center(child: Text('Something went wrong!'));
                    }
                  },
                ),
              ),
              getTimerWidget(true),
            ],
          ),
        ),
      ),
    );
  }
}
