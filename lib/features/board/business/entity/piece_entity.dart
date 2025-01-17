import 'package:chess/features/board/business/enums/player_type_enum.dart';

class PieceEntity {
  final String rank;
  final String player;
  final PlayerType playerType;

  PieceEntity(this.playerType, {required this.rank, required this.player});
  // static PieceEntity? fromPieceId(String pieceId) {
  //   if (pieceId.isEmpty) return null;

  //   final parts = pieceId.split('_');
  //   return PieceEntity(rank: parts[0], player: parts[1]);
  // }

  String get pieceId => '${rank}_$player';
}
