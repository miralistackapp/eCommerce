import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning/app/widget/app_image_assets.dart';
import 'package:learning/constant/app_asset.dart';
import 'package:learning/constant/color_constant.dart';

class AppTextFormFiled extends StatelessWidget {
  final TextEditingController? controller;
  final GestureTapCallback? onTap;
  final String? prefixIcon;
  final String? hintText;
  final bool enabled;
  final bool isPhone;
  final bool isAlphabets;
  final bool showVisibility;
  final bool visibility;
  final bool isError;
  final int? length;
  final GestureTapCallback? suffixTap;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;

  const AppTextFormFiled({
    Key? key,
    this.controller,
    this.onTap,
    this.prefixIcon,
    this.hintText,
    this.enabled = false,
    this.isPhone = false,
    this.isAlphabets = false,
    this.showVisibility = false,
    this.visibility = false,
    this.isError = false,
    this.length,
    this.suffixTap,
    this.textInputType = TextInputType.name,
    this.textInputAction = TextInputAction.next,
    this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isError
              ? ColorConstant.appRed
              : ColorConstant.appTransparent,
        ),
        color: ColorConstant.appWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: ColorConstant.appBoxShadow,
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          if (prefixIcon != null)
            Container(
              decoration: BoxDecoration(
                color: ColorConstant.appRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: AppImageAsset(
                image: prefixIcon,
                height: 18,
                color: ColorConstant.appRed,
              ),
            ),
          Expanded(
            child: TextFormField(
              onTap: onTap,
              controller: controller,
              onChanged: onChanged,
              obscureText: visibility,
              style: GoogleFonts.inter(
                color: ColorConstant.appBlack,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              readOnly: enabled,
              obscuringCharacter: '•',
              cursorColor: ColorConstant.appLightBlack,
              keyboardType: textInputType,
              textInputAction: textInputAction,
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter,
                if (isPhone) LengthLimitingTextInputFormatter(length),
                if (isPhone) FilteringTextInputFormatter.digitsOnly,
                if (isAlphabets) FilteringTextInputFormatter.allow(RegExp(r'[a-z A-Z]')),
              ],
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.inter(
                  color: ColorConstant.appLightBlack,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              ),
            ),
          ),
          if (showVisibility)
            InkWell(
              onTap: suffixTap,
              child: Container(
                padding: const EdgeInsets.only(right: 14),
                child: AppImageAsset(
                  image: visibility
                      ? AppAsset.visibilityIcon
                      : AppAsset.visibilityOffIcon,
                  color: ColorConstant.appLightBlack,
                  height: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
