import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning/app/widget/app_loader.dart';

class AppImageAsset extends StatelessWidget {
  final String? image;
  final double? height;
  final double? webHeight;
  final double? width;
  final double? webWidth;
  final Color? color;
  final BoxFit? fit;
  final BoxFit? webFit;

  const AppImageAsset({
    Key? key,
    @required this.image,
    this.webFit,
    this.fit,
    this.height,
    this.webHeight,
    this.width,
    this.webWidth,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image!.contains('public/product')
        ? CachedNetworkImage(
            imageUrl: 'https://assets.plumgoodness.net/$image',
            height: webHeight,
            width: webWidth,
            fit: webFit ?? BoxFit.cover,
            placeholder: (context, url) => const AppLoader(),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: Colors.red),
          )
        : image!.split('.').last != 'svg'
            ? Image.asset(
                image!,
                fit: fit,
                height: height,
                width: width,
                color: color,
              )
            : SvgPicture.asset(
                image!,
                height: height,
                width: width,
                color: color,
              );
  }
}
