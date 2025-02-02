import 'package:bloc/bloc.dart';
import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:chess/features/board/logic/cubit/sfx_cubit.dart';
import 'package:equatable/equatable.dart';

part 'game_status_event.dart';
part 'game_status_state.dart';

class GameStatusBloc extends Bloc<GameStatusEvent, GameStatusState> {
  final SfxHapticsCubit sfxCubit;
  GameStatusBloc(this.sfxCubit) : super(const GameStarted()) {
    on<WhiteTimeIsOut>(_handleWhiteTimeOut);
    on<BlackTimeIsOut>(_handleBlackTimeOut);
    on<InitiateDraw>(_handleInitiateDraw);
    on<AcceptDraw>(_handleAcceptDraw);
    on<DenyDraw>(_handleDenyDraw);
    on<InitiateResign>(_handleInitialiseResign);
    on<ConfirmResign>(_handleConfirmResign);
    on<CancelResign>(_handleCancelResign);
    on<WhiteWonEvent>(_handleWhiteWonEvent);
    on<BlackWonEvent>(_handleBlackWonEvent);
    on<PlayerCheckMated>(_handlePlayerCheckMated);
  }

  // @override
  // void onTransition(
  //   Transition<GameStatusEvent, GameStatusState> transition,
  // ) {
  //   super.onTransition(transition);
  //   print('Game State Transition to:  ${transition.nextState} from ${transition.currentState}');
  // }

  // Event Handlers
  void _handleWhiteTimeOut(
      WhiteTimeIsOut event, Emitter<GameStatusState> emit) {
    emit(const BlackWonState(player: PlayerType.black));
  }

  void _handleBlackTimeOut(
      BlackTimeIsOut event, Emitter<GameStatusState> emit) {
    emit(const WhiteWonState(player: PlayerType.white));
  }

  void _handleInitiateDraw(InitiateDraw event, Emitter<GameStatusState> emit) {
    emit(DrawInitiatedState(event.playerType));
  }

  void _handleAcceptDraw(AcceptDraw event, Emitter<GameStatusState> emit) {
    emit(const GameDraw());
  }

  void _handleDenyDraw(DenyDraw event, Emitter<GameStatusState> emit) {
    emit(const DrawDeniedState());
  }

  void _handleInitialiseResign(
      InitiateResign event, Emitter<GameStatusState> emit) {
    emit(ResignInitiatedState(player: event.playerType));
  }

  void _handleConfirmResign(
      ConfirmResign event, Emitter<GameStatusState> emit) {
    emit(ResignConfirmedState(player: event.playerType));
  }

  void _handleCancelResign(CancelResign event, Emitter<GameStatusState> emit) {
    emit(const ResignCancelledState());
  }

  void _handleWhiteWonEvent(
      WhiteWonEvent event, Emitter<GameStatusState> emit) {
    emit(WhiteWonState(player: event.player));
  }

  void _handleBlackWonEvent(
      BlackWonEvent event, Emitter<GameStatusState> emit) {
    emit(BlackWonState(player: event.player));
  }

  void _handlePlayerCheckMated(
      PlayerCheckMated event, Emitter<GameStatusState> emit) {
    final losingPlayer = event.attackingPlayer == PlayerType.white
        ? PlayerType.black
        : PlayerType.white;
    emit(PlayerIsCheckMated(
        losingPlayer: losingPlayer, winningPlayer: event.attackingPlayer));
  }
}
