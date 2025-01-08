part of 'timer_cubit.dart';
// Abstract base class for all timer states
abstract class TimerState extends Equatable {
  
  @override
  List<Object> get props => [];
}

// State when the timer is initialized or reset
class TimerInitial extends TimerState {}

// State when the timer is updated (showing the remaining time for both players)
class TimerUpdated extends TimerState {
  final PlayerModel whitePlayer;
  final PlayerModel blackPlayer;

  TimerUpdated(this.whitePlayer, this.blackPlayer);

  @override
  List<Object> get props => [whitePlayer, blackPlayer];
}
