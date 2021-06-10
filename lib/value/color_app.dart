import 'package:flutter/material.dart';

class ColorApp {

  ColorApp._();

  static const primary = const MaterialColor(
      0xFFE5E5E5, const <int, Color>{
    0: const Color(0xFF282A36),
    1: const Color(0xFF44475A),
    2: const Color(0xFF1F2028)
  }
  );

  static const blue = const MaterialColor(
      0xFF323232, <int, Color>{
    0: const Color(0xFF18A0FB),
    1: const Color(0xFF18A0FB),
    2: const Color(0xFF18A0FB)
  }
  );

  static const black = const MaterialColor(
      0xFF000000, <int, Color>{
    0: const Color(0xFF000000),
    87: const Color(0xDD000000),
    54: const Color(0x8A000000),
    45: const Color(0x73000000),
    38: const Color(0x61000000),
    26: const Color(0x42000000),
    12: const Color(0x1F000000),
  }
  );

  static const white = const MaterialColor(
      0xFFFFFFFF, <int, Color>{
    12: const Color(0x1FFFFFFF),
    26: const Color(0x42FFFFFF),
    38: const Color(0x61FFFFFF),
    45: const Color(0x73FFFFFF),
    54: const Color(0x8AFFFFFF),
    87: const Color(0xDDFFFFFF),
    0: const Color(0xFFFFFFFF)
  }
  );

  static const Color transparent = Color(0x00000000);
}