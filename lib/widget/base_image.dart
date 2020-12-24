import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pixiv/utils/assets_util.dart';
import 'package:pixiv/utils/exts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PixivImage extends StatelessWidget {
  final String url;
  final ImageWidgetBuilder imageBuilder;
  final Widget placeholder;
  final bool fade;
  final BoxFit fit;
  final double height;
  final double width;

  PixivImage(this.url, {this.imageBuilder, this.placeholder, this.fade = true, this.fit, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: url.toTrueUrl(),
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        httpHeaders: {"referer": "https://app-api.pixiv.net/", "User-Agent": "PixivIOSApp/5.8.0", "Host": ImageHost},
        placeholder: (context, url) => Center(
              child: placeholder ?? Lottie.asset(image_loading,fit: BoxFit.cover),
            ),
        imageBuilder: imageBuilder,
        errorWidget: (context, url, error) => new Icon(Icons.error));
  }
}

class PixivCircleImage extends StatelessWidget {
  final String url;
  final double height;
  final double width;

  PixivCircleImage(this.url, {this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url.toTrueUrl(),
      height: height,
      width: width,
      fit: BoxFit.cover,
      httpHeaders: {"referer": "https://app-api.pixiv.net/", "User-Agent": "PixivIOSApp/5.8.0", "Host": ImageHost},
      placeholder: (context, url) => Center(
        child: Lottie.asset(circle_image_loading),
      ),
      imageBuilder: (context, imageProvider) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        );
      },
      errorWidget: (context, url, error) => Container(child: SvgPicture.asset(user_icon, color: Colors.grey[400])),
    );
  }
}
