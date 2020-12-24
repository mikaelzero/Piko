import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/provider/view_state_widget.dart';
import 'package:pixiv/ui/user/user_collections_page.dart';
import 'package:pixiv/ui/user/user_info_page.dart';
import 'package:pixiv/ui/user/user_works_page.dart';
import 'package:pixiv/utils/assets_util.dart';
import 'package:pixiv/view_model/user_model.dart';
import 'package:pixiv/widget/base_image.dart';
import 'package:pixiv/utils/exts.dart';

class UserHomePage extends StatefulWidget {
  final int userId;

  const UserHomePage(this.userId, {Key key}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

const backgroundColor = Color(0xFF161A23);

class _UserHomePageState extends State<UserHomePage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ProviderWidget<UserViewModel>(
            model: UserViewModel(),
            onModelReady: (model) {
              model.getUserDetail(widget.userId);
            },
            builder: (context, model, child) {
              if (model.isBusy) {
                return ViewStateBusyWidget();
              } else if (model.isEmpty) {
                return ViewStateEmptyWidget(onPressed: () => {model.getUserDetail(widget.userId)});
              }
              var _kTabs = [
                S.of(context).user_page_tab1 + "(" + model.userDetail.profile.total_illusts.toString() + ")",
                S.of(context).user_page_tab2 + "(" + model.userDetail.profile.total_illust_bookmarks_public.toString() + ")",
                S.of(context).user_page_tab3,
              ];
              return DefaultTabController(
                length: _kTabs.length,
                child: NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        sliver: SliverAppBar(
                          elevation: 0,
                          backgroundColor: backgroundColor,
                          iconTheme: IconThemeData(color: Colors.white),
                          pinned: true,
                          expandedHeight: 300.0,
                          bottom: TabBar(
                            tabs: _kTabs
                                .map((tab) => Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(tab, style: TextStyle(color: Colors.white)),
                                    ))
                                .toList(),
                            unselectedLabelColor: Colors.grey,
                          ),
                          title: Text(model.userDetail.user.name, style: TextStyle(color: Colors.white)),
                          forceElevated: innerBoxIsScrolled,
                          flexibleSpace: FlexibleSpaceBar(
                            stretchModes: [StretchMode.zoomBackground],
                            collapseMode: CollapseMode.parallax,
                            background: _buildAppBar(model),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(children: [
                    UserWorksPage(_kTabs[0], widget.userId),
                    UserCollectionsPage(_kTabs[1], widget.userId),
                    UserInfoPage(_kTabs[2], model.userDetail),
                  ]),
                ),
              );
            }));
  }

  Widget _buildAppBar(UserViewModel model) {
    return Stack(
      children: <Widget>[
        ConstrainedBox(
          child: model.userDetail.profile.background_image_url != null
              ? CachedNetworkImage(
                  imageUrl: model.userDetail.profile.background_image_url.toTrueUrl(),
                  fit: BoxFit.cover,
                  httpHeaders: {
                    "referer": "https://app-api.pixiv.net/",
                    "User-Agent": "PixivIOSApp/5.8.0",
                    "Host": Uri.parse(model.userDetail.profile.background_image_url).host
                  },
                  placeholder: (context, url) => Center(child: Lottie.asset(circle_image_loading)),
                  errorWidget: (context, url, error) => new Icon(Icons.error))
              : PixivImage(model.userDetail.user.profile_image_urls.medium, fit: BoxFit.cover),
          constraints: new BoxConstraints.expand(),
        ),
        ConstrainedBox(
          constraints: new BoxConstraints.expand(),
          child: Container(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 85),
          child: Column(
            children: [
              Center(child: PixivCircleImage(model.userDetail.user.profile_image_urls.medium, width: 80, height: 80)),
              SizedBox(height: 8),
              Text(
                model.userDetail.profile.total_follow_users.toString() + " " + S.of(context).follow,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white)),
                child: GestureDetector(
                  onTap: () async {
                    if (model.isFollow) {
                      await model.unFollow(model.userDetail.user.id);
                    } else {
                      await model.follow(model.userDetail.user.id);
                    }
                    setState(() {});
                  },
                  child: Text(
                    model.isFollow ? S.of(context).following : S.of(context).follow,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
