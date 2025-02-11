import 'package:chessmate/features/board/business/entity/cell_entity.dart';
import 'package:chessmate/features/board/business/entity/piece_entity.dart';

class BoardCellModel extends BoardCellEntity {
  BoardCellModel({
    required super.cellPosition,
    required super.hasPiece,
    super.pieceEntity,
  });

  BoardCellModel copyWith({
    int? cellPosition,
    bool? hasPiece,
    PieceEntity? pieceEntity,
  }) {
    return BoardCellModel(
      cellPosition: cellPosition ?? this.cellPosition,
      hasPiece: hasPiece ?? this.hasPiece,
      pieceEntity: pieceEntity ?? this.pieceEntity,
    );
  }
}
