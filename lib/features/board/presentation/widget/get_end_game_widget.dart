import 'package:chess/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget getEndGameWidget(BuildContext context,String reason,bool isDraw) {
  // Define Lottie animation paths or URLs
  final String animationPath = isDraw
      ? 'lib/assets/lottie/draw.json'
      : 'lib/assets/lottie/win_animation.json';

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          animationPath,
          width: getDynamicWidth(context, 100),
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),
        Text(
          reason,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
