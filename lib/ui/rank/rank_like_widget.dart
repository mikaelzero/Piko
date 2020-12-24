import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:pixiv/model/illust.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/utils/assets_util.dart';
import 'package:pixiv/view_model/illust_model.dart';
import 'package:pixiv/widget/base_image.dart';

class StarIcon extends StatefulWidget {
  final Illusts illusts;
  final IllustModel illustModel;

  const StarIcon({Key key, @required this.illusts, @required this.illustModel}) : super(key: key);

  @override
  _StarIconState createState() => _StarIconState();
}

class _StarIconState extends State<StarIcon> {
  bool isBookmark = false;

  @override
  Widget build(BuildContext context) {
    isBookmark = widget.illusts?.isBookmarked ?? false;
    return Padding(
        padding: EdgeInsets.only(left: 3),
        child: LikeButton(
          size: 24,
          isLiked: isBookmark,
          likeBuilder: (context) {
            return SvgPicture.asset(like_icon, color: isBookmark ? Colors.red : Colors.grey[400]);
          },
          onTap: onLikeButtonTapped,
        ));
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    final bool result = await widget.illustModel.star(widget.illusts);
    isBookmark = result;
    return result;
  }
}

class PostItemContainer extends StatefulWidget {
  final Illusts illusts;

  const PostItemContainer({Key key, @required this.illusts}) : super(key: key);

  @override
  _PostItemContainerState createState() => _PostItemContainerState();
}

class _PostItemContainerState extends State<PostItemContainer> {
  bool isBookmark = false;

  @override
  Widget build(BuildContext context) {
    isBookmark = widget.illusts?.isBookmarked ?? false;
    return Stack(
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: PixivImage(
              widget.illusts.imageUrls.medium,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
        Positioned(
          right: 8,
          bottom: 8,
          child: ProviderWidget<IllustModel>(
            model: IllustModel(),
            builder: (context, model, child) {
              return StarIcon(illusts: widget.illusts, illustModel: model);
            },
          ),
        ),
        Positioned(right: 0, top: 0, child: _getImageSizeWidget(widget.illusts))
      ],
    );
  }

  Widget _getImageSizeWidget(Illusts item) {
    return Visibility(
        visible: item.type != "illust" || item.metaPages.isNotEmpty,
        child: Container(
          decoration:
              BoxDecoration(color: Color(0x4D000000), borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomLeft: Radius.circular(8))),
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Row(
              children: [
                Icon(
                  Icons.filter,
                  color: Colors.white,
                  size: 16,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: _getSizeTextWidget(item),
                )
              ],
            ),
          ),
        ));
  }

  Widget _getSizeTextWidget(Illusts item) {
    if (item.type != "illust") {
      return Text(
        item.type,
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    }
    if (item.metaPages.isNotEmpty) {
      return Text(
        item.metaPages.length.toString(),
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    }
    return Text('');
  }
}
