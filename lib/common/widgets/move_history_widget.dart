import 'package:chess/common/utils.dart';
import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:chess/features/board/logic/cubit/move_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget getMoveHistoryWidgetWhite(
    BuildContext context,
    MainAxisAlignment mainAxisAlignment,
    MoveHistoryCubit moveHistoryCubit,
    PlayerType currentPlayer) {
  double iconSize = getDynamicWidth(context, 10);

  return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        IconButton(
          onPressed: () {
            currentPlayer == PlayerType.white
              ? moveHistoryCubit.undoMove()
              : null;
          },
          icon: SvgPicture.asset(
            'lib/assets/back-button.svg',
            width: iconSize,
            height: iconSize,
          ),
        ),
        IconButton(
          onPressed: () {
            currentPlayer == PlayerType.white
            ? moveHistoryCubit.redoMove()
            : null;
          },
          icon: SvgPicture.asset(
            'lib/assets/forward-button.svg',
            width: iconSize,
            height: iconSize,
          ),
        ),
      ],
  );
}

Widget getMoveHistoryWidgetBlack(
    BuildContext context,
    MainAxisAlignment mainAxisAlignment,
    MoveHistoryCubit moveHistoryCubit,
    PlayerType currentPlayer) {
  double iconSize = getDynamicWidth(context, 10);

  return Transform.rotate(
    angle: 3.14159,
    child: Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        IconButton(
          onPressed: () {
            currentPlayer == PlayerType.black
            ? moveHistoryCubit.undoMove()
            : null;
          },
          icon: SvgPicture.asset(
            'lib/assets/back-button.svg',
            width: iconSize,
            height: iconSize,
          ),
        ),
        IconButton(
          onPressed: () {
            currentPlayer == PlayerType.black
            ? moveHistoryCubit.redoMove()
            : null;
          },
          icon: SvgPicture.asset(
            'lib/assets/forward-button.svg',
            width: iconSize,
            height: iconSize,
          ),
        ),
      ],
    ),
  );
}