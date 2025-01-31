import 'package:chess/features/board/data/model/cell_model.dart';

bool isValidMove({
  required String rank,
  required String player,
  required int fromIndex,
  required int toIndex,
  required List<BoardCellModel> board,
  required int kingIndex
}) {
  int fromRow = fromIndex ~/ 8;
  int fromCol = fromIndex % 8;
  int toRow = toIndex ~/ 8;
  int toCol = toIndex % 8;

  if(board[toIndex].hasPiece && board[toIndex].pieceEntity!=null && board[toIndex].pieceEntity!.player == player) return false;

  if (rank == 'pawn') {
    return _validatePawnMove(fromRow, fromCol, toRow, toCol, player, board);
  } else if (rank == 'rook') {
    return _validateRookMove(fromRow, fromCol, toRow, toCol, board);
  } else if (rank == 'knight') {
    return _validateKnightMove(fromRow, fromCol, toRow, toCol);
  } else if (rank == 'bishop') {
    return _validateBishopMove(fromRow, fromCol, toRow, toCol, board);
  } else if (rank == 'queen') {
    return _validateQueenMove(fromRow, fromCol, toRow, toCol, board);
  } else if (rank == 'king') {
    return _validateKingMove(fromRow, fromCol, toRow, toCol, board);
  }

  return false;
}

bool _validatePawnMove(int fromRow, int fromCol, int toRow, int toCol,
    String pieceId, List<BoardCellModel> board) {
  bool isWhite = pieceId.endsWith('white');
  int direction = isWhite ? -1 : 1;

  // Forward move
  if (fromCol == toCol) {
    bool isHasPiece = board[toRow * 8 + toCol].hasPiece;
    if (isHasPiece)   return false;
    if (toRow - fromRow == direction) return true;
    if ((fromRow == 1 && !isWhite) || (fromRow == 6 && isWhite)) {
      return toRow - fromRow == 2 * direction &&
          !board[(fromRow + direction) * 8 + fromCol].hasPiece;
    }
  }

  // Diagonal capture
  if ((toRow - fromRow == direction) && (toCol - fromCol).abs() == 1) {
    return board[toRow * 8 + toCol].hasPiece;
  }

  return false;
}

bool _validateRookMove(int fromRow, int fromCol, int toRow, int toCol,
    List<BoardCellModel> board) {
  if (fromRow != toRow && fromCol != toCol) return false;

  int rowStep = (toRow - fromRow).sign;
  int colStep = (toCol - fromCol).sign;

  int currentRow = fromRow + rowStep;
  int currentCol = fromCol + colStep;

  while (currentRow != toRow || currentCol != toCol) {
    if (board[currentRow * 8 + currentCol].hasPiece) return false;
    currentRow += rowStep;
    currentCol += colStep;
  }

  return true;
}

bool _validateKnightMove(int fromRow, int fromCol, int toRow, int toCol) {
  int rowDiff = (toRow - fromRow).abs();
  int colDiff = (toCol - fromCol).abs();
  return (rowDiff == 2 && colDiff == 1) || (rowDiff == 1 && colDiff == 2);
}

bool _validateBishopMove(int fromRow, int fromCol, int toRow, int toCol,
    List<BoardCellModel> board) {
  if ((toRow - fromRow).abs() != (toCol - fromCol).abs()) return false;

  int rowStep = (toRow - fromRow).sign;
  int colStep = (toCol - fromCol).sign;

  int currentRow = fromRow + rowStep;
  int currentCol = fromCol + colStep;

  while (currentRow != toRow || currentCol != toCol) {
    if (board[currentRow * 8 + currentCol].hasPiece) return false;
    currentRow += rowStep;
    currentCol += colStep;
  }

  return true;
}

bool _validateQueenMove(int fromRow, int fromCol, int toRow, int toCol,
    List<BoardCellModel> board) {
  return _validateRookMove(fromRow, fromCol, toRow, toCol, board) ||
      _validateBishopMove(fromRow, fromCol, toRow, toCol, board);
}

bool _validateKingMove(int fromRow, int fromCol, int toRow, int toCol,
    List<BoardCellModel> board) {
  int rowDiff = (toRow - fromRow).abs();
  int colDiff = (toCol - fromCol).abs();
  return rowDiff <= 1 && colDiff <= 1;
}
