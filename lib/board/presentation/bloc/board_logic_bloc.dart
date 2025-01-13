import 'package:bloc/bloc.dart';
import 'package:chess/board/business/db/initial_board.dart';
import 'package:chess/board/business/enums/player_type_enum.dart';
import 'package:chess/board/data/model/cell_model.dart';
import 'package:chess/board/data/repository_impl/move_validation.dart';
import 'package:chess/board/presentation/cubit/timer_cubit.dart';
import 'package:equatable/equatable.dart';

part 'board_logic_event.dart';
part 'board_logic_state.dart';

class BoardLogicBloc extends Bloc<BoardLogicEvent, BoardLogicState> {
  final TimerCubit timerCubit;

  List<BoardCellModel> _board = [];
  int whiteKingIndex = 60;
  int blackKingIndex = 4;
  PlayerType _currentPlayer = PlayerType.white;

  BoardLogicBloc({required this.timerCubit}) : super(BoardLogicInitial()) {
    on<InitializeBoard>(_onInitializeBoard);
    on<SelectPiece>(_onSelectPiece);
    on<DeselectPiece>(_onDeselectPiece);
    on<MovePiece>(_onMovePiece);
    on<PlayerIsInCheck>(_playerIsInCheck);
  }

  List<BoardCellModel> get board => _board;

  void _onInitializeBoard(
      InitializeBoard event, Emitter<BoardLogicState> emit) {
    _board = generateInitialBoard();
    emit(BoardLoaded(_board, _currentPlayer));
    timerCubit
        .startTimer(_currentPlayer); // Start the timer for the initial player
  }

void _onSelectPiece(SelectPiece event, Emitter<BoardLogicState> emit) {
  print('piece selected');
  final selectedCell = _board[event.cellIndex];
  if (selectedCell.hasPiece &&
      selectedCell.pieceEntity!.playerType == _currentPlayer) {
    // Calculate valid moves
    final validMoves = _board
        .asMap()
        .entries
        .where((entry) => isValidMove(
              rank: selectedCell.pieceEntity!.rank,
              player: selectedCell.pieceEntity!.player,
              fromIndex: event.cellIndex,
              toIndex: entry.key,
              board: _board,
            ))
        .map((entry) => entry.key)
        .toList();

    emit(PieceSelected(selectedCell.cellPosition, selectedCell.pieceEntity!.playerType, board));
    emit(ValidMovesHighlighted(event.cellIndex, validMoves, _board));
  }
}



  void _onDeselectPiece(DeselectPiece event, Emitter<BoardLogicState> emit) {
    emit(BoardLoaded(_board, _currentPlayer));
  }

  void _onMovePiece(MovePiece event, Emitter<BoardLogicState> emit) {
  final movingPiece = _board[event.fromIndex];
  final targetCell = _board[event.toIndex];

  if (!movingPiece.hasPiece ||
      movingPiece.pieceEntity!.playerType != _currentPlayer) return;

  if (targetCell.hasPiece &&
      targetCell.pieceEntity!.playerType == _currentPlayer) return;

  final isValid = isValidMove(
    rank: movingPiece.pieceEntity!.rank,
    player: movingPiece.pieceEntity!.player,
    fromIndex: event.fromIndex,
    toIndex: event.toIndex,
    board: _board,
  );

  if (isValid) {
    // Move the piece and update the board
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

    _updateKingIndex(movingPiece, event);
    _currentPlayer = _switchPlayer(_currentPlayer);

    emit(PieceMoved(event.fromIndex, event.toIndex));
    emit(BoardLoaded(_board, _currentPlayer));

    // Check if the move places the opponent in check
    _playerIsInCheck(PlayerIsInCheck(_currentPlayer), emit);

    // Start the timer for the next player
    timerCubit.startTimer(_currentPlayer);
  } else {
    emit(InvalidMoveAttempted('Move not valid'));
  }
}

  void _playerIsInCheck(PlayerIsInCheck event, Emitter<BoardLogicState> emit) {
  final player = event.playerType;

  if (_isKingInCheck(player)) {
    emit(IsCheckState(player));

    // Optionally restrict valid moves
    final validMoves = _board
        .where((cell) =>
            cell.hasPiece && cell.pieceEntity!.playerType == player)
        .expand((cell) {
      return _board
          .where((target) =>
              _doesMoveResolveCheck(cell.cellPosition, target.cellPosition, player))
          .map((target) => MovePiece(cell.cellPosition, target.cellPosition));
    }).toList();

    print('Player is in check! Valid moves to resolve check: $validMoves');
  }
}

  bool _doesMoveResolveCheck(
    int fromIndex,
    int toIndex,
    PlayerType player,
  ) {
    // Simulate the move
    final backupFrom = _board[fromIndex];
    final backupTo = _board[toIndex];

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

    final resolvesCheck = !_isKingInCheck(player);

    // Undo the move
    _board[fromIndex] = backupFrom;
    _board[toIndex] = backupTo;

    return resolvesCheck;
  }

  bool _isKingInCheck(PlayerType player) {
    int kingIndex;
    if(player==PlayerType.white){
      kingIndex = blackKingIndex;
    }
    else{
      kingIndex = whiteKingIndex;
    }
  // Validate if any opponent piece can attack the king
  for (final cell in _board) {
    if (cell.hasPiece && cell.pieceEntity!.playerType != player) {
      if (isValidMove(
        rank: cell.pieceEntity!.rank,
        player: cell.pieceEntity!.player,
        fromIndex: cell.cellPosition,
        toIndex: kingIndex,
        board: _board,
      )) {
        return true;
      }
    }
  }
  return false;
}


  void _updateKingIndex(BoardCellModel movingPiece, MovePiece event) {
    if (movingPiece.pieceEntity!.rank == 'king') {
      if (movingPiece.pieceEntity!.playerType == PlayerType.white) {
        whiteKingIndex = event.toIndex;
      }
      blackKingIndex = event.toIndex;
    }
  }

  PlayerType _switchPlayer(PlayerType currentPlayer) {
    return currentPlayer == PlayerType.white
        ? PlayerType.black
        : PlayerType.white;
  }
}
