import 'package:chess/common/colors.dart';
import 'package:chess/common/utils.dart';
import 'package:chess/features/homepage/presentation/widgets/king_img_painter.dart';
import 'package:chess/routes/routes.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ImageInfo? _kingImageInfo;

  @override
  void initState() {
    super.initState();

    // Preload the image
    _loadImage();
  }

  void _loadImage() async {
    final ImageStream stream = const AssetImage('lib/assets/king_bg.png')
        .resolve(const ImageConfiguration());
    stream.addListener(
      ImageStreamListener(
        (ImageInfo imageInfo, bool synchronousCall) {
          setState(() {
            _kingImageInfo = imageInfo;
          });
        },
        onError: (dynamic exception, StackTrace? stackTrace) {
          debugPrint('Failed to load image: $exception');
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.appHomePageGradient,
              ),
            ),
            // Chess King Image with blur effect
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.appHomePageGradient,
              ),
            ),
            // Use the CustomPainter only when the image is loaded
            if (_kingImageInfo != null)
              CustomPaint(
                size: Size(
                  getDynamicWidth(context, 100) * 2,
                  getDynamicHeight(context, 100) * 2,
                ),
                painter: KingImagePainter(
                  context,
                  _kingImageInfo!, // Pass the preloaded image
                ),
              ),

            // Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: getDynamicHeight(context, 10)),
                  Text(
                    'ChessMate',
                    style: TextStyle(
                      fontSize: getDynamicHeight(context, 3),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: getDynamicHeight(context, 1)),
                  Container(
                    height: getDynamicHeight(context, 0.5),
                    width: getDynamicWidth(context, 30),
                    color: Colors.white,
                  ),
                  SizedBox(height: getDynamicHeight(context, 25)),
                  // Play 1v1 Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: getDynamicWidth(context, 20),
                        vertical: getDynamicHeight(context, 2),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouteNames.oneVsOneGame);
                    },
                    child: Text(
                      'Play 1v1',
                      style: TextStyle(
                        fontSize: getDynamicHeight(context, 2),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: getDynamicHeight(context, 5),),
                  // Play 1vBot Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: getDynamicWidth(context, 20),
                        vertical: getDynamicHeight(context, 2),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouteNames.oneVsBotGame);
                    },
                    child: Text(
                      'vs Bot',
                      style: TextStyle(
                        fontSize: getDynamicHeight(context, 2),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: getDynamicHeight(context, 2)),
                  // Know About the Developer Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: getDynamicWidth(context, 8),
                        vertical: getDynamicHeight(context, 1.5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouteNames.aboutTheDev);
                    },
                    child: Text(
                      'Know about the developer',
                      style: TextStyle(
                        fontSize: getDynamicHeight(context, 1.5),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
