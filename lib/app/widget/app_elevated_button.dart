import 'package:flutter/material.dart';
import 'package:learning/app/widget/app_text.dart';
import 'package:learning/constant/color_constant.dart';

class AppElevatedButton extends StatelessWidget {
  final double horizontalMargin;
  final double width;
  final VoidCallback? onPressed;
  final String? buttonName;
  final double fontSize;
  final Color textColor;
  final Color buttonColor;

  const AppElevatedButton({
    Key? key,
    this.horizontalMargin = 30,
    this.width = double.infinity,
    @required this.onPressed,
    @required this.buttonName,
    this.fontSize = 14,
    this.textColor = ColorConstant.appWhite,
    this.buttonColor = ColorConstant.appBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
          minimumSize: MaterialStateProperty.all<Size>(Size(width, 50)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: AppText(
          buttonName!,
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
