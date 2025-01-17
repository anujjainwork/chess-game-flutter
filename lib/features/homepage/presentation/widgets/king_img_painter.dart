import 'dart:ui';

import 'package:chess/common/utils.dart';
import 'package:flutter/material.dart';

class KingImagePainter extends CustomPainter {
  final BuildContext context;
  final ImageInfo kingImageInfo;

  KingImagePainter(this.context, this.kingImageInfo);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..imageFilter = ImageFilter.blur(sigmaX: 2, sigmaY: 2);

    final image = kingImageInfo.image;
    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();

    // Maintain aspect ratio
    final aspectRatio = imageWidth / imageHeight;
    final scaleHeight = getDynamicHeight(context, 150);
    final scaleWidth = scaleHeight * aspectRatio;

    // Adjust X and Y offset for positioning
    final offsetX = getDynamicWidth(context, -140); 
    final offsetY = size.height - scaleHeight  + getDynamicHeight(context, 40);

    // Define rectangle with constrained placement
    final rect = Rect.fromLTWH(
      offsetX,
      offsetY,
      scaleWidth,
      scaleHeight,
    );
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, imageWidth, imageHeight),
      rect,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant KingImagePainter oldDelegate) {
    return oldDelegate.kingImageInfo != kingImageInfo;
  }
}
