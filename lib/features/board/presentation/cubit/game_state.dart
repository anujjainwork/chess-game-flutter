part of 'game_cubit.dart';

sealed class GameStatusState extends Equatable {
  const GameStatusState();

  @override
  List<Object> get props => [];
}

final class GameStarted extends GameStatusState {}

final class GameEnded extends GameStatusState {}

final class WhiteWon extends GameStatusState {}

final class BlackWon extends GameStatusState {}

final class GameDraw extends GameStatusState {}
