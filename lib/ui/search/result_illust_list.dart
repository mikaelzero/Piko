import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv/model/search_filter.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/provider/view_state_widget.dart';
import 'package:pixiv/ui/detail/post_list_page.dart';
import 'package:pixiv/ui/rank/rank_like_widget.dart';
import 'package:pixiv/utils/refresh_util.dart';
import 'package:pixiv/view_model/search_illust_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ResultIllustListPage extends StatefulWidget {
  final String word;

  const ResultIllustListPage({Key key, @required this.word}) : super(key: key);

  @override
  ResultIllustListState createState() => ResultIllustListState();
}

class ResultIllustListState extends State<ResultIllustListPage> {
  SearchIllustModel searchIllustModel;
  SearchFilterBean filterBean;

  @override
  void initState() {
    super.initState();
    searchIllustModel = SearchIllustModel(widget.word);
  }

  void setFilter(SearchFilterBean filterBean) {
    if (this.filterBean == null && filterBean == null) {
      return;
    }
    this.filterBean = filterBean;
    if (this.filterBean != null) {
      searchIllustModel.setFilter(
          sort: this.filterBean.sort,
          search_target: this.filterBean.search_target,
          start_date: this.filterBean.start_date,
          end_date: this.filterBean.end_date,
          bookmark_num: filterBean.bookmark_num == 0 ? null : this.filterBean.bookmark_num);
    } else {
      searchIllustModel.setFilter(sort: null, search_target: null, start_date: null, end_date: null, bookmark_num: null);
    }
    setState(() {
      searchIllustModel.setBusy();
      searchIllustModel.refresh(init: true);
    });
  }

  @override
  void dispose() {
    if (searchIllustModel != null) {
      searchIllustModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 170),
      child: Container(
        child: ProviderWidget<SearchIllustModel>(
          model: searchIllustModel,
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
          },
        ),
      ),
    );
  }
}
