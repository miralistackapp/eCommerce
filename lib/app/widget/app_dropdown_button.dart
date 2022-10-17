import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:learning/app/widget/app_text.dart';
import 'package:learning/constant/color_constant.dart';

class AppDropdownButton extends StatelessWidget {
  final String hint;
  final String? value;
  final List<DropdownMenuItem<String>>? itemBuilder;
  final List<String> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final DropdownButtonBuilder? selectedItemBuilder;
  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight, buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final Widget? icon;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight, dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final Offset? offset;

  const AppDropdownButton({
    required this.hint,
    required this.value,
    this.itemBuilder,
    required this.dropdownItems,
    required this.onChanged,
    this.selectedItemBuilder,
    this.hintAlignment,
    this.valueAlignment,
    this.buttonHeight,
    this.buttonWidth = double.infinity,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        height: 60,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorConstant.appTransparent,
          ),
          color: ColorConstant.appWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: ColorConstant.appBoxShadow,
        ),
        child: DropdownButton2(
          isExpanded: true,
          hint: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            alignment: hintAlignment,
            child: AppText(
              hint,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: ColorConstant.appLightBlack,
            ),
          ),
          value: value,
          items: itemBuilder ??
              dropdownItems.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    width: double.infinity,
                    alignment: valueAlignment,
                    child: AppText(
                      item,
                      color: ColorConstant.appBlack,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      height: 1.4,
                    ),
                  ),
                );
              }).toList(),
          onChanged: onChanged,
          selectedItemBuilder: selectedItemBuilder,
          icon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: icon ?? const Icon(Icons.expand_more),
          ),
          iconSize: iconSize ?? 22,
          iconEnabledColor: iconEnabledColor,
          iconDisabledColor: iconDisabledColor,
          buttonHeight: buttonHeight ?? 50,
          buttonWidth: buttonWidth,
          buttonPadding: buttonPadding ?? const EdgeInsets.fromLTRB(10, 8, 0, 8),
          buttonDecoration: BoxDecoration(
            border: Border.all(color: ColorConstant.appTransparent, width: 0.7),
            borderRadius: BorderRadius.circular(5),
          ),
          buttonElevation: buttonElevation,
          itemHeight: itemHeight ?? 52,
          itemPadding: itemPadding ?? const EdgeInsets.only(left: 14, right: 14),
          dropdownMaxHeight: dropdownHeight ?? 200,
          dropdownWidth: dropdownWidth ?? 290,
          dropdownPadding: dropdownPadding,
          dropdownDecoration: dropdownDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorConstant.appWhite,
              ),
          dropdownElevation: dropdownElevation ?? 8,
          scrollbarRadius: scrollbarRadius ?? const Radius.circular(40),
          scrollbarThickness: scrollbarThickness,
          scrollbarAlwaysShow: scrollbarAlwaysShow,
          offset: offset,
          dropdownOverButton: false,
        ),
      ),
    );
  }
}
