import 'package:chess/features/board/presentation/view/board_view.dart';
import 'package:chess/routes/routing_fade_animation.dart';
import 'package:flutter/material.dart';

class AppRouteNames {
  // 1v1 game
  static const oneVsOneGame = 'oneVsOneGame';
  // about the dev
  static const aboutTheDev = 'aboutTheDev';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.oneVsOneGame:
        return _buildFadePageRoute(
          const BoardGameView(),
          name: AppRouteNames.oneVsOneGame,
        );
      default:
        return _buildFadePageRoute(const Scaffold());
    }
  }

  static Route<dynamic> _buildFadePageRoute(Widget widget, {String? name}) {
    return FadePageRoute(
      page: widget,
      duration: const Duration(milliseconds: 200),
    );
  }
}
