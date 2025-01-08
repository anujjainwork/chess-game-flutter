import 'package:chess/board/business/entity/piece_entity.dart';
import 'package:chess/board/business/enums/player_type_enum.dart';

class PieceModel extends PieceEntity {
  PieceModel(super.playerType, {required super.rank, required super.player});
  static PieceModel? fromPieceId(String pieceId) {
    if (pieceId.isEmpty) return null;
    final parts = pieceId.split('_');
    if (parts[1] == 'white') {
      return PieceModel(rank: parts[0], player: parts[1], PlayerType.white);
    } else {
      return PieceModel(rank: parts[0], player: parts[1], PlayerType.black);
    }
  }

  String get pieceId => '${rank}_$player';
}
