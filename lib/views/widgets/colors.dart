import 'package:flutter/material.dart';

class ColorConstants {
  static Color darkGray = const Color(0xFF9F9F9F);
  static Color black = const Color(0xFF000000);
  static Color white = const Color(0xFFFFFFFF);

  static Color transparent = hexToColor('#0000ffff');
  static Color primary = hexToColor('#0C54BE');
  static Color primaryDark = hexToColor('#303F60');
  static Color secondary = hexToColor('#F5F9FD');
  static Color secondaryDark = hexToColor('#CED3DC');

}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}
