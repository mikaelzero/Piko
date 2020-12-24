import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pixiv/model/illust.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/ui/detail/comment_page.dart';
import 'package:pixiv/ui/rank/rank_like_widget.dart';
import 'package:pixiv/ui/user/user_home_page.dart';
import 'package:pixiv/utils/assets_util.dart';
import 'package:pixiv/view_model/illust_model.dart';
import 'package:pixiv/widget/base_image.dart';
import 'package:share/share.dart';

class IllustFloatPage extends StatefulWidget {
  final Illusts illusts;

  const IllustFloatPage({Key key, @required this.illusts}) : super(key: key);

  @override
  IllustFloatPageState createState() => IllustFloatPageState();
}

class IllustFloatPageState extends State<IllustFloatPage> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    animation = new Tween(begin: 1.0, end: 0.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 78,
      child: Column(
        children: [
          Transform.scale(
            scale: animation.value,
            child: FloatingActionButton(
              heroTag: "floating_image",
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) {
                  return UserHomePage(widget.illusts.user.id);
                }));
              },
              child: PixivCircleImage(widget.illusts.user.profileImageUrls.medium),
              backgroundColor: Colors.white,
              elevation: 4,
            ),
          ),
          SizedBox(height: 20),
          Transform.scale(
            scale: animation.value,
            child: FloatingActionButton(
              heroTag: "floating_star",
              onPressed: null,
              child: Center(
                child: ProviderWidget<IllustModel>(
                  model: IllustModel(),
                  builder: (context, model, child) {
                    return StarIcon(illusts: widget.illusts, illustModel: model);
                  },
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 4,
            ),
          ),
          SizedBox(height: 20),
          Transform.scale(
            scale: animation.value,
            child: FloatingActionButton(
              heroTag: "floating_comment",
              onPressed: _openCommentBottomSheet,
              child: SvgPicture.asset(comment_icon, color: Colors.grey[400], width: 24, height: 24),
              backgroundColor: Colors.white,
              elevation: 4,
            ),
          ),
          SizedBox(height: 20),
          Transform.scale(
            scale: animation.value,
            child: FloatingActionButton(
              heroTag: "floating_share",
              onPressed: () {
                Share.share("https://www.pixiv.net/artworks/${widget.illusts.id}");
              },
              child: SvgPicture.asset(share_icon, color: Colors.grey[400], width: 24, height: 24),
              backgroundColor: Colors.white,
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }

  Future _openCommentBottomSheet() async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        context: context,
        builder: (BuildContext context) {
          return CommentPage(
            id: widget.illusts.id,
          );
        });
  }
}
