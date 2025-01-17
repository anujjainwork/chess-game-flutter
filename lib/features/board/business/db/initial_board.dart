import 'package:chess/features/board/data/model/cell_model.dart';
import 'package:chess/features/board/data/model/piece_model.dart';

List<BoardCellModel> generateInitialBoard() {
  List<String> initialSetup = [
    'rook_black', 'knight_black', 'bishop_black', 'queen_black', 'king_black', 'bishop_black', 'knight_black', 'rook_black',
    'pawn_black', 'pawn_black', 'pawn_black', 'pawn_black', 'pawn_black', 'pawn_black', 'pawn_black', 'pawn_black',
    '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '',
    '', '', '', '', '', '', '', '',
    'pawn_white', 'pawn_white', 'pawn_white', 'pawn_white', 'pawn_white', 'pawn_white', 'pawn_white', 'pawn_white',
    'rook_white', 'knight_white', 'bishop_white', 'queen_white', 'king_white', 'bishop_white', 'knight_white', 'rook_white',
  ];

  return List.generate(64, (index) {
    String pieceId = initialSetup[index];
    return BoardCellModel(
      cellPosition: index,
      hasPiece: pieceId.isNotEmpty,
      pieceEntity: PieceModel.fromPieceId(pieceId),
    );
  });
}
