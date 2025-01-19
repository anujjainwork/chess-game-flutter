import 'package:chess/common/utils.dart';
import 'package:chess/features/board/business/enums/player_type_enum.dart';
import 'package:chess/features/board/presentation/bloc/board_bloc_builder.dart';
import 'package:chess/features/board/presentation/bloc/game_status_bloc.dart';
import 'package:flutter/material.dart';

Widget getGameDrawOrResignWidget(BuildContext context, GameStatusBloc gameStatusBloc,
    GameStatusState gameStatusState, bool isDrawCalled) {
  return SizedBox(
    height: getDynamicHeight(context, 90),
    width: getDynamicWidth(context, 100),
    child: Stack(
      children: [
        boardGameBlocBuilder(gameStatusBloc),
        Align(
            alignment: isDrawCalled
                ? gameStatusState.player == PlayerType.white
                    ? Alignment.topCenter
                    : Alignment.bottomCenter
                : gameStatusState.player == PlayerType.white
                    ? Alignment.bottomCenter
                    : Alignment.topCenter,
            child: Transform.rotate(
                angle: isDrawCalled
                    ? gameStatusState.player == PlayerType.white
                        ? 3.14159
                        : 0
                    : gameStatusState.player == PlayerType.white
                        ? 0
                        : 3.14159,
                child: Container(
                  height: getDynamicHeight(context, 10),
                  width: getDynamicWidth(context, 90),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        isDrawCalled?'Do you want a draw?':'Do you want to resign?',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: getDynamicWidth(context, 4.5)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getDynamicWidth(context, 4)),
                            ),
                            onTap: () {
                              isDrawCalled
                                ? gameStatusBloc.add(AcceptDraw())
                                : gameStatusBloc.add(ConfirmResign(playerType: gameStatusState.player!));
                            },
                          ),
                          GestureDetector(
                            child: Text('No',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: getDynamicWidth(context, 4))),
                            onTap: () {
                              isDrawCalled
                                ? gameStatusBloc.add(DenyDraw())
                                : gameStatusBloc.add(CancelResign(playerType: gameStatusState.player!));
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ))),
      ],
    ),
  );
}
