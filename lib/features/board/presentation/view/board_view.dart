import 'package:chess/features/board/presentation/bloc/board_bloc_builder.dart';
import 'package:chess/features/board/presentation/bloc/board_logic_bloc.dart';
import 'package:chess/features/board/presentation/cubit/timer_cubit.dart';
import 'package:chess/features/board/presentation/cubit/game_cubit.dart';
import 'package:chess/features/board/presentation/widget/board_full_widget.dart';
import 'package:chess/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardGameView extends StatelessWidget {
  const BoardGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameStatusCubit>(
      create: (_) => GameStatusCubit(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TimerCubit>(
            create: (context) => TimerCubit(winCubit: context.read<GameStatusCubit>()),
          ),
          BlocProvider<BoardLogicBloc>(
            create: (context) =>
                BoardLogicBloc(timerCubit: context.read<TimerCubit>())
                  ..add(InitializeBoard()),
          ),
        ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.darkGreenBackgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlocBuilder<GameStatusCubit, GameStatusState>(
                  builder: (context, gameState) {
                    if (gameState is GameStarted) {
                      return boardGameBlocBuilder();
                    } 
                    else if(gameState is WhiteWon){
                      return const Center(
                        child: Text('White Won!',style: TextStyle(color: Colors.white),),
                      );
                    }
                    else if(gameState is BlackWon){
                      return const Center(
                        child: Text('Black Won!',style: TextStyle(color: Colors.white),),
                      );
                    }
                    else {
                      return const Center(
                        child: Text('Unexpected game state!',style: TextStyle(color: Colors.white),),
                      );
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    )
    );
  }
}
