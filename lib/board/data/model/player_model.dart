import 'package:chess/board/business/enums/player_type_enum.dart';
import 'package:chess/board/business/entity/player_entity.dart';

class PlayerModel extends PlayerEntity {
  PlayerModel({
    required super.playerType,
    required super.playerTimeLeft,
  });

  get timeLeft => null;

  // Define the copyWith method
  PlayerModel copyWith({
    PlayerType? playerType,
    Duration? playerTimeLeft,
  }) {
    return PlayerModel(
      playerType: playerType ?? this.playerType,
      playerTimeLeft: playerTimeLeft ?? this.playerTimeLeft,
    );
  }
}
