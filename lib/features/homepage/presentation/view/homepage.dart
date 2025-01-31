import 'package:chess/common/colors.dart';
import 'package:chess/common/utils.dart';
import 'package:chess/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.appHomePageGradient,
              ),
            ),
            Center(child: Opacity(opacity: 0.5,
            child: Container(
              width: getDynamicWidth(context, 70),
              child: Image.asset('lib/assets/Chessmate_logo.png'),
            ),)
            ),

            // 3D Model - Enlarged Chessboard
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: getDynamicHeight(context, 40), // Increased size
                width: getDynamicWidth(context, 95), // Adjusted width
                child: const ModelViewer(
                  src: 'lib/assets/3d/chess_board.glb',
                  autoRotate: true,
                  cameraControls: true,
                  disableZoom: true,
                  disablePan: true,
                  disableTap: true,
                ),
              ),
            ),

            // Bottom Content (Title + Buttons)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: getDynamicHeight(context, 5)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      'Choose a game mode',
                      style: TextStyle(
                        fontSize: getDynamicHeight(context, 3),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: getDynamicHeight(context, 2)),

                    // Game Mode Buttons
                    _buildGlowingButton(
                      context,
                      label: '1 vs 1',
                      routeName: AppRouteNames.oneVsOneGame,
                    ),
                    SizedBox(height: getDynamicHeight(context, 3)),

                    _buildGlowingButton(
                      context,
                      label: '1 vs Bot',
                      routeName: AppRouteNames.oneVsBotGame,
                    ),
                    SizedBox(height: getDynamicHeight(context, 3)),

                    _buildGlowingButton(
                      context,
                      label: 'Know about the developer',
                      routeName: AppRouteNames.aboutTheDev,
                      isSmall: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create glowing buttons with GestureDetector
  Widget _buildGlowingButton(
    BuildContext context, {
    required String label,
    required String routeName,
    bool isSmall = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        height: getDynamicHeight(context, 5),
        width: getDynamicWidth(context, 80),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.8), // Glow effect
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: getDynamicWidth(context, 5),
          // vertical: getDynamicHeight(context, 1.5),
        ),
        child: Center(child: Text(
          label,
          style: TextStyle(
            fontSize: getDynamicHeight(context, isSmall ? 2 : 2.5),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),)
      ),
    );
  }
}
