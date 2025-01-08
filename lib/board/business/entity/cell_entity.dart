class BoardCellEntity {
  int cellPosition;
  bool hasPiece;
  String? pieceId;

  BoardCellEntity({
    required this.cellPosition,
    required this.hasPiece,
    this.pieceId,
  });

  // Convert BoardCellEntity to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'cellPosition': cellPosition,
      'hasPiece': hasPiece ? 1 : 0,
      'pieceId': pieceId,
    };
  }

  // Create a BoardCellEntity from a Map
  factory BoardCellEntity.fromMap(Map<String, dynamic> map) {
    return BoardCellEntity(
      cellPosition: map['cellPosition'],
      hasPiece: map['hasPiece'] == 1,
      pieceId: map['pieceId'],
    );
  }
}
