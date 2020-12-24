import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/provider/view_state_widget.dart';
import 'package:pixiv/ui/detail/post_list_page.dart';
import 'package:pixiv/ui/rank/rank_like_widget.dart';
import 'package:pixiv/utils/refresh_util.dart';
import 'package:pixiv/view_model/activities_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ActivitiesPage extends StatefulWidget {
  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> with AutomaticKeepAliveClientMixin {


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: ProviderWidget<ActivitiesModel>(
          model: ActivitiesModel(),
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

  @override
  bool get wantKeepAlive => true;
}
