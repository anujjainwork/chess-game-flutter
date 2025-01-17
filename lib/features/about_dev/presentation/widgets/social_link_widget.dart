import 'package:chess/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLinks extends StatelessWidget {
  final String githubUrl = 'https://github.com/anujjainwork';
  final String linkedinUrl = 'https://www.linkedin.com/in/anuj-jain-work/';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.github, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, AppRouteNames.webView,arguments: [githubUrl,'Github Profile']);
          },
        ),
        IconButton(
          icon: const Icon(FontAwesomeIcons.linkedin, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, AppRouteNames.webView, arguments: [linkedinUrl, 'Linkedin Profile']);
          },
        ),
      ],
    );
  }
}
