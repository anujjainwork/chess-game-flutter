import 'package:chessmate/features/board/business/entity/piece_entity.dart';
import 'package:chessmate/features/board/business/enums/player_type_enum.dart';
import 'package:chessmate/features/board/data/model/cell_model.dart';
import 'package:chessmate/features/board/data/services/move_validation.dart';

bool isPinned(
    {required int fromIndex,
    required int toIndex,
    required List<BoardCellModel> board,
    required PlayerType player,
    required int whiteKingIndex,
    required int blackKingIndex}) {
  // Create a deep copy of the board
  List<BoardCellModel> dupBoard = List<BoardCellModel>.from(
    board.map((cell) => cell.copyWith()),
  );

  // Find the king's index based on the current player
  int kingIndex =
      (player == PlayerType.white) ? whiteKingIndex : blackKingIndex;


  
  if (board[fromIndex].hasPiece &&
      board[fromIndex].pieceEntity!.rank == 'king') {
    dupBoard[fromIndex] = BoardCellModel(
        cellPosition: fromIndex, hasPiece: false, pieceEntity: null);
    dupBoard[toIndex] = BoardCellModel(
        cellPosition: toIndex,
        hasPiece: true,
        pieceEntity: PieceEntity(player,
            rank: 'king',
            player: player == PlayerType.white ? 'white' : 'black'));
    kingIndex = toIndex;
  } else {
    // Temporarily remove the piece at the given index
    dupBoard[fromIndex].hasPiece = false;
    dupBoard[fromIndex].pieceEntity = null;
  }

  // Check all opponent pieces that could potentially pin the piece at fromIndex
  for (final cell in board) {
    // Skip empty cells or pieces that belong to the same player
    if (!cell.hasPiece || cell.pieceEntity == null || cell.pieceEntity!.playerType == player) continue;

    final piece = cell.pieceEntity!;

    // Check for possible pin by different types of pieces
    if (isValidMove(
        rank: piece.rank,
        player: piece.player,
        fromIndex: cell.cellPosition,
        toIndex: kingIndex,
        board: dupBoard,
        kingIndex: kingIndex)) {
      // If any opponent piece can pin the selected piece, return true
      return true;
    }
  }

  // If no opponent piece can pin it, return false
  return false;
}
