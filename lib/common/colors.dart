import 'package:flutter/material.dart';

class AppColors {
  static const lightCellColor = Color.fromRGBO(222, 227, 195, 1);
  static const blackCellColor = Color.fromRGBO(7, 80, 35, 1);
  static const darkGreenBackgroundColor = Color.fromRGBO(7, 54, 35, 0.4);
  static const darkGreenBoxColor = Color.fromRGBO(51, 80, 74, 0.5);
  static const lightGreenBoxColor = Color.fromRGBO(51, 80, 74, 0.7);

  static const boxColor1 = Color.fromRGBO(240, 255, 255, 0.1);
  static const boardWidgetGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topLeft,
    stops: [0.0, 0.2, 0.4, 1.0],
    colors: [
      Color.fromRGBO(255, 255, 255, 0.9),
      Color.fromRGBO(255, 255, 255, 1),
      Color.fromRGBO(7, 54, 35, 0.8),
      Color.fromRGBO(255, 255, 255, 1),
    ],
  );

  static const timerWidgetGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.4, 0.5, 1.0],
    colors: [
      Color.fromRGBO(50, 90, 80, 0.8),
      Color.fromRGBO(7, 54, 35, 0.4),
      Color.fromRGBO(7, 54, 35, 0.4),
      Color.fromRGBO(50, 90, 80, 0.5),
    ],
  );

  static const appHomePageGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.35, 0.9, 1.0],
    colors: [
      Color.fromRGBO(0, 15, 10, 0.98),
      Color.fromRGBO(0, 25, 15, 0.98),
      Color.fromRGBO(0, 50, 35, 0.9),
      Color.fromRGBO(0, 40, 30, 0.8),
    ],
  );
}
