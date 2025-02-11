import 'package:bloc/bloc.dart';
import 'package:chessmate/features/board/business/entity/piece_entity.dart';
import 'package:chessmate/features/board/business/enums/player_type_enum.dart';
import 'package:chessmate/features/board/data/model/cell_model.dart';
import 'package:chessmate/features/board/logic/bloc/board_logic_bloc.dart';
import 'package:equatable/equatable.dart';

part 'fen_state.dart';

class FenCubit extends Cubit<FenState> {
  final BoardLogicBloc boardLogicBloc;

  FenCubit({required this.boardLogicBloc}) : super(FenInitial()) {
    _updateFen();
    boardLogicBloc.stream.listen((state) {
      if (state is BoardLoaded || state is PieceMoved) {
        _updateFen();
      }
    });
  }

  void _updateFen() {
    final board = boardLogicBloc.board;
    final currentPlayer = boardLogicBloc.state is BoardLoaded
        ? (boardLogicBloc.state as BoardLoaded).currentPlayer
        : PlayerType.white;

    final fenString = _generateFen(board, currentPlayer);
    emit(FenUpdated(fen: fenString));
  }

  String _generateFen(List<BoardCellModel> board, PlayerType currentPlayer) {
    List<String> fenRows = [];
    for (int row = 0; row < 8; row++) {
      String rowFen = '';
      int emptyCount = 0;
      for (int col = 0; col < 8; col++) {
        final cell = board[row * 8 + col];
        if (cell.hasPiece) {
          if (emptyCount > 0) {
            rowFen += emptyCount.toString();
            emptyCount = 0;
          }
          rowFen += _pieceToFen(cell.pieceEntity!);
        } else {
          emptyCount++;
        }
      }
      if (emptyCount > 0) {
        rowFen += emptyCount.toString();
      }
      fenRows.add(rowFen);
    }

    final turn = currentPlayer == PlayerType.white ? 'w' : 'b';
    const castling = '-'; // Castling rights can be implemented later
    const enPassant = '-'; // En passant can be implemented later
    const halfMove = '0'; // Halfmove clock (for 50-move rule) can be tracked later
    const fullMove = '1'; // Fullmove number (increments after Black moves)

    return '${fenRows.join('/')} $turn $castling $enPassant $halfMove $fullMove';
  }

  String _pieceToFen(PieceEntity piece) {
    final symbols = {
      'pawn': 'p',
      'knight': 'n',
      'bishop': 'b',
      'rook': 'r',
      'queen': 'q',
      'king': 'k',
    };
    final fenSymbol = symbols[piece.rank] ?? '?';
    return piece.playerType == PlayerType.white ? fenSymbol.toUpperCase() : fenSymbol;
  }
}