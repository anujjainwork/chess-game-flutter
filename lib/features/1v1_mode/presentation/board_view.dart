import 'package:chess/features/1v1_mode/cubit/one_vs_one_cubit.dart';
import 'package:chess/features/1vsBot/bot/logic/bot_dialogues_cubit.dart';
import 'package:chess/features/board/business/enums/game_modes_enum.dart';
import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:chess/features/board/business/repository/board_repository.dart';
import 'package:chess/features/board/data/repository/board_repository_impl.dart';
import 'package:chess/features/board/logic/bloc/board_bloc_builder.dart';
import 'package:chess/features/board/logic/bloc/board_logic_bloc.dart';
import 'package:chess/features/board/logic/bloc/game_status_bloc.dart';
import 'package:chess/features/board/logic/cubit/move_history_cubit.dart';
import 'package:chess/features/board/logic/cubit/sfx_cubit.dart';
import 'package:chess/features/board/logic/cubit/timer_cubit.dart';
import 'package:chess/common/colors.dart';
import 'package:chess/common/widgets/confirmation_draw_resign_widget.dart';
import 'package:chess/common/widgets/get_end_game_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OneVsOneBoardGameView extends StatelessWidget {
  const OneVsOneBoardGameView({super.key});

  @override
  Widget build(BuildContext context) {
    // final BoardRepository boardRepository = BoardRepositoryImpl();
    return BlocProvider<GameStatusBloc>(
      create: (_) => GameStatusBloc(context.read<SfxHapticsCubit>()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TimerCubit>(
            create: (context) => TimerCubit(
              gameMode: GameMode.oneVsOne,
              gameStatusBloc: context.read<GameStatusBloc>(),
            ),
          ),
          BlocProvider<MoveHistoryCubit>(
            create: (context) => MoveHistoryCubit(),
          ),
          BlocProvider<BoardLogicBloc>(
            create: (context) => BoardLogicBloc(
              botDialoguesCubit: context.read<BotDialoguesCubit>(),
              gameMode: GameMode.oneVsOne,
              sfxCubit: context.read<SfxHapticsCubit>(),
              timerCubit: context.read<TimerCubit>(),
              gameStatusBloc: context.read<GameStatusBloc>(),
              moveHistoryCubit: context.read<MoveHistoryCubit>(),
              // boardRepository: boardRepository
            )..add(InitializeBoard()),
          ),
          BlocProvider<OneVsOneCubit>(
            create: (context) => OneVsOneCubit(context.read<BoardLogicBloc>()),
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
                            context.read<MoveHistoryCubit>(),
                            context.read<OneVsOneCubit>(),
                            null);

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
                            true,
                            context.read<OneVsOneCubit>(),
                            null);

                      case const (DrawDeniedState):
                        return boardGameBlocBuilder(
                            context.read<GameStatusBloc>(),
                            context.read<MoveHistoryCubit>(),
                            context.read<OneVsOneCubit>(),
                            null);

                      case const (ResignInitiatedState):
                        return getGameDrawOrResignWidget(
                            context,
                            context.read<GameStatusBloc>(),
                            gameState,
                            context.read<MoveHistoryCubit>(),
                            false,
                            context.read<OneVsOneCubit>(),
                            null);

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
                            context.read<MoveHistoryCubit>(),
                            context.read<OneVsOneCubit>(),
                            null);

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
