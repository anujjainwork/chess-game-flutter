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

final class WhiteWon extends GameStatusState {
  const WhiteWon({required PlayerType player}) : super(player);
}

final class BlackWon extends GameStatusState {
  const BlackWon({required PlayerType player}) : super(player);
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
