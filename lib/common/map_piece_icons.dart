import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget getPieceIcon(String pieceId) {
  switch (pieceId) {
    case 'bishop_black':
      return SvgPicture.asset('lib/assets/bishop_black.svg');
    case 'bishop_white':
      return SvgPicture.asset('lib/assets/bishop_white.svg');
    case 'king_black':
      return SvgPicture.asset('lib/assets/king_black.svg');
    case 'king_white':
      return SvgPicture.asset('lib/assets/king_white.svg');
    case 'knight_black':
      return SvgPicture.asset('lib/assets/knight_black.svg');
    case 'knight_white':
      return SvgPicture.asset('lib/assets/knight_white.svg');
    case 'pawn_black':
      return SvgPicture.asset('lib/assets/pawn_black.svg');
    case 'pawn_white':
      return SvgPicture.asset('lib/assets/pawn_white.svg');
    case 'queen_black':
      return SvgPicture.asset('lib/assets/queen_black.svg');
    case 'queen_white':
      return SvgPicture.asset('lib/assets/queen_white.svg');
    case 'rook_black':
      return SvgPicture.asset('lib/assets/rook_black.svg');
    case 'rook_white':
      return SvgPicture.asset('lib/assets/rook_white.svg');
    default:
      return const SizedBox.shrink();
  }
}
