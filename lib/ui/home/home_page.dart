import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/model/spotlight_response.dart';
import 'package:pixiv/model/user_preview.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/provider/view_state_widget.dart';
import 'package:pixiv/ui/detail/post_list_page.dart';
import 'package:pixiv/ui/pixivision/vision_detail_page.dart';
import 'package:pixiv/ui/pixivision/vision_more_page.dart';
import 'package:pixiv/ui/rank/rank_like_widget.dart';
import 'package:pixiv/ui/user/user_home_page.dart';
import 'package:pixiv/ui/web/web_page.dart';
import 'package:pixiv/utils/assets_util.dart';
import 'package:pixiv/utils/refresh_util.dart';
import 'package:pixiv/view_model/home_model.dart';
import 'package:pixiv/widget/base_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: ProviderWidget<HomeModel>(
            model: HomeModel(),
            onModelReady: (model) {
              model.initData();
            },
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
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 16, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              "assets/images/pixivision-color-logo.svg",
                              height: 25,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) {
                                  return VisionMorePage();
                                }));
                              },
                              child: SvgPicture.asset(
                                "assets/images/ic_more.svg",
                                height: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 260,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (c, i) => _getSpotlightContainer(model.spotlightArticles[i], i == model.spotlightArticles.length - 1),
                          itemCount: model.spotlightArticles.length,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, top: 16),
                            child: Text(
                              S.of(context).home_recommend_user,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (c, i) => _getRecommendUsersContainer(model.userPreviewsList[i], i == model.userPreviewsList.length - 1),
                          itemCount: model.userPreviewsList.length,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, top: 16),
                            child: Text(
                              S.of(context).home_recommend_post,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.only(top: 16, left: 20, right: 20),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                        ),
                        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => {
                              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) {
                                return PictureListPage(
                                  illustsList: model.list.cast(),
                                  initPosition: index,
                                );
                              }))
                            },
                            child: PostItemContainer(illusts: model.list[index]),
                          );
                        }, childCount: model.list.length),
                      ),
                    )
                  ],
                ),
              );
            }));
  }

  Widget _getSpotlightContainer(SpotlightArticle item, bool isLast) {
    var width = MediaQuery.of(context).size.width * 0.7;
    return GestureDetector(
      onTap: () {
        if (item.category == Category.INSPIRATION) {
          WebPage.openWeb(context, item.articleUrl, title: item.pureTitle);
        } else {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) {
            return VisionDetailPage(articleUrl: item.articleUrl, spotlight: item);
          }));
        }
      },
      child: Padding(
        padding: EdgeInsets.only(top: 16),
        child: Container(
          width: width,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: isLast ? 20 : 0),
            child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: PixivImage(
                      item.thumbnail,
                      width: width,
                      placeholder: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Lottie.asset(circle_image_loading),
                      ),
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                          ),
                        );
                      },
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: Text(
                      item.pureTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18, fontFamily: "DancingScript"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getRecommendUsersContainer(UserPreviews item, bool isLast) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) {
            return UserHomePage(item.user.id);
          }));
        },
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: isLast ? 20 : 0),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  // child: CircleNetImage(60, 60, item.user.profileImageUrls.medium.toTrueUrl())
                  child: PixivCircleImage(
                    item.user.profileImageUrls.medium,
                    width: 60,
                    height: 60,
                  ),
                ),
                Container(
                  width: 60,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Center(
                      child: Text(
                        item.user.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
