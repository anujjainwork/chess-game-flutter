import 'package:chess/common/colors.dart';
import 'package:chess/common/utils.dart';
import 'package:chess/features/homepage/presentation/widgets/button_shimmer.dart';
import 'package:chess/features/homepage/presentation/widgets/glowing_button.dart';
import 'package:chess/features/homepage/presentation/widgets/shader_1.dart';
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
            // Container(
            //   decoration: const BoxDecoration(
            //     gradient: AppColors.appHomePageGradient,
            //   ),
            // ),
            const SimpleShaderExample(),
            Align(
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    width: getDynamicWidth(context, 70),
                    child: Image.asset('lib/assets/Chessmate_logo.png'),
                  ),
                )),

            // 3D Model - Enlarged Chessboard
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: getDynamicHeight(context, 100), // Increased size
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
                    getGlowingButton(
                      context,
                      label: 'Pass & Play',
                      routeName: AppRouteNames.oneVsOneGame,
                    ),
                    SizedBox(height: getDynamicHeight(context, 3)),

                    getGlowingButton(
                      context,
                      label: 'Play a Bot',
                      routeName: AppRouteNames.oneVsBotGame,
                    ),
                    SizedBox(height: getDynamicHeight(context, 3)),

                    ShimmerButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouteNames.aboutTheDev);
                      },
                      shimmerColorFrom:
                          const Color.fromARGB(255, 255, 255, 255), // Orange
                      shimmerColorTo:
                          const Color.fromARGB(255, 255, 255, 255), // Purple
                      background: Colors.black,
                      borderRadius: 12,
                      shimmerDuration: const Duration(seconds: 3),
                      borderWidth: 1.5,
                      child: Text(
                        'Know the dev',
                        style: TextStyle(
                          fontSize: getDynamicHeight(context, 2.5),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
