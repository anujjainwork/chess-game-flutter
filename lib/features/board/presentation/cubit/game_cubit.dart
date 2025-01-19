import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_state.dart';

class GameStatusCubit extends Cubit<GameStatusState> {
  GameStatusCubit() : super(GameStarted());

  bool _isWhiteTimeOut = false;
  bool _isBlackTimeOut = false;

  get isWhiteTimeOut => _isWhiteTimeOut;
  get isBlackTimeOut => _isBlackTimeOut;

  void whiteTimeIsOut(){
    _isWhiteTimeOut = true;
    print('white time is out');
    emit(BlackWon());
  }
  void blackTimeIsOut(){
    _isBlackTimeOut = true;
    print('black time is out');
    emit(WhiteWon());
  }

  void drawInitiated(){

  }

  void drawAccepted(){
    
  }

  void drawDenied(){

  }  
}
