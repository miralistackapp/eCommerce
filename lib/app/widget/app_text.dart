import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning/constant/color_constant.dart';

class AppText extends StatelessWidget {
  final String title;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextAlign? textAlign;
  final double? height;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final double? letterSpacing;

  const AppText(
    this.title, {
    Key? key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.height,
    this.fontStyle,
    this.maxLines,
    this.overflow,
    this.decoration = TextDecoration.none,
    this.letterSpacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.inter(
        color: color ?? ColorConstant.appBlack,
        fontWeight: fontWeight,
        fontSize: fontSize ?? 14,
        height: height,
        fontStyle: fontStyle,
        decoration: decoration,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
