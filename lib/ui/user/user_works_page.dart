import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/provider/view_state_model.dart';
import 'package:pixiv/provider/view_state_widget.dart';
import 'package:pixiv/ui/detail/post_list_page.dart';
import 'package:pixiv/ui/rank/rank_like_widget.dart';
import 'package:pixiv/view_model/user_works_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserWorksPage extends StatefulWidget {
  final String tabName;
  final int userId;

  const UserWorksPage(this.tabName, this.userId, {Key key}) : super(key: key);

  @override
  _UserWorksPageState createState() => _UserWorksPageState();
}

class _UserWorksPageState extends State<UserWorksPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Builder(
      builder: (context) {
        return ProviderWidget<UserWorksViewModel>(
            model: UserWorksViewModel(widget.userId),
            onModelReady: (model) => model.initData(),
            builder: (context, model, child) {
              if (model.isBusy) {
                return ViewStateBusyWidget();
              } else if (model.isEmpty) {
                return ViewStateEmptyWidget(onPressed: model.loadData);
              } else if (model.isError) {
                return ViewStateErrorWidget(error: model.viewStateError, onPressed: model.loadData);
              }
              return SmartRefresher(
                enablePullDown: false,
                enablePullUp: true,
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
                              crossAxisCount: 2, childAspectRatio: 1.0, crossAxisSpacing: 16.0, mainAxisSpacing: 16.0),
                          delegate: SliverChildBuilderDelegate((_, index) {
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
            });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
