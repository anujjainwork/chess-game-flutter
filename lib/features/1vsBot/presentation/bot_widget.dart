import 'package:chess/common/colors.dart';
import 'package:chess/common/utils.dart';
import 'package:chess/features/1vsBot/bot/logic/bot_dialogues_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

Widget getBotWidget(BuildContext context) {
  return BlocBuilder<BotDialoguesCubit, BotDialoguesState>(
    builder: (context, botDialoguesState) {
      return Stack(
        children: [
          // Speech Bubble
          Container(
              height: getDynamicHeight(context, 10),
              width: getDynamicWidth(context, 80),
              margin: const EdgeInsets.only(right: 10, bottom: 15),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                  gradient: botDialoguesState is BotDialogueTriggered
                      ? AppColors.timerWidgetGradient
                      : null),
              child: Center(
                child: Text(
                  botDialoguesState is BotDialogueTriggered
                      ? botDialoguesState.message
                      : '',
                  style: TextStyle(
                    fontSize: getDynamicWidth(
                        context, botDialoguesState.isSmallText ? 5 : 4.5),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),

          // Bot Icon (SVG)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    SvgPicture.asset('lib/assets/bot_icon.svg',
                        width: getDynamicWidth(context, 20),
                        height: getDynamicWidth(context, 20)),
                    Text('ChessRobo', style: TextStyle(fontSize: getDynamicWidth(context, 3), color: Colors.white, fontWeight: FontWeight.bold),)
                  ],
                )),
          )
        ],
      );
    },
  );
}
