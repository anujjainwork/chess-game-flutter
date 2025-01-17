import 'package:chess/features/board/business/entity/piece_entity.dart';

class BoardCellEntity {
  int cellPosition;
  bool hasPiece;
  PieceEntity? pieceEntity;

  BoardCellEntity({
    required this.cellPosition,
    required this.hasPiece,
    this.pieceEntity,
  });

  Map<String, dynamic> toMap() {
    return {
      'cellPosition': cellPosition,
      'hasPiece': hasPiece ? 1 : 0,
      'pieceEntity': pieceEntity,
    };
  }

  // Create a BoardCellEntity from a Map
  factory BoardCellEntity.fromMap(Map<String, dynamic> map) {
    return BoardCellEntity(
      cellPosition: map['cellPosition'],
      hasPiece: map['hasPiece'] == 1,
      pieceEntity: map['pieceEntity'],
    );
  }
}
