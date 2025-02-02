import 'package:bloc/bloc.dart';
import 'package:chess/features/1vsBot/bot/chess_bot.dart';
import 'package:chess/features/board/business/db/initial_board.dart';
import 'package:chess/features/board/business/entity/piece_entity.dart';
import 'package:chess/features/board/business/enums/game_modes_enum.dart';
import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:chess/features/board/data/model/cell_model.dart';
import 'package:chess/features/board/data/services/is_pinned.dart';
import 'package:chess/features/board/data/services/move_validation.dart';
import 'package:chess/features/board/logic/bloc/game_status_bloc.dart';
import 'package:chess/features/board/logic/cubit/move_history_cubit.dart';
import 'package:chess/features/board/logic/cubit/sfx_cubit.dart';
import 'package:chess/features/board/logic/cubit/timer_cubit.dart';
import 'package:equatable/equatable.dart';

part 'board_logic_event.dart';
part 'board_logic_state.dart';

class BoardLogicBloc extends Bloc<BoardLogicEvent, BoardLogicState> {
  final SfxHapticsCubit sfxCubit;
  final TimerCubit timerCubit;
  final GameStatusBloc gameStatusBloc;
  final MoveHistoryCubit moveHistoryCubit;
  final GameMode gameMode;
  late final ChessBot chessBot;

  List<BoardCellModel> _board = [];
  int whiteKingIndex = 60;
  int blackKingIndex = 4;
  PlayerType _currentPlayer = PlayerType.white;
  bool _isInCheck = false;
  List<PieceEntity> _capturedPiecesWhite = [];
  List<PieceEntity> _capturedPiecesBlack = [];

  BoardLogicBloc({
    required this.sfxCubit,
    required this.gameMode,
    required this.timerCubit,
    required this.gameStatusBloc,
    required this.moveHistoryCubit,
  }) : super(BoardLogicInitial()) {
    chessBot = ChessBot(this);
    on<InitializeBoard>(_onInitializeBoard);
    on<SelectPiece>(_onSelectPiece);
    on<DeselectPiece>(_onDeselectPiece);
    on<MovePiece>(_onMovePiece);
  }

  List<BoardCellModel> get board => _board;

  List<PieceEntity> get capturedPiecesBlack => _capturedPiecesBlack;
  List<PieceEntity> get capturedPiecesWhite => _capturedPiecesWhite;

  // bool get isInCheck => isInCheck;

  bool get getIsInCheck => _isInCheck;

  PlayerType get currentPlayer => _currentPlayer;

  // @override
  // void onTransition(
  //   Transition<BoardLogicEvent, BoardLogicState> transition,
  // ) {
  //   super.onTransition(transition);
  //   print('Board State Transition to:  ${transition.nextState} from ${transition.currentState}');
  // }

  void _onInitializeBoard(
      InitializeBoard event, Emitter<BoardLogicState> emit) {
    _board = generateInitialBoard();
    emit(BoardLoaded(
        _board, _currentPlayer, _capturedPiecesWhite, _capturedPiecesBlack));
    timerCubit
        .startTimer(_currentPlayer); // Start the timer for the initial player
  }

  void _onSelectPiece(SelectPiece event, Emitter<BoardLogicState> emit) {
    final selectedCell = _board[event.cellIndex];

    if (selectedCell.hasPiece &&
        selectedCell.pieceEntity!.playerType == _currentPlayer) {
      final stillCheckAfterInvalidMove = state is InvalidMoveAttempted
          ? state.isInCheck
              ? true
              : false
          : false;
      // Determine if the current state is IsCheckState
      _isInCheck = (state is IsCheckState || stillCheckAfterInvalidMove);

      int originalKingIndex = _currentPlayer == PlayerType.white
          ? whiteKingIndex
          : blackKingIndex; // Store the original king index

      // Calculate valid moves based on the check state
      final validMoves = _board
          .asMap()
          .entries
          .where((entry) {
            final toIndex = entry.key;
            if (_isInCheck) {
              // Validate only moves resolving the check
              return _doesMoveResolveCheck(
                event.cellIndex,
                toIndex,
                _currentPlayer,
                selectedCell.pieceEntity!.rank,
                selectedCell.pieceEntity!.player,
              );
            } else {
              // Validate moves normally
              return isValidMove(
                      rank: selectedCell.pieceEntity!.rank,
                      player: selectedCell.pieceEntity!.player,
                      fromIndex: event.cellIndex,
                      toIndex: toIndex,
                      board: _board,
                      kingIndex: originalKingIndex) &&
                  !isPinned(
                      fromIndex: event.cellIndex,
                      toIndex: toIndex,
                      board: _board,
                      player: _currentPlayer,
                      whiteKingIndex: whiteKingIndex,
                      blackKingIndex: blackKingIndex);
            }
          })
          .map((entry) => entry.key)
          .toList();
      emit(PieceSelected(
        selectedCell.cellPosition,
        selectedCell.pieceEntity!.playerType,
        board,
      ));
      emit(ValidMovesHighlighted(
          _currentPlayer, event.cellIndex, validMoves, _board, _isInCheck));
    }
  }

  void _onDeselectPiece(DeselectPiece event, Emitter<BoardLogicState> emit) {
    if (state is ValidMovesHighlighted) {
      final validMovesState = state as ValidMovesHighlighted;

      if (validMovesState.isInCheck) {
        emit(IsCheckState(_currentPlayer, _board));
      } else {
        emit(BoardLoaded(_board, _currentPlayer, _capturedPiecesWhite,
            _capturedPiecesBlack));
      }
    } else {
      emit(BoardLoaded(
          _board, _currentPlayer, _capturedPiecesWhite, _capturedPiecesBlack));
    }
  }

  void _onMovePiece(MovePiece event, Emitter<BoardLogicState> emit) {
    final movingPiece = _board[event.fromIndex];
    final targetCell = _board[event.toIndex];

    if (!movingPiece.hasPiece ||
        movingPiece.pieceEntity!.playerType != _currentPlayer) return;
    if (targetCell.hasPiece &&
        targetCell.pieceEntity!.playerType == _currentPlayer) return;

    final isInCheck = state is ValidMovesHighlighted
        ? (state as ValidMovesHighlighted).isInCheck ?? false
        : false;

    int originalKingIndex =
        _currentPlayer == PlayerType.white ? whiteKingIndex : blackKingIndex;

    final isValid = isInCheck
        ? _doesMoveResolveCheck(
            event.fromIndex,
            event.toIndex,
            _currentPlayer,
            movingPiece.pieceEntity!.rank,
            movingPiece.pieceEntity!.player,
          )
        : isValidMove(
            rank: movingPiece.pieceEntity!.rank,
            player: movingPiece.pieceEntity!.player,
            fromIndex: event.fromIndex,
            toIndex: event.toIndex,
            board: _board,
            kingIndex: originalKingIndex);

    final isSelectedPiecePinned = isInCheck
        ? false
        : isPinned(
            fromIndex: event.fromIndex,
            toIndex: event.toIndex,
            board: _board,
            player: _currentPlayer,
            whiteKingIndex: whiteKingIndex,
            blackKingIndex: blackKingIndex);

    if (isValid && !isSelectedPiecePinned) {
      if (_board[event.toIndex].hasPiece) {
        sfxCubit.playCaptureSound();
        _currentPlayer == PlayerType.white
            ? _capturedPiecesWhite.add(_board[event.toIndex].pieceEntity!)
            : _capturedPiecesBlack.add(_board[event.toIndex].pieceEntity!);
      }

      // Perform the move
      _board[event.toIndex] = BoardCellModel(
        cellPosition: event.toIndex,
        hasPiece: true,
        pieceEntity: movingPiece.pieceEntity,
      );

      _board[event.fromIndex] = BoardCellModel(
        cellPosition: event.fromIndex,
        hasPiece: false,
        pieceEntity: null,
      );

      moveHistoryCubit.makeMove(List.from(_board));

      // Update the king's index if necessary
      _updateKingIndex(movingPiece, event.toIndex);

      // Check if the move places the opponent in check
      if (_isKingInCheck(_currentPlayer, _board)) {
        if (_isCheckmate(_currentPlayer)) {
          gameStatusBloc.add(PlayerCheckMated(attackingPlayer: _currentPlayer));
        } else {
          _currentPlayer = _switchPlayer(_currentPlayer);
          sfxCubit.playCheckSound();
          emit(IsCheckState(_currentPlayer, _board));
        }
      } else {
        _currentPlayer = _switchPlayer(_currentPlayer);
        sfxCubit.playMoveSound();
        emit(PieceMoved(event.fromIndex, event.toIndex));
        emit(BoardLoaded(_board, _currentPlayer, _capturedPiecesWhite,
            _capturedPiecesBlack));
      }

      // Start the timer for the next player
      timerCubit.startTimer(_currentPlayer);

      Future.delayed(const Duration(milliseconds: 300), () {
        if (gameMode == GameMode.oneVsBot &&
            _currentPlayer == PlayerType.black) {
          chessBot.makeBotMove();
        }
      });

    } else {
      emit(InvalidMoveAttempted('Move not valid', isInCheck, _currentPlayer));
    }
  }

  bool _doesMoveResolveCheck(int fromIndex, int toIndex, PlayerType playerType,
      String rank, String player) {
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
        _updateKingIndex(_board[toIndex], toIndex);
      }

      final resolvesCheck = !_isKingStillInCheck(playerType, _board);

      // Undo the move
      _board[fromIndex] = backupFrom;
      _board[toIndex] = backupTo;

      // Restore the king's original index if it was moved
      if (originalKingIndex != null) {
        _updateKingIndex(_board[originalKingIndex], originalKingIndex);
      }

      return resolvesCheck;
    }
    return false;
  }

  bool _isKingInCheck(PlayerType player, List<BoardCellModel> board1) {
    int kingIndex;
    player == PlayerType.white
        ? kingIndex = blackKingIndex
        : kingIndex = whiteKingIndex;

    // Validate if any opponent piece can attack the king
    for (final cell in board1) {
      if (cell.hasPiece && cell.pieceEntity!.playerType == player) {
        if (isValidMove(
            rank: cell.pieceEntity!.rank,
            player: cell.pieceEntity!.player,
            fromIndex: cell.cellPosition,
            toIndex: kingIndex,
            board: board1,
            kingIndex: kingIndex)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _isKingStillInCheck(PlayerType player, List<BoardCellModel> board2) {
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

  void _updateKingIndex(BoardCellModel movingPiece, int newIndex) {
    if (movingPiece.pieceEntity!.rank == 'king') {
      if (movingPiece.pieceEntity!.playerType == PlayerType.white) {
        whiteKingIndex = newIndex;
      }
      blackKingIndex = newIndex;
    }
  }

  PlayerType _switchPlayer(PlayerType currentPlayer) {
    return currentPlayer == PlayerType.white
        ? PlayerType.black
        : PlayerType.white;
  }

  bool _isCheckmate(PlayerType player) {
    final defendingPlayerType =
        player == PlayerType.white ? PlayerType.black : PlayerType.white;

    // // Check if the king is actually in check
    // if (!_isKingStillInCheck(player)) return false;

    // Iterate over all player's pieces to find any valid move
    for (final cell in _board.where(
        (cell) => cell.hasPiece && cell.pieceEntity!.playerType != player)) {
      final fromIndex = cell.cellPosition;

      for (int toIndex = 0; toIndex < _board.length; toIndex++) {
        if (_doesMoveResolveCheck(fromIndex, toIndex, defendingPlayerType,
            cell.pieceEntity!.rank, cell.pieceEntity!.player)) {
          return false; // A valid move exists
        }
      }
    }

    return true; // No valid moves found
  }
}
