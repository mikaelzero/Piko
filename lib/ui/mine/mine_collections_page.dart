import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/model/theme_model.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/provider/view_state_widget.dart';
import 'package:pixiv/ui/detail/post_list_page.dart';
import 'package:pixiv/ui/rank/rank_like_widget.dart';
import 'package:pixiv/utils/refresh_util.dart';
import 'package:pixiv/view_model/collections_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MineCollectionsPage extends StatefulWidget {
  final int userId;

  const MineCollectionsPage({Key key, this.userId}) : super(key: key);

  @override
  _MineCollectionsPageState createState() => _MineCollectionsPageState();
}

class _MineCollectionsPageState extends State<MineCollectionsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeModel().userDarkMode ? ThemeModel.darkColor : Colors.white70,
          title: Text(
            S.of(context).user_page_tab2,
            style: TextStyle(color: ThemeModel().userDarkMode ? Colors.white70 : ThemeModel.darkColor),
          ),
          iconTheme: IconThemeData(color: ThemeModel().userDarkMode ? Colors.white70 : ThemeModel.darkColor),
        ),
        body: ProviderWidget<CollectionsModel>(
          model: CollectionsModel(widget.userId),
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
                      ))
                ],
              ),
            );
          },
        ));
  }
}
