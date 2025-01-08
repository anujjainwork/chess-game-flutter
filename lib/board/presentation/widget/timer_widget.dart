import 'package:chess/board/presentation/cubit/timer_cubit.dart';
import 'package:chess/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget getTimerWidget(bool isWhite) {
  return BlocBuilder<TimerCubit, TimerState>(
    builder: (context, timerState) {
      if (timerState is TimerUpdated) {
        final whiteTime = timerState.whitePlayer.playerTimeLeft;
        final blackTime = timerState.blackPlayer.playerTimeLeft;
        return Container(
          height: getDynamicHeight(context, 5),
          width: getDynamicWidth(context, 20),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: isWhite?Text(
                    '${whiteTime.inMinutes}:${whiteTime.inSeconds % 60}',
                    style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                  ):Text(
                    '${blackTime.inMinutes}:${blackTime.inSeconds % 60}',
                    style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                  ),
          )
        );
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}
