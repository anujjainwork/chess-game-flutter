import 'package:chess/features/board/business/entity/cell_entity.dart';

class BoardCellModel extends BoardCellEntity {
  BoardCellModel({required super.cellPosition, required super.hasPiece, super.pieceEntity});
}
