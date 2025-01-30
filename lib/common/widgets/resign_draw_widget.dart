import 'package:chess/common/utils.dart';
import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:chess/features/board/logic/bloc/game_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget getResignDrawWidgets(
    BuildContext context, MainAxisAlignment mainAxisAlignment, GameStatusBloc gameStatusBloc, bool isPlayerWhite) {
  double iconSize = getDynamicWidth(context, 10);

  return Transform.rotate(angle: isPlayerWhite?0:3.14159,
  child: Row(
    mainAxisAlignment: mainAxisAlignment,
    children: [
      IconButton(
        onPressed: () {
          gameStatusBloc.add(InitiateDraw(
              playerType: isPlayerWhite ? PlayerType.white : PlayerType.black));
        },
        icon: SvgPicture.asset(
          'lib/assets/draw-button.svg',
          width: iconSize,
          height: iconSize,
        ),
      ),
      IconButton(
        onPressed: () {
          gameStatusBloc.add(InitiateResign(playerType: isPlayerWhite ? PlayerType.white : PlayerType.black));
        },
        icon: SvgPicture.asset(
          'lib/assets/resign.svg',
          width: iconSize,
          height: iconSize,
        ),
      ),
    ],
  ),);
}


