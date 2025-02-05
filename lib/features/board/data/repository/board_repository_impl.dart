import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:chess/features/board/business/repository/board_repository.dart';
import 'package:chess/features/board/data/model/cell_model.dart';

class BoardRepositoryImpl implements BoardRepository{
  
  @override
  bool doesMoveResolveCheck(int fromIndex, int toIndex, PlayerType playerType, String rank, String player, List<BoardCellModel> board, int whiteKingIndex, int blackKingIndex) {
    final backupFrom = board[fromIndex];
    final backupTo = board[toIndex];
    int? originalKingIndex;

    originalKingIndex =
        playerType == PlayerType.white ? whiteKingIndex : blackKingIndex;

    if (isValidMove(
        rank: rank,
        player: player,
        fromIndex: fromIndex,
        toIndex: toIndex,
        board: board,
        kingIndex: originalKingIndex)) {
      // Simulate the move
      board[toIndex] = BoardCellModel(
        cellPosition: toIndex,
        hasPiece: true,
        pieceEntity: backupFrom.pieceEntity,
      );
      board[fromIndex] = BoardCellModel(
        cellPosition: fromIndex,
        hasPiece: false,
        pieceEntity: null,
      );

      // Check if the moved piece is the king
      if (rank == 'king') {
        originalKingIndex =
            playerType == PlayerType.white ? whiteKingIndex : blackKingIndex;
        updateKingIndex(board[toIndex], toIndex, whiteKingIndex, blackKingIndex);
      }

      final resolvesCheck = !isKingStillInCheck(playerType, board);

      // Undo the move
      board[fromIndex] = backupFrom;
      board[toIndex] = backupTo;

      // Restore the king's original index if it was moved
      if (originalKingIndex != null) {
        updateKingIndex(board[originalKingIndex], originalKingIndex, whiteKingIndex, blackKingIndex);
      }

      return resolvesCheck;
    }
    return false;
  }

  @override
  bool isCheckMate(PlayerType player) {
    // TODO: implement isCheckMate
    throw UnimplementedError();
  }

  @override
  bool isKingInCheck(PlayerType player, List<BoardCellModel> board) {
    // TODO: implement isKingInCheck
    throw UnimplementedError();
  }

  @override
  bool isKingStillInCheck(PlayerType player, List<BoardCellModel> board) {
    // TODO: implement isKingStillInCheck
    throw UnimplementedError();
  }

  @override
  bool isPinned({required int fromIndex, required int toIndex, required List<BoardCellModel> board, required PlayerType player, required int whiteKingIndex, required int blackKingIndex}) {
    // TODO: implement isPinned
    throw UnimplementedError();
  }

  @override
  bool isValidMove({required String rank, required String player, required int fromIndex, required int toIndex, required List<BoardCellModel> board, required int kingIndex}) {
    // TODO: implement isValid
    throw UnimplementedError();
  }

  @override
  PlayerType switchPlayer(PlayerType player) {
    // TODO: implement switchPlayer
    throw UnimplementedError();
  }

  void updateKingIndex(BoardCellModel movingPiece, int newIndex, int whiteKingIndex, int blackKingIndex) {
    if (movingPiece.pieceEntity!.rank == 'king') {
      if (movingPiece.pieceEntity!.playerType == PlayerType.white) {
        whiteKingIndex = newIndex;
      }
      blackKingIndex = newIndex;
    }
  }

}