import 'package:chess/common/colors.dart';
import 'package:chess/common/utils.dart';
import 'package:chess/features/about_dev/presentation/widgets/social_link_widget.dart';
import 'package:flutter/material.dart';
class AboutDev extends StatefulWidget {
  const AboutDev({super.key});

  @override
  State<AboutDev> createState() => _AboutDevState();
}

class _AboutDevState extends State<AboutDev> {
  late Future<void> _imagePreloadFuture;

  @override
  void initState() {
    super.initState();
    _imagePreloadFuture = _preloadImages();
  }

  Future<void> _preloadImages() async {
    await precacheImage(
      const AssetImage('lib/assets/anuj.jpg'),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = getDynamicWidth(context, 5);
    final double headingFontSize = getDynamicHeight(context, 3.5);
    final double descriptionFontSize = getDynamicHeight(context, 1.5);

    return FutureBuilder<void>(
      future: _imagePreloadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.darkGreenBackgroundColor,
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Meet the Dev',
                      style: TextStyle(
                        fontSize: headingFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: getDynamicHeight(context, 0.5)),
                    Container(
                      height: getDynamicHeight(context, 0.15),
                      width: getDynamicWidth(context, 45),
                      color: Colors.white,
                    ),
                    SizedBox(height: getDynamicHeight(context, 3)),
                    CircleAvatar(
                      radius: getDynamicWidth(context, 30),
                      backgroundColor: Colors.grey.shade200,
                      child: ClipOval(
                        child: Image.asset(
                          'lib/assets/anuj.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: getDynamicWidth(context, 30),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: getDynamicHeight(context, 3)),
                    Text(
                      'Hi! I’m a full-stack app developer skilled \n'
                      'in building industry-ready apps with \n'
                      'Spring Boot, Flutter, Swift, & Kotlin.',
                      style: TextStyle(
                        fontSize: descriptionFontSize,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: getDynamicHeight(context, 4)),
                    SocialLinks(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
