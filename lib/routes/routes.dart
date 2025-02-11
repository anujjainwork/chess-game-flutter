import 'package:chessmate/features/1vsBot/presentation/board_view.dart';
import 'package:chessmate/features/about_dev/presentation/view/about_dev_view.dart';
import 'package:chessmate/features/about_dev/presentation/widgets/web_view.dart';
import 'package:chessmate/features/1v1_mode/presentation/board_view.dart';
import 'package:chessmate/routes/routing_fade_animation.dart';
import 'package:flutter/material.dart';

class AppRouteNames {
  // 1v1 game
  static const oneVsOneGame = 'oneVsOneGame';
  // 1vsBot game
  static const oneVsBotGame = 'oneVsBotGame';
  // about the dev
  static const aboutTheDev = 'aboutTheDev';
  //web view
  static const webView = 'webView';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.oneVsOneGame:
        return _buildFadePageRoute(
          const OneVsOneBoardGameView(),
          name: AppRouteNames.oneVsOneGame,
        );
        case AppRouteNames.oneVsBotGame:
        return _buildFadePageRoute(
          const OneVsBotBoardGameView(),
          name: AppRouteNames.oneVsBotGame,
        );
      case AppRouteNames.aboutTheDev:
        return _buildFadePageRoute(
          const AboutDev(),
          name: AppRouteNames.aboutTheDev,
        );
      case AppRouteNames.webView:
      final args = settings.arguments as List<String>;
        return _buildFadePageRoute(
          WebViewScreen(url: args[0], header: args[1],),
          name: AppRouteNames.webView,
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
