import 'package:chessmate/features/board/business/enums/player_type_enum.dart';

class PlayerEntity{
  PlayerType playerType;
  Duration playerTimeLeft;

  PlayerEntity({required this.playerType,required this.playerTimeLeft});
}