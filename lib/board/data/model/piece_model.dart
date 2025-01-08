import 'package:chess/board/business/entity/piece_entity.dart';

class PieceModel extends PieceEntity {
  PieceModel({required super.rank, required super.player});
  static PieceModel? fromPieceId(String pieceId) {
    if (pieceId.isEmpty) return null;

    final parts = pieceId.split('_');
    return PieceModel(rank: parts[0], player: parts[1]);
  }

  String get pieceId => '${rank}_$player';
}
