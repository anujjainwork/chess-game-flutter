import 'package:chess/features/board/business/db/initial_board.dart';
import 'package:chess/features/board/presentation/bloc/board_bloc_builder.dart';
import 'package:chess/features/board/presentation/bloc/board_logic_bloc.dart';
import 'package:chess/features/board/presentation/bloc/game_status_bloc.dart';
import 'package:chess/features/board/presentation/cubit/move_history_cubit.dart';
import 'package:chess/features/board/presentation/cubit/timer_cubit.dart';
import 'package:chess/common/colors.dart';
import 'package:chess/features/board/presentation/widget/confirmation_draw_resign_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardGameView extends StatelessWidget {
  const BoardGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameStatusBloc>(
      create: (_) => GameStatusBloc(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TimerCubit>(
            create: (context) => TimerCubit(
              gameStatusBloc: context.read<GameStatusBloc>(),
            ),
          ),
          BlocProvider<MoveHistoryCubit>(
            create: (context) => MoveHistoryCubit(),
          ),
          BlocProvider<BoardLogicBloc>(
            create: (context) => BoardLogicBloc(
              timerCubit: context.read<TimerCubit>(),
              gameStatusBloc: context.read<GameStatusBloc>(),
              moveHistoryCubit:context.read<MoveHistoryCubit>(),
            )..add(InitializeBoard()),
          ),
        ],
        child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.darkGreenBackgroundColor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocBuilder<GameStatusBloc, GameStatusState>(
                  builder: (context, gameState) {
                    switch (gameState.runtimeType) {
                      case const (GameStarted):
                        return boardGameBlocBuilder(
                            context.read<GameStatusBloc>(),context.read<MoveHistoryCubit>());

                      case const (WhiteWonState):
                        return const Center(
                          child: Text(
                            'White Won!',
                            style: TextStyle(color: Colors.white),
                          ),
                        );

                      case const (BlackWonState):
                        return const Center(
                          child: Text(
                            'Black Won!',
                            style: TextStyle(color: Colors.white),
                          ),
                        );

                      case const (GameDraw):
                        return const Center(
                          child: Text(
                            'Game is now draw!',
                            style: TextStyle(color: Colors.white),
                          ),
                        );

                      case const (DrawInitiatedState):
                        return getGameDrawOrResignWidget(context,
                            context.read<GameStatusBloc>(), gameState, context.read<MoveHistoryCubit>(),true);

                      case const (DrawDeniedState):
                        return boardGameBlocBuilder(
                            context.read<GameStatusBloc>(),context.read<MoveHistoryCubit>());

                      case const (ResignInitiatedState):
                        return getGameDrawOrResignWidget(context,
                            context.read<GameStatusBloc>(), gameState, context.read<MoveHistoryCubit>(),false);

                      case const (ResignConfirmedState):
                        return Center(
                          child: Text(
                            '${gameState.player} resigned',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );

                      case const (ResignCancelledState):
                        return boardGameBlocBuilder(
                            context.read<GameStatusBloc>(),context.read<MoveHistoryCubit>());
                      case const (PlayerIsCheckMated):
                        return Center(
                          child: Text(
                            '${gameState.props[1]} checkmated ${gameState.props[0]}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      default:
                        print('Unexpected game state: $gameState');
                        return const Center(
                          child: Text(
                            'Unexpected game state!',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
