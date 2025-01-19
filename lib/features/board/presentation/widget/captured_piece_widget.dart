import 'package:chess/features/board/business/entity/piece_entity.dart';
import 'package:chess/common/colors.dart';
import 'package:chess/common/utils.dart';
import 'package:chess/common/map_piece_icons.dart';
import 'package:flutter/material.dart';

Widget getCapturedPiecesWidget(
    List<PieceEntity> capturedPieces, BuildContext context, bool isForWhite) {
  // Group pieces by pieceId
  final Map<String, int> pieceCount = {};
  for (var piece in capturedPieces) {
    pieceCount[piece.pieceId] = (pieceCount[piece.pieceId] ?? 0) + 1;
  }

  // Constants for layout
  final containerWidth = getDynamicWidth(context, 60);
  final baseIconSize = getDynamicWidth(context, 8);
  final iconSpacing = getDynamicWidth(context, 0.3);

  // If there are no captured pieces, return a default size
  if (capturedPieces.isEmpty) {
    return Container(
      width: containerWidth,
      height: baseIconSize + iconSpacing, // Default height
      decoration: BoxDecoration(
        color: isForWhite
            ? AppColors.darkGreenBoxColor
            : AppColors.lightGreenBoxColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }

  // Calculate total icons and required rows
  final totalIcons = pieceCount.keys.length;
  final maxIconsPerRow =
      (containerWidth / (baseIconSize + iconSpacing)).floor();
  final rows = (totalIcons / maxIconsPerRow).ceil();

  // Adjust icon size if necessary
  final iconSize = rows > 1 ? baseIconSize * (1 / rows) : baseIconSize;

  return Transform.rotate(
    angle: isForWhite ? 3.14159 : 0,
    child: Container(
      width: containerWidth,
      height: (rows * (iconSize + iconSpacing) + iconSpacing).toDouble(),
      decoration: BoxDecoration(
        color: isForWhite
            ? AppColors.darkGreenBoxColor
            : AppColors.lightGreenBoxColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Wrap(
        spacing: iconSpacing,
        runSpacing: iconSpacing,
        children: [
          for (var entry in pieceCount.entries)
            SizedBox(
              width: iconSize + iconSpacing,
              height: iconSize + iconSpacing,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: iconSize,
                    height: iconSize,
                    child: getPieceIcon(entry.key),
                  ),
                  if (entry.value > 1)
                    Positioned(
                      right: -iconSize * 0.1,
                      top: -iconSize * 0.1,
                      child: CircleAvatar(
                        radius: iconSize * 0.3,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${entry.value}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: iconSize * 0.4,
                            fontWeight: FontWeight.bold,
                          ),
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
