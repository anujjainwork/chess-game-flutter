import 'package:chess/common/colors.dart';
import 'package:chess/common/utils.dart';
import 'package:chess/features/about_dev/presentation/widgets/pfp_widget.dart';
import 'package:chess/features/about_dev/presentation/widgets/social_link_widget.dart';
import 'package:flutter/material.dart';

class AboutDev extends StatelessWidget {
  const AboutDev({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkGreenBackgroundColor,
        body: Center(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getDynamicWidth(context, 5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Meet the Dev',
                  style: TextStyle(
                    fontSize: getDynamicHeight(context, 3.5),
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
                getPfpWidget(context),
                SizedBox(height: getDynamicHeight(context, 3)),
                Text(
                  'Hi! I’m a full-stack app developer skilled \n in building industry-ready apps with \nSpring Boot, Flutter, Swift, & Kotlin.',
                  style: TextStyle(
                    fontSize: getDynamicHeight(context, 1.5),
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
  }
}
