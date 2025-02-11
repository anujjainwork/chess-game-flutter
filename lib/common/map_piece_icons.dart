import 'package:chessmate/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget getPieceIcon(String pieceId, BuildContext context) {
  final double boardSize =
      getDynamicWidth(context, 85);
  final double iconWidth = boardSize / 8.1;
  switch (pieceId) {
    case 'bishop_black':
      return SvgPicture.asset('lib/assets/bishop_black.svg',width: iconWidth);
    case 'bishop_white':
      return SvgPicture.asset('lib/assets/bishop_white.svg',width: iconWidth);
    case 'king_black':
      return SvgPicture.asset('lib/assets/king_black.svg',width: iconWidth);
    case 'king_white':
      return SvgPicture.asset('lib/assets/king_white.svg',width: iconWidth);
    case 'knight_black':
      return SvgPicture.asset('lib/assets/knight_black.svg',width: iconWidth);
    case 'knight_white':
      return SvgPicture.asset('lib/assets/knight_white.svg',width: iconWidth);
    case 'pawn_black':
      return SvgPicture.asset('lib/assets/pawn_black.svg',width: iconWidth);
    case 'pawn_white':
      return SvgPicture.asset('lib/assets/pawn_white.svg',width: iconWidth);
    case 'queen_black':
      return SvgPicture.asset('lib/assets/queen_black.svg',width: iconWidth);
    case 'queen_white':
      return SvgPicture.asset('lib/assets/queen_white.svg',width: iconWidth);
    case 'rook_black':
      return SvgPicture.asset('lib/assets/rook_black.svg',width: iconWidth);
    case 'rook_white':
      return SvgPicture.asset('lib/assets/rook_white.svg',width: iconWidth);
    default:
      return const SizedBox.shrink();
  }
}
