import 'package:bloc/bloc.dart';
import 'package:chess/features/board/logic/bloc/board_logic_bloc.dart';
import 'package:equatable/equatable.dart';

part 'one_vs_one_state.dart';

class OneVsOneCubit extends Cubit<OneVsOneState> {
  final BoardLogicBloc boardLogicBloc;
  OneVsOneCubit(this.boardLogicBloc) : super(OneVsOneInitial());

  void selectPieceEvent(int cellIndex, List<int>? attackingPiecesIndices){
    boardLogicBloc.add(SelectPiece(cellIndex, attackingPiecesIndices));
  }

  void deselectPieceEvent(){
    boardLogicBloc.add(DeselectPiece());
  }
}
