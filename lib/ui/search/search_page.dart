import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/model/theme_model.dart';
import 'package:pixiv/model/trend_tags.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/provider/view_state_widget.dart';
import 'package:pixiv/ui/search/search_result_page.dart';
import 'package:pixiv/utils/assets_util.dart';
import 'package:pixiv/view_model/tags_model.dart';
import 'package:pixiv/widget/base_image.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin {
  int currentChoose = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: ProviderWidget<TagsModel>(
      model: TagsModel(),
      onModelReady: (model) => model.loadData(),
      builder: (context, model, child) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
                child: Text(
                  S.of(context).search_title,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: "MPLUS1p"),
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) {
                  return SearchResultPage(currentChoose);
                }));
              },
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular((16)),
                    boxShadow: [
                      BoxShadow(
                          color: ThemeModel().userDarkMode ? Colors.black54 : Colors.grey[200],
                          offset: Offset(5.0, 5.0),
                          blurRadius: 10.0,
                          spreadRadius: 1.0),
                      BoxShadow(color: ThemeModel().userDarkMode ? ThemeModel.darkColor : Colors.white70)
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: ThemeModel().userDarkMode ? Colors.white70 : ThemeModel.darkColor),
                        SizedBox(width: 16),
                        Text(
                          S.of(context).search,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentChoose = 0;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: ThemeModel().userDarkMode ? Colors.black54 : Colors.grey[200],
                                offset: Offset(5.0, 5.0),
                                blurRadius: 10.0,
                                spreadRadius: 1.0),
                            BoxShadow(
                                color: currentChoose == 0
                                    ? (ThemeModel().userDarkMode ? ThemeModel.darkColor : Color(0xFFC2DBFF))
                                    : (ThemeModel().userDarkMode ? ThemeModel.darkColor : Colors.white))
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
                          child: Text(
                            S.of(context).search_result_tab1,
                            style: TextStyle(
                                color: currentChoose == 0 ? Colors.blueAccent : (ThemeModel().userDarkMode ? Colors.white70 : Colors.black54)),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentChoose = 1;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: ThemeModel().userDarkMode ? Colors.black54 : Colors.grey[200],
                                offset: Offset(5.0, 5.0),
                                blurRadius: 10.0,
                                spreadRadius: 1.0),
                            BoxShadow(
                                color: currentChoose == 1
                                    ? (ThemeModel().userDarkMode ? ThemeModel.darkColor : Color(0xFFC2DBFF))
                                    : (ThemeModel().userDarkMode ? ThemeModel.darkColor : Colors.white))
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
                          child: Text(
                            S.of(context).search_result_tab2,
                            style: TextStyle(
                                color: currentChoose == 1 ? Colors.blueAccent : (ThemeModel().userDarkMode ? Colors.white70 : Colors.black54)),
                          ),
                        ),
                      ),
                    ),
                    Container(),
                  ],
                ),
              ),
            ),
            _buildList(model),
          ],
        );
      },
    ));
  }

  Widget _buildList(TagsModel model) {
    if (model.isBusy) {
      return SliverToBoxAdapter(child: ViewStateBusyWidget());
    } else if (model.isError) {
      return SliverToBoxAdapter(child: ViewStateErrorWidget(error: model.viewStateError, onPressed: model.loadData));
    } else if (model.isEmpty) {
      return SliverToBoxAdapter(child: ViewStateEmptyWidget(onPressed: model.loadData));
    }
    return SliverPadding(
        padding: EdgeInsets.all(16),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            return _buildTagItem(model.trendTags[index]);
          }, childCount: model.trendTags.length),
        ));
  }

  Widget _buildTagItem(Trend_tags trend_tags) {
    return GestureDetector(
        onTap: () => {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) {
                return SearchResultPage(currentChoose, searchString: trend_tags.tag);
              }))
            },
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Stack(
            children: [
              Center(
                child: PixivImage(
                  trend_tags.illust.imageUrls.medium,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  placeholder: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Lottie.asset(image_loading),
                  ),
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
                opacity: 0.4,
                child: Container(
                  decoration: BoxDecoration(color: Colors.black),
                ),
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        trend_tags.tag,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                alignment: Alignment.bottomCenter,
              ),
            ],
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
