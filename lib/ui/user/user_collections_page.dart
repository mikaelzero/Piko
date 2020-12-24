import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/provider/view_state_widget.dart';
import 'package:pixiv/ui/detail/post_list_page.dart';
import 'package:pixiv/ui/rank/rank_like_widget.dart';
import 'package:pixiv/utils/refresh_util.dart';
import 'package:pixiv/view_model/user_collections_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserCollectionsPage extends StatefulWidget {
  final String tabName;
  final int userId;

  const UserCollectionsPage(this.tabName, this.userId, {Key key}) : super(key: key);

  @override
  _UserCollectionsPageState createState() => _UserCollectionsPageState();
}

class _UserCollectionsPageState extends State<UserCollectionsPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Builder(
      builder: (context) => ProviderWidget<UserCollectionsViewModel>(
          model: UserCollectionsViewModel(widget.userId),
          onModelReady: (model) => model.initData(),
          builder: (context, model, child) {
            if (model.isBusy) {
              return ViewStateBusyWidget();
            } else if (model.isEmpty) {
              return ViewStateEmptyWidget(onPressed: model.loadData);
            }
            return SmartRefresher(
              enablePullDown: false,
              enablePullUp: true,
              header: PixivRefreshHeader(),
              controller: model.refreshController,
              onRefresh: model.refresh,
              onLoading: model.loadMore,
              child: CustomScrollView(
                key: PageStorageKey<String>(widget.tabName),
                slivers: <Widget>[
                  SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                  SliverPadding(
                      padding: EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 16),
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
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
