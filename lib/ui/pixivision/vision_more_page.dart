import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/model/spotlight_response.dart';
import 'package:pixiv/model/theme_model.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/provider/view_state_widget.dart';
import 'package:pixiv/ui/detail/post_list_page.dart';
import 'package:pixiv/ui/pixivision/vision_detail_page.dart';
import 'package:pixiv/ui/rank/rank_like_widget.dart';
import 'package:pixiv/utils/assets_util.dart';
import 'package:pixiv/utils/refresh_util.dart';
import 'package:pixiv/view_model/user_collections_model.dart';
import 'package:pixiv/view_model/vision_more_model.dart';
import 'package:pixiv/widget/base_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VisionMorePage extends StatefulWidget {
  const VisionMorePage({Key key}) : super(key: key);

  @override
  _VisionMorePageState createState() => _VisionMorePageState();
}

class _VisionMorePageState extends State<VisionMorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeModel().userDarkMode ? ThemeModel.darkColor : Colors.white70,
          title: Text("Pixivision", style: TextStyle(color: ThemeModel().userDarkMode ? Colors.white70 : ThemeModel.darkColor)),
          iconTheme: IconThemeData(color: ThemeModel().userDarkMode ? Colors.white70 : ThemeModel.darkColor),
        ),
        body: ProviderWidget<VisionMoreModel>(
          model: VisionMoreModel(),
          onModelReady: (model) => model.initData(),
          builder: (context, model, child) {
            if (model.isBusy) {
              return ViewStateBusyWidget();
            } else if (model.isError && model.list.isEmpty) {
              return ViewStateErrorWidget(error: model.viewStateError, onPressed: model.initData);
            } else if (model.isEmpty) {
              return ViewStateEmptyWidget(onPressed: model.initData);
            }
            return SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: PixivRefreshHeader(),
              footer: PixivRefreshFooter(),
              controller: model.refreshController,
              onRefresh: model.refresh,
              onLoading: model.loadMore,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => {
                              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) {
                                return VisionDetailPage(articleUrl: model.list[index].articleUrl, spotlight: model.list[index]);
                              }))
                            },
                            child: _getItem(model.list[index]),
                          );
                        }, childCount: model.list.length),
                      ))
                ],
              ),
            );
          },
        ));
  }

  Widget _getItem(SpotlightArticle spotlightArticle) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Stack(
          children: [
            Center(
              child: PixivImage(
                spotlightArticle.thumbnail,
                width: MediaQuery.of(context).size.width,
                height: 260,
                placeholder: Lottie.asset(circle_image_loading, fit: BoxFit.cover),
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                    ),
                  );
                },
              ),
            ),
            Opacity(
              opacity: 0.3,
              child: Container(
                height: 260,
                decoration: BoxDecoration(color: Colors.black),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Text(
                spotlightArticle.pureTitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
