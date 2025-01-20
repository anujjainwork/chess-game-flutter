part of 'game_status_bloc.dart';

sealed class GameStatusState extends Equatable {
  final PlayerType? player;

  const GameStatusState([this.player]);

  @override
  List<Object?> get props => [player];
}

final class GameStarted extends GameStatusState {
  const GameStarted() : super(null);
}

final class GameEnded extends GameStatusState {
  const GameEnded(PlayerType? player) : super(player);
}

final class MoveHistoryCalled extends GameStatusState{
}

final class WhiteWonState extends GameStatusState {
  const WhiteWonState({required PlayerType player}) : super(player);
}

final class BlackWonState extends GameStatusState {
  const BlackWonState({required PlayerType player}) : super(player);
}

final class DrawInitiatedState extends GameStatusState {
  const DrawInitiatedState(PlayerType? player) : super(player);
}

final class DrawDeniedState extends GameStatusState {
  const DrawDeniedState() : super(null);
}

final class GameDraw extends GameStatusState {
  const GameDraw() : super(null);
}

final class ResignInitiatedState extends GameStatusState {
  const ResignInitiatedState({required PlayerType player}) : super(player);
}

final class ResignCancelledState extends GameStatusState {
  const ResignCancelledState() : super(null);
}

final class ResignConfirmedState extends GameStatusState {
  const ResignConfirmedState({required PlayerType player}) : super(player);
}

final class PlayerIsCheckMated extends GameStatusState {
  final PlayerType losingPlayer;
  final PlayerType winningPlayer;

  const PlayerIsCheckMated({
    required this.losingPlayer,
    required this.winningPlayer,
  }) : super(null);

  @override
  List<Object?> get props => [losingPlayer, winningPlayer];
}
