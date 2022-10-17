import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:learning/app/widget/app_text.dart';
import 'package:learning/constant/color_constant.dart';

extension AppToast on String {
  showSnackbar(BuildContext context, {
    bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
        isError ? ColorConstant.appRed.withOpacity(0.6) : ColorConstant.appBlack.withOpacity(0.7),
        content: AppText(
          this,
          fontSize: 14,
          color: ColorConstant.appWhite,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  showToast({bool isError = false}) {
    BotToast.showCustomNotification(
      duration: const Duration(seconds: 3),
      toastBuilder: (CancelFunc cancelFunc) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Card(
            elevation: 15,
            color: isError ? ColorConstant.appRed : Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              title: Container(
                margin: const EdgeInsets.only(top: 5),
                child: AppText(
                  this,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.appWhite,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
