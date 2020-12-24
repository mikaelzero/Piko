import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv/model/user_preview.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/provider/view_state_widget.dart';
import 'package:pixiv/ui/user/user_home_page.dart';
import 'package:pixiv/ui/user/user_list_item_page.dart';
import 'package:pixiv/utils/refresh_util.dart';
import 'package:pixiv/view_model/search_user_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ResultUserListPage extends StatefulWidget {
  final String word;

  const ResultUserListPage({Key key, @required this.word}) : super(key: key);

  @override
  _ResultUserListState createState() => _ResultUserListState();
}

class _ResultUserListState extends State<ResultUserListPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 170),
      child: Container(
        color: Colors.white,
        child: ProviderWidget<SearchUserModel>(
          model: SearchUserModel(widget.word),
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
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => UserHomePage((model.list[index] as UserPreviews).user.id)));
                          },
                          child: UserItemContainer(userPreviews: model.list[index]),
                        );
                      }, childCount: model.list.length),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
