import 'package:chessmate/features/board/logic/cubit/timer_cubit.dart';
import 'package:chessmate/common/colors.dart';
import 'package:chessmate/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget getTimerWidget(bool isWhite) {
  return BlocBuilder<TimerCubit, TimerState>(
    builder: (context, timerState) {
      if (timerState is TimerUpdated) {
        final whiteTime = timerState.whitePlayer.playerTimeLeft;
        final blackTime = timerState.blackPlayer.playerTimeLeft;

        // Format the minutes and seconds with leading zeros for both minutes and seconds
        String formatTime(Duration time) {
          final minutes = time.inMinutes.toString().padLeft(2, '0');
          final seconds = (time.inSeconds % 60).toString().padLeft(2, '0');
          return '$minutes:$seconds';
        }

        return Transform.rotate(
          angle: isWhite ? 0 : 3.14159,
          child: Container(
            height: getDynamicHeight(context, 6),
            width: getDynamicWidth(context, 20),
            decoration: BoxDecoration(
              gradient: AppColors.timerWidgetGradient,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                isWhite ? formatTime(whiteTime) : formatTime(blackTime),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                ),
              ),
            ),
          ),
        );
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}
