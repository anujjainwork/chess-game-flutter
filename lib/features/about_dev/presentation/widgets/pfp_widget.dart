import 'package:chess/common/utils.dart';
import 'package:flutter/material.dart';

Widget getPfpWidget(BuildContext context) {
  return CircleAvatar(
    radius: getDynamicWidth(context, 30),
    backgroundColor: Colors.grey.shade200, // Optional background color
    child: ClipOval(
      child: Image.asset(
        'lib/assets/anuj.jpg',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.person, size: getDynamicWidth(context, 30));
        },
      ),
    ),
  );
}
