import 'dart:math';
import 'package:chess/features/board/business/entity/piece_entity.dart';
import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:chess/features/board/data/model/cell_model.dart';
import 'package:chess/features/board/data/services/is_pinned.dart';
import 'package:chess/features/board/data/services/move_validation.dart';
import 'package:chess/features/board/logic/bloc/board_logic_bloc.dart';
import 'package:collection/collection.dart';

class ChessBot {
  final int depth;
  final BoardLogicBloc boardLogicBloc;
  final Map<int, int> transpositionTable = {};
  final List<List<int>> zobristTable;

  ChessBot(this.boardLogicBloc, {this.depth = 4})
      : zobristTable = List.generate(64, (i) => List.generate(12, (_) => Random().nextInt(1 << 32)));

  void makeBotMove() {
    final botMove = getBestMove(boardLogicBloc.board, PlayerType.black);
    if (botMove != null) {
      boardLogicBloc.add(MovePiece(botMove.fromIndex, botMove.toIndex));
    }
  }

  Move? getBestMove(List<BoardCellModel> board, PlayerType player) {
    Move? bestMove;
    int bestScore = -9999;
    int alpha = -9999, beta = 9999;

    for (int d = 2; d <= depth; d += 2) {
      for (Move move in generateOrderedMoves(board, player)) {
        List<BoardCellModel> boardCopy = cloneBoard(board);
        executeMove(boardCopy, move);
        int score = minimax(boardCopy, d, false, player, alpha, beta);
        if (score > bestScore) {
          bestScore = score;
          bestMove = move;
        }
      }
    }
    return bestMove;
  }

  int minimax(List<BoardCellModel> board, int depth, bool isMaximizing, PlayerType player, int alpha, int beta) {
    if (depth == 0) return quiescenceSearch(board, alpha, beta, player);

    int boardHash = computeZobristHash(board);
    if (transpositionTable.containsKey(boardHash)) return transpositionTable[boardHash]!;

    List<Move> moves = generateOrderedMoves(board, isMaximizing ? player : opponent(player));
    if (moves.isEmpty) return evaluateBoard(board, player);

    int bestEval = isMaximizing ? -9999 : 9999;
    for (Move move in moves) {
      List<BoardCellModel> boardCopy = cloneBoard(board);
      executeMove(boardCopy, move);
      int eval = minimax(boardCopy, depth - 1, !isMaximizing, player, alpha, beta);
      bestEval = isMaximizing ? max(bestEval, eval) : min(bestEval, eval);
      if (isMaximizing) alpha = max(alpha, eval);
      else beta = min(beta, eval);
      if (beta <= alpha) break;
    }
    transpositionTable[boardHash] = bestEval;
    return bestEval;
  }

  int quiescenceSearch(List<BoardCellModel> board, int alpha, int beta, PlayerType player) {
    int standPat = evaluateBoard(board, player);
    if (standPat >= beta) return beta;
    if (alpha < standPat) alpha = standPat;

    for (Move move in generateOrderedMoves(board, player, capturesOnly: true)) {
      List<BoardCellModel> boardCopy = cloneBoard(board);
      executeMove(boardCopy, move);
      int score = -quiescenceSearch(boardCopy, -beta, -alpha, opponent(player));
      if (score >= beta) return beta;
      alpha = max(alpha, score);
    }
    return alpha;
  }

  List<Move> generateOrderedMoves(List<BoardCellModel> board, PlayerType player, {bool capturesOnly = false}) {
    Set<Move> moves = generateLegalMoves(board, player,boardLogicBloc.getIsInCheck,boardLogicBloc.blackKingIndex,boardLogicBloc.whiteKingIndex,boardLogicBloc.blackKingIndex);
    return moves.sorted((a, b) => moveValue(b, board).compareTo(moveValue(a, board)));
  }

  int moveValue(Move move, List<BoardCellModel> board) {
    BoardCellModel target = board[move.toIndex];
    return target.hasPiece ? getPieceValue(target.pieceEntity!) : 0;
  }

  int evaluateBoard(List<BoardCellModel> board, PlayerType player) {
    int score = 0;
    for (BoardCellModel cell in board) {
      if (cell.hasPiece) {
        score += (cell.pieceEntity!.playerType == player ? 1 : -1) * getPieceValue(cell.pieceEntity!);
      }
    }
    return score;
  }

  int computeZobristHash(List<BoardCellModel> board) {
    int hash = 0;
    for (int i = 0; i < board.length; i++) {
      if (board[i].hasPiece) {
        hash ^= zobristTable[i][board[i].pieceEntity!.hashCode % 12];
      }
    }
    return hash;
  }

  int getPieceValue(PieceEntity piece) {
    switch (piece.rank) {
      case 'pawn': return 10;
      case 'knight': return 30;
      case 'bishop': return 30;
      case 'rook': return 50;
      case 'queen': return 90;
      case 'king': return 900;
      default: return 0;
    }
  }

  void executeMove(List<BoardCellModel> board, Move move) {
    board[move.toIndex] = board[move.fromIndex];
    board[move.fromIndex] = BoardCellModel(cellPosition: move.fromIndex, hasPiece: false, pieceEntity: null);
  }

  List<BoardCellModel> cloneBoard(List<BoardCellModel> board) {
    return board.map((cell) => cell.copyWith()).toList();
  }

  PlayerType opponent(PlayerType player) => player == PlayerType.white ? PlayerType.black : PlayerType.white;

  // Generates legal moves as a list of Move (fromIndex, toIndex) pairs
  Set<Move> generateLegalMoves(
      List<BoardCellModel> board,
      PlayerType player,
      bool isInCheck,
      int originalKingIndex,
      int whiteKingIndex,
      int blackKingIndex) {
    Set<Move> legalMoves = {};

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
          _board[toIndex], toIndex,);
    }

    final resolvesCheck = !_isKingStillInCheck(
        playerType, _board);

    // Undo the move
    _board[fromIndex] = backupFrom;
    _board[toIndex] = backupTo;

    // Restore the king's original index if it was moved
    if (originalKingIndex != null) {
      _updateKingIndex(_board[originalKingIndex], originalKingIndex,);
    }
    

    return resolvesCheck;
  }
  return false;
}

void _updateKingIndex(BoardCellModel movingPiece, int newIndex) {
    if (movingPiece.pieceEntity!=null && movingPiece.pieceEntity!.rank == 'king') {
      if (movingPiece.pieceEntity!.playerType == PlayerType.white) {
        boardLogicBloc.whiteKingIndex = newIndex;
      }
      boardLogicBloc.blackKingIndex = newIndex;
    }
  }

bool _isKingStillInCheck(PlayerType player, List<BoardCellModel> board2) {
    int kingIndex;
    player == PlayerType.black
        ? kingIndex = boardLogicBloc.blackKingIndex
        : kingIndex = boardLogicBloc.whiteKingIndex;

    // Validate if any opponent piece can attack the king
    for (final cell in board2) {
      if (cell.hasPiece && cell.pieceEntity!=null && cell.pieceEntity!.playerType != player) {
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
}

class Move {
  final int fromIndex;
  final int toIndex;
  Move(this.fromIndex, this.toIndex);
}
