part of 'game_status_bloc.dart';

sealed class GameStatusEvent extends Equatable {
  const GameStatusEvent();

  @override
  List<Object> get props => [];
}

class StartGame extends GameStatusEvent {}

class EndGame extends GameStatusEvent {}

class InitiateDraw extends GameStatusEvent {
  final PlayerType playerType;

  const InitiateDraw({required this.playerType});
}

class AcceptDraw extends GameStatusEvent {}

class DenyDraw extends GameStatusEvent {}

class InitiateResign extends GameStatusEvent {
  final PlayerType playerType;

  const InitiateResign({required this.playerType});
}

class ConfirmResign extends GameStatusEvent {
  final PlayerType playerType;

  const ConfirmResign({required this.playerType});
}

class CancelResign extends GameStatusEvent {
  final PlayerType playerType;

  const CancelResign({required this.playerType});
}

class BlackTimeIsOut extends GameStatusEvent {}

class WhiteTimeIsOut extends GameStatusEvent {}
