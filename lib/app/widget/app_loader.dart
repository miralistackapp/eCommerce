import 'package:flutter/material.dart';
import 'package:learning/constant/color_constant.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppLoader extends StatelessWidget {
  final Color loaderColor;
  final double loaderSize;

  const AppLoader(
      {Key? key,
      this.loaderColor = ColorConstant.appRed,
      this.loaderSize = 40})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      color: ColorConstant.appWhite.withOpacity(0.6),
      child: LoadingAnimationWidget.discreteCircle(
        color: loaderColor,
        size: loaderSize,
      ),
    );
  }
}
class PlumJustLoader extends StatelessWidget {
  final Color loaderColor;
  final double loaderSize;

  const PlumJustLoader(
      {Key? key,
      this.loaderColor = ColorConstant.pinkIndicator,
      this.loaderSize = 40})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.discreteCircle(
        color: loaderColor,
        size: loaderSize,
      ),
    );
  }
}
