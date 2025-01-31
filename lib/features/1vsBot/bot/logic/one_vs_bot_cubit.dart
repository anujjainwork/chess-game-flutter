import 'package:bloc/bloc.dart';
import 'package:chess/features/1vsBot/bot/chess_bot.dart';
import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:chess/features/board/logic/bloc/board_logic_bloc.dart';
import 'package:equatable/equatable.dart';

part 'one_vs_bot_state.dart';

class OneVsBotCubit extends Cubit<OneVsBotState> {
  final BoardLogicBloc boardLogicBloc;
  OneVsBotCubit(this.boardLogicBloc) : super(OneVsBotInitial());

  void selectPieceEvent(int index, List<int>? attackingPiecesIndices) {
    boardLogicBloc.add(SelectPiece(index, attackingPiecesIndices));
  }

  void deselectPieceEvent() {
    boardLogicBloc.add(DeselectPiece());
  }

}
