import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:chess/features/board/data/model/player_model.dart';
import 'package:chess/features/board/presentation/bloc/game_status_bloc.dart';
import 'package:equatable/equatable.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  final GameStatusBloc gameStatusBloc;
  TimerCubit({required this.gameStatusBloc}) : super(TimerInitial());

  PlayerModel whitePlayer = PlayerModel(
      playerType: PlayerType.white,
      playerTimeLeft: const Duration(minutes: 10));
  PlayerModel blackPlayer = PlayerModel(
      playerType: PlayerType.black,
      playerTimeLeft: const Duration(minutes: 10));

  Timer? _timer;
  int _elapsedTimeWhite = 0;
  int _elapsedTimeBlack = 0;
  PlayerType? _currentPlayer; // Track the active player

  void startTimer(PlayerType currentPlayer) {
    if (_timer != null && _timer!.isActive)
      return; // Guard against multiple timers
    _currentPlayer = currentPlayer; // Update the active player

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentPlayer == PlayerType.white) {
        _elapsedTimeWhite++;
        whitePlayer = whitePlayer.copyWith(
          playerTimeLeft: const Duration(minutes: 10) -
              Duration(seconds: _elapsedTimeWhite),
        );
        if (whitePlayer.playerTimeLeft == const Duration(seconds: 0)) {
          // gameStatusBloc.add(WhiteTimeIsOut());
          // stopTimer(); // Stop the timer when time runs out
        }
      } else if (_currentPlayer == PlayerType.black) {
        _elapsedTimeBlack++;
        blackPlayer = blackPlayer.copyWith(
          playerTimeLeft: const Duration(minutes: 10) -
              Duration(seconds: _elapsedTimeBlack),
        );
        if (blackPlayer.playerTimeLeft == const Duration(seconds: 0)) {
          // gameStatusBloc.add(BlackTimeIsOut());
          // stopTimer(); // Stop the timer when time runs out
        }
      }
      emit(TimerUpdated(whitePlayer, blackPlayer));
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = null;
    _currentPlayer = null;
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

  @override
  Future<void> close() {
    _timer?.cancel(); // Ensure the timer is canceled on cubit close
    return super.close();
  }
}
