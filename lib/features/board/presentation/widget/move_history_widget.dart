import 'package:chess/common/utils.dart';
import 'package:chess/features/board/presentation/cubit/move_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget getMoveHistoryWidgets(
    BuildContext context,
    MainAxisAlignment mainAxisAlignment,
    MoveHistoryCubit moveHistoryCubit,
    bool isPlayerWhite,) {
  double iconSize = getDynamicWidth(context, 10);

  return Transform.rotate(
    angle: isPlayerWhite ? 0 : 3.14159,
    child: Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        IconButton(
          onPressed: () {
            print('undo tapped');
            moveHistoryCubit.undoMove();
          },
          icon: SvgPicture.asset(
            'lib/assets/back-button.svg',
            width: iconSize,
            height: iconSize,
          ),
        ),
        IconButton(
          onPressed: () {
            print('redo tapped');
            moveHistoryCubit.redoMove();
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
