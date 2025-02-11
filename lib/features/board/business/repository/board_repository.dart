import 'package:chessmate/features/board/business/enums/player_type_enum.dart';
import 'package:chessmate/features/board/data/model/cell_model.dart';

abstract class BoardRepository {
  bool isPinned({required int fromIndex, required int toIndex, required List<BoardCellModel> board, required PlayerType player,
      required int whiteKingIndex, required int blackKingIndex});
  
  bool isValidMove({required String rank, required String player, required int fromIndex, required int toIndex, required List<BoardCellModel> board,
      required int kingIndex});
    
  bool doesMoveResolveCheck(int fromIndex, int toIndex, PlayerType playerType, String rank, String player, List<BoardCellModel> board,int whiteKingIndex, int blackKingIndex);

  bool isKingInCheck(PlayerType player, List<BoardCellModel> board);

  bool isKingStillInCheck(PlayerType player, List<BoardCellModel> board);

  PlayerType switchPlayer(PlayerType player);

  bool isCheckMate(PlayerType player);
}
