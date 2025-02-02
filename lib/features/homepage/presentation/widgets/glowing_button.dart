import 'package:chess/common/utils.dart';
import 'package:flutter/material.dart';

Widget getGlowingButton(
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
              color: Colors.white.withOpacity(0.4), // Glow effect
              spreadRadius: 1,
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
