import 'package:chess/features/board/business/entity/piece_entity.dart';
import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:chess/features/board/data/model/cell_model.dart';
import 'package:chess/features/board/data/services/is_pinned.dart';
import 'package:chess/features/board/data/services/move_validation.dart';
import 'package:chess/features/board/logic/bloc/board_logic_bloc.dart';

class ChessBot {
  final int depth;
  final BoardLogicBloc boardLogicBloc;

  ChessBot(this.boardLogicBloc, {this.depth = 3});

  void makeBotMove() {
    final botMove =
      getBestMove(boardLogicBloc.board, PlayerType.black);
    if (botMove != null) {
      boardLogicBloc.add(MovePiece(botMove.fromIndex, botMove.toIndex));
    }
  }

  Move? getBestMove(List<BoardCellModel> board, PlayerType player) {
    int bestScore = -9999;
    Move? bestMove;
    int originalKingIndex = 
          player == PlayerType.white ? boardLogicBloc.whiteKingIndex : boardLogicBloc.blackKingIndex;

    for (Move move in generateLegalMoves(
        board,
        player,
        boardLogicBloc.getIsInCheck,
        originalKingIndex,
        boardLogicBloc.whiteKingIndex,
        boardLogicBloc.blackKingIndex)) {
      List<BoardCellModel> boardCopy = List.from(board);
      executeMove(boardCopy, move);
      int score = minimax(boardCopy, depth, false, player);

      print('score ${score}');

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }
    return bestMove;
  }

  int minimax(List<BoardCellModel> board, int depth, bool isMaximizing,
      PlayerType player) {
        int originalKingIndex = 
          player == PlayerType.white ? boardLogicBloc.whiteKingIndex : boardLogicBloc.blackKingIndex;
    if (depth == 0) {
      return evaluateBoard(board, player);
    }

    if (isMaximizing) {
      int maxEval = -9999;
      for (Move move in generateLegalMoves(
          board,
          player,
          boardLogicBloc.getIsInCheck,
          originalKingIndex,
          boardLogicBloc.whiteKingIndex,
          boardLogicBloc.blackKingIndex)) {
        List<BoardCellModel> boardCopy = List.from(board);
        executeMove(boardCopy, move);
        int eval = minimax(boardCopy, depth - 1, false, player);
        maxEval = maxEval > eval ? maxEval : eval;
      }
      return maxEval;
    } else {
      int minEval = 9999;
      PlayerType opponent =
          player == PlayerType.white ? PlayerType.black : PlayerType.white;
      for (Move move in generateLegalMoves(
          board,
          opponent,
          boardLogicBloc.getIsInCheck,
          originalKingIndex,
          boardLogicBloc.whiteKingIndex,
          boardLogicBloc.blackKingIndex)) {
        List<BoardCellModel> boardCopy = List.from(board);
        executeMove(boardCopy, move);
        int eval = minimax(boardCopy, depth - 1, true, player);
        minEval = minEval < eval ? minEval : eval;
      }
      return minEval;
    }
  }

  // Generates legal moves as a list of Move (fromIndex, toIndex) pairs
  List<Move> generateLegalMoves(
      List<BoardCellModel> board,
      PlayerType player,
      bool isInCheck,
      int originalKingIndex,
      int whiteKingIndex,
      int blackKingIndex) {
    List<Move> legalMoves = [];

    for (int fromIndex = 0; fromIndex < board.length; fromIndex++) {
      final selectedCell = board[fromIndex];

      // Skip empty cells or cells that don't belong to the current player
      if (!selectedCell.hasPiece || selectedCell.pieceEntity == null ||
          selectedCell.pieceEntity!.playerType != player) {
        continue;
      }

      // For each piece, calculate its valid moves
      for (int toIndex = 0; toIndex < board.length; toIndex++) {
        final isValid = isInCheck
            ? _doesMoveResolveCheck(
                fromIndex,
                toIndex,
                player,
                selectedCell.pieceEntity!.rank,
                selectedCell.pieceEntity!.player,
                boardLogicBloc.board,
                boardLogicBloc.whiteKingIndex,
                boardLogicBloc.blackKingIndex)
            : isValidMove(
                  rank: selectedCell.pieceEntity!.rank,
                  player: selectedCell.pieceEntity!.player,
                  fromIndex: fromIndex,
                  toIndex: toIndex,
                  board: board,
                  kingIndex: originalKingIndex,
                ) &&
                !isPinned(
                    fromIndex: fromIndex,
                    toIndex: toIndex,
                    board: board,
                    player: player,
                    whiteKingIndex: whiteKingIndex,
                    blackKingIndex: blackKingIndex);

        if (isValid) {
          legalMoves.add(Move(fromIndex, toIndex));
        }
      }
    }

    return legalMoves;
  }

  void executeMove(List<BoardCellModel> board, Move move) {
    final movingPiece = board[move.fromIndex];
    final targetCell = board[move.toIndex];

    if (!movingPiece.hasPiece ||
        movingPiece.pieceEntity!.playerType != boardLogicBloc.currentPlayer)
      return;

    if (targetCell.pieceEntity !=null  &&
        targetCell.pieceEntity!.playerType == boardLogicBloc.currentPlayer)
      return;
    int fromIndex = move.fromIndex;
    int toIndex = move.toIndex;
    board[toIndex] = BoardCellModel(
        cellPosition: toIndex,
        hasPiece: true,
        pieceEntity: board[toIndex].pieceEntity);
    board[fromIndex] = BoardCellModel(
        cellPosition: fromIndex, hasPiece: false, pieceEntity: null);
  }

  int evaluateBoard(List<BoardCellModel> board, PlayerType player) {
    int score = 0;
    for (BoardCellModel cell in board) {
      if (cell.hasPiece && cell.pieceEntity != null) {
        int pieceValue = getPieceValue(cell.pieceEntity!);
        score +=
            cell.pieceEntity!.playerType == player ? pieceValue : -pieceValue;
      }
    }
    return score;
  }

  int getPieceValue(PieceEntity piece) {
    switch (piece.rank) {
      case 'pawn':
        return 1;
      case 'knight':
        return 3;
      case 'bishop':
        return 3;
      case 'rook':
        return 5;
      case 'queen':
        return 9;
      case 'king':
        return 100;
      default:
        return 0;
    }
  }
}

// A Move class to represent moves by indices
class Move {
  final int fromIndex;
  final int toIndex;

  Move(this.fromIndex, this.toIndex);
}

bool _doesMoveResolveCheck(
    int fromIndex,
    int toIndex,
    PlayerType playerType,
    String rank,
    String player,
    List<BoardCellModel> _board,
    int whiteKingIndex,
    int blackKingIndex) {
  final backupFrom = _board[fromIndex];
  final backupTo = _board[toIndex];
  int? originalKingIndex;

  originalKingIndex =
      playerType == PlayerType.white ? whiteKingIndex : blackKingIndex;

  if (isValidMove(
      rank: rank,
      player: player,
      fromIndex: fromIndex,
      toIndex: toIndex,
      board: _board,
      kingIndex: originalKingIndex)) {
    // Simulate the move
    _board[toIndex] = BoardCellModel(
      cellPosition: toIndex,
      hasPiece: true,
      pieceEntity: backupFrom.pieceEntity,
    );
    _board[fromIndex] = BoardCellModel(
      cellPosition: fromIndex,
      hasPiece: false,
      pieceEntity: null,
    );

    // Check if the moved piece is the king
    if (rank == 'king') {
      originalKingIndex =
          playerType == PlayerType.white ? whiteKingIndex : blackKingIndex;
      _updateKingIndex(
          _board[toIndex], toIndex, whiteKingIndex, blackKingIndex);
    }

    final resolvesCheck = !_isKingStillInCheck(
        playerType, _board, whiteKingIndex, blackKingIndex);

    // Undo the move
    _board[fromIndex] = backupFrom;
    _board[toIndex] = backupTo;

    // Restore the king's original index if it was moved
    if (originalKingIndex != null) {
      _updateKingIndex(_board[originalKingIndex], originalKingIndex,
          whiteKingIndex, blackKingIndex);
    }

    return resolvesCheck;
  }
  return false;
}

bool _isKingStillInCheck(PlayerType player, List<BoardCellModel> board2,
    int whiteKingIndex, int blackKingIndex) {
  int kingIndex;
  player == PlayerType.black
      ? kingIndex = blackKingIndex
      : kingIndex = whiteKingIndex;

  // Validate if any opponent piece can attack the king
  for (final cell in board2) {
    if (cell.hasPiece && cell.pieceEntity!.playerType != player) {
      if (isValidMove(
          rank: cell.pieceEntity!.rank,
          player: cell.pieceEntity!.player,
          fromIndex: cell.cellPosition,
          toIndex: kingIndex,
          board: board2,
          kingIndex: kingIndex)) {
        return true;
      }
    }
  }
  return false;
}

void _updateKingIndex(BoardCellModel movingPiece, int newIndex,
    int whiteKingIndex, int blackKingIndex) {
  if (movingPiece.pieceEntity!.rank == 'king') {
    if (movingPiece.pieceEntity!.playerType == PlayerType.white) {
      whiteKingIndex = newIndex;
    }
    blackKingIndex = newIndex;
  }
}