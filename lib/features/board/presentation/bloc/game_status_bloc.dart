import 'package:bloc/bloc.dart';
import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:equatable/equatable.dart';

part 'game_status_event.dart';
part 'game_status_state.dart';

class GameStatusBloc extends Bloc<GameStatusEvent, GameStatusState> {
  GameStatusBloc() : super(const GameStarted()) {
    on<WhiteTimeIsOut>(_handleWhiteTimeOut);
    on<BlackTimeIsOut>(_handleBlackTimeOut);
    on<InitiateDraw>(_handleInitiateDraw);
    on<AcceptDraw>(_handleAcceptDraw);
    on<DenyDraw>(_handleDenyDraw);
    on<InitiateResign>(_handleInitialiseResign);
    on<ConfirmResign>(_handleConfirmResign);
    on<CancelResign>(_handleCancelResign);
  }

  // Event Handlers
  void _handleWhiteTimeOut(
      WhiteTimeIsOut event, Emitter<GameStatusState> emit) {
    emit(const BlackWon(player: PlayerType.black));
  }

  void _handleBlackTimeOut(
      BlackTimeIsOut event, Emitter<GameStatusState> emit) {
    emit(const WhiteWon(player: PlayerType.white));
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
}
