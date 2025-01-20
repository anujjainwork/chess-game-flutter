import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:chess/features/board/presentation/bloc/board_bloc_builder.dart';
import 'package:chess/features/board/presentation/bloc/board_logic_bloc.dart';
import 'package:chess/features/board/presentation/bloc/game_status_bloc.dart';
import 'package:chess/features/board/presentation/cubit/move_history_cubit.dart';
import 'package:chess/features/board/presentation/cubit/timer_cubit.dart';
import 'package:chess/common/colors.dart';
import 'package:chess/features/board/presentation/widget/confirmation_draw_resign_widget.dart';
import 'package:chess/features/board/presentation/widget/get_end_game_widget.dart';
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
              moveHistoryCubit: context.read<MoveHistoryCubit>(),
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
                            context.read<GameStatusBloc>(),
                            context.read<MoveHistoryCubit>());

                      case const (WhiteWonState):
                        return getEndGameWidget(context, 'White Won', false);

                      case const (BlackWonState):
                        return getEndGameWidget(context, 'Black Won', false);

                      case const (GameDraw):
                        return getEndGameWidget(
                            context, 'Game is now drawn', true);

                      case const (DrawInitiatedState):
                        return getGameDrawOrResignWidget(
                            context,
                            context.read<GameStatusBloc>(),
                            gameState,
                            context.read<MoveHistoryCubit>(),
                            true);

                      case const (DrawDeniedState):
                        return boardGameBlocBuilder(
                            context.read<GameStatusBloc>(),
                            context.read<MoveHistoryCubit>());

                      case const (ResignInitiatedState):
                        return getGameDrawOrResignWidget(
                            context,
                            context.read<GameStatusBloc>(),
                            gameState,
                            context.read<MoveHistoryCubit>(),
                            false);

                      case const (ResignConfirmedState):
                        return getEndGameWidget(
                            context,
                            gameState.player == PlayerType.white
                                ? 'White resigned'
                                : 'Black resigned',
                            false);

                      case const (ResignCancelledState):
                        return boardGameBlocBuilder(
                            context.read<GameStatusBloc>(),
                            context.read<MoveHistoryCubit>());

                      case const (PlayerIsCheckMated):
                        return getEndGameWidget(
                            context,
                            gameState.props[1] == PlayerType.white
                            ? 'White checkmated Black'
                            : 'Black checkmated White',
                            false);

                      default:
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
