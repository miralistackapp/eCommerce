import 'package:flutter/material.dart';

class ColorConstant {
  static const Color appTransparent = Color(0x00000000);
  static const Color appWhite = Color(0xFFFFFFFF);
  static const Color appBlack = Color(0xFF000000);
  static const Color appLightBlack = Color(0xFF5E5F60);
  static const Color appRed = Color(0xFFC62828);
  static const Color pinkIndicator = Color(0xffEE3175);
  static const Color appBlue = Color(0xFF323173);
  static const Color appYellow = Color(0xFFffa921);
  static const Color appGrey = Color(0xFF535a5d);
  static const Color appProductBorder = Color(0xffE9E9E9);
  static const Color appDarkGreen = Color(0xff233F78);
  static const Color appSuggestionBorder = Color(0xffF5F5F5);

  static Color hex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static List<BoxShadow> appBoxShadow = [
    BoxShadow(
      offset: const Offset(0, 3),
      spreadRadius: 0.2,
      color: ColorConstant.appLightBlack.withOpacity(0.2),
      blurRadius: 2,
    ),
  ];

  static List<BoxShadow> appDarkBoxShadow = [
    BoxShadow(
      offset: const Offset(0, 3),
      spreadRadius: 0.2,
      color: ColorConstant.appWhite.withOpacity(0.2),
      blurRadius: 2,
    ),
  ];
}
