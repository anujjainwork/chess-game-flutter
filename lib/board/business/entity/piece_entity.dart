class PieceEntity {
  final String rank;
  final String player;

  PieceEntity({required this.rank, required this.player});
  // static PieceEntity? fromPieceId(String pieceId) {
  //   if (pieceId.isEmpty) return null;

  //   final parts = pieceId.split('_');
  //   return PieceEntity(rank: parts[0], player: parts[1]);
  // }

  String get pieceId => '${rank}_$player';
}
