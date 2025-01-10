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
  PlayerType _currentPlayer = PlayerType.white;

  BoardLogicBloc({required this.timerCubit}) : super(BoardLogicInitial()) {
    on<InitializeBoard>(_onInitializeBoard);
    on<SelectPiece>(_onSelectPiece);
    on<DeselectPiece>(_onDeselectPiece);
    on<MovePiece>(_onMovePiece);
  }

  List<BoardCellModel> get board => _board;

  void _onInitializeBoard(
      InitializeBoard event, Emitter<BoardLogicState> emit) {
    _board = generateInitialBoard();
    emit(BoardLoaded(_board, _currentPlayer));
    timerCubit.startTimer(_currentPlayer); // Start the timer for the initial player
  }

  void _onSelectPiece(SelectPiece event, Emitter<BoardLogicState> emit) {
    final selectedCell = _board[event.cellIndex];
    if (selectedCell.hasPiece &&
        selectedCell.pieceEntity!.playerType == _currentPlayer) {
      emit(PieceSelected(event.cellIndex, _currentPlayer));
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
        targetCell.pieceEntity!.playerType == _currentPlayer) {
      return;
    }

    var isValid = isValidMove(
      rank: movingPiece.pieceEntity!.rank,
      player: movingPiece.pieceEntity!.player,
      fromIndex: event.fromIndex,
      toIndex: event.toIndex,
      board: _board,
    );

    if (isValid) {
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

      _currentPlayer = _currentPlayer == PlayerType.white
          ? PlayerType.black
          : PlayerType.white;

      emit(PieceMoved(event.fromIndex, event.toIndex));
      emit(BoardLoaded(_board, _currentPlayer));

      // Start the timer for the next player
      timerCubit.startTimer(_currentPlayer);
    } else {
      emit(InvalidMoveAttempted('Move not valid'));
    }
  }
}
