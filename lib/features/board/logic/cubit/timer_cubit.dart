import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chess/features/board/business/enums/game_modes_enum.dart';
import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:chess/features/board/data/model/player_model.dart';
import 'package:chess/features/board/logic/bloc/game_status_bloc.dart';
import 'package:equatable/equatable.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  final GameMode gameMode;
  final GameStatusBloc gameStatusBloc;
  TimerCubit({required this.gameStatusBloc, required this.gameMode})
      : super(TimerInitial());

  PlayerModel whitePlayer = PlayerModel(
      playerType: PlayerType.white,
      playerTimeLeft: const Duration(minutes: 10));
  PlayerModel blackPlayer = PlayerModel(
      playerType: PlayerType.black,
      playerTimeLeft: const Duration(minutes: 10));

  Timer? _timer;
  int _elapsedTimeWhite = 0;
  int _elapsedTimeBlack = 0;

  void startTimer(PlayerType currentPlayer) {
    // Cancel any existing timer
    _timer?.cancel();
    // Start a new timer that updates every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentPlayer == PlayerType.white) {
        _elapsedTimeWhite++;
        whitePlayer = whitePlayer.copyWith(
          playerTimeLeft: const Duration(minutes: 10) -
              Duration(seconds: _elapsedTimeWhite),
        );
        if (whitePlayer.playerTimeLeft == const Duration(seconds: 0) && gameMode == GameMode.oneVsOne)
          gameStatusBloc.add(WhiteTimeIsOut());
      } else {
        _elapsedTimeBlack++;
        blackPlayer = blackPlayer.copyWith(
          playerTimeLeft: const Duration(minutes: 10) -
              Duration(seconds: _elapsedTimeBlack),
        );
        if (blackPlayer.playerTimeLeft == const Duration(seconds: 0) && gameMode == GameMode.oneVsOne)
          gameStatusBloc.add(BlackTimeIsOut());
      }
      emit(TimerUpdated(whitePlayer, blackPlayer));
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    _timer?.cancel();
    whitePlayer = PlayerModel(
        playerType: PlayerType.white,
        playerTimeLeft: const Duration(minutes: 10));
    blackPlayer = PlayerModel(
        playerType: PlayerType.black,
        playerTimeLeft: const Duration(minutes: 10));
    _elapsedTimeWhite = 0;
    _elapsedTimeBlack = 0;
    emit(TimerUpdated(whitePlayer, blackPlayer));
  }
}
