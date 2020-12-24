import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/model/illust.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/provider/view_state_widget.dart';
import 'package:pixiv/ui/detail/illust_float_page.dart';
import 'package:pixiv/ui/detail/post_list_page.dart';
import 'package:pixiv/ui/rank/rank_like_widget.dart';
import 'package:pixiv/ui/search/search_result_page.dart';
import 'package:pixiv/utils/offset.dart';
import 'package:pixiv/view_model/illust_about_model.dart';
import 'package:pixiv/view_model/illust_model.dart';
import 'package:pixiv/widget/base_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:pixiv/widget/fade_route.dart';
import 'package:pixiv/widget/photo_view.dart';
import 'package:pixiv/widget/selectable_html.dart';

class IllustPage extends StatefulWidget {
  final int id;
  final String heroString;
  final Illusts illusts;

  const IllustPage({Key key, this.id, this.illusts, this.heroString}) : super(key: key);

  @override
  _IllustPageState createState() => _IllustPageState();
}

class _IllustPageState extends State<IllustPage> with SingleTickerProviderStateMixin {
  ScrollController _controller = new ScrollController();
  GlobalKey anchorKey = GlobalKey();
  GlobalKey<IllustFloatPageState> floatStateKey = GlobalKey();

  var showToolButton = true;
  var size = 55.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      RenderObject renderBox = anchorKey.currentContext.findRenderObject();

      var offset = OffsetUtil.globalToLocal(renderBox, Offset.zero);
      if (offset.dy < 0 && !showToolButton) {
        showToolButton = true;
        setState(() {
          floatStateKey.currentState.animationController.reverse();
        });
      } else if (offset.dy >= 0 && showToolButton) {
        showToolButton = false;
        setState(() {
          floatStateKey.currentState.animationController.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: ProviderWidget<IllustModel>(
        model: IllustModel(),
        onModelReady: (model) {
          model.loadDetail(widget.id, widget.illusts);
        },
        builder: (context, model, child) {
          if (model.isBusy) {
            return ViewStateBusyWidget();
          } else if (model.isError && model.illusts != null) {
            return ViewStateErrorWidget(error: model.viewStateError, onPressed: () => {model.loadDetail(widget.id, widget.illusts)});
          } else if (model.isEmpty) {
            return ViewStateEmptyWidget(onPressed: () => {model.loadDetail(widget.id, widget.illusts)});
          }
          return Container(
            child: Stack(
              children: [
                CustomScrollView(
                  controller: _controller,
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              FadeRoute(
                                page: PhotoViewGalleryScreenPage(
                                  images: model.illusts.metaPages.isEmpty ? [model.illusts.imageUrls.large] : _getImageList(model),
                                  index: index,
                                ),
                              ),
                            );
                          },
                          child: _buildSingleIllustsItem(
                              model.illusts.metaPages.isEmpty ? model.illusts.imageUrls.large : model.illusts.metaPages[index].imageUrls.large),
                        );
                      }, childCount: model.illusts.metaPages.isEmpty ? 1 : model.illusts.metaPages.length),
                    ),
                    SliverToBoxAdapter(
                      child: _buildInformation(model.illusts),
                    ),
                    _buildAboutPost(model.illusts)
                  ],
                ),
                Positioned(
                  left: 16,
                  top: 36,
                  child: GestureDetector(
                    onTap: () => {Navigator.of(context).pop()},
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 1.0,
                          top: 2.0,
                          child: Icon(Icons.arrow_back, color: Colors.grey),
                        ),
                        Icon(Icons.arrow_back, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                IllustFloatPage(key: floatStateKey, illusts: model.illusts),
              ],
            ),
          );
        },
      ),
    );
  }

  List _getImageList(IllustModel model) {
    var imageList = List();
    model.illusts.metaPages.forEach((element) {
      imageList.add(element.imageUrls.original);
    });
    return imageList;
  }

  Widget _buildSingleIllustsItem(String url) {
    return PixivImage(
      url,
      fit: BoxFit.fitWidth,
    );
  }

  Widget _buildInformation(Illusts illusts) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          _buildUserContainer(illusts),
          SizedBox(height: 16),
          //time
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  DateFormat('yyyy-MM-dd kk:mm').format(DateTime.parse(illusts.createDate)),
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(width: 16),
                Text(
                  illusts.totalView > 10000 ? (illusts.totalView ~/ 1000).toString() + "K" : illusts.totalView.toString(),
                  style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                Text(
                  S.of(context).post_view_count,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(width: 16),
                Text(
                  illusts.totalBookmarks.toString(),
                  style: TextStyle(fontSize: 14, color: Theme.of(context).accentColor),
                ),
                SizedBox(width: 4),
                Text(
                  S.of(context).post_like_count,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          _buildTags(illusts),
          SizedBox(height: 16),
          _buildContent(illusts),
          SizedBox(height: 16),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(
                S.of(context).about_post,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTags(Illusts illusts) {
    return Visibility(
      visible: illusts.illustTags.isNotEmpty,
      child: Container(
        alignment: Alignment.centerLeft,
        child: Tags(
          runSpacing: 2,
          alignment: WrapAlignment.start,
          itemCount: illusts.illustTags.isEmpty ? 0 : illusts.illustTags.length,
          itemBuilder: (int index) {
            return GestureDetector(
              onTap: () => {
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) {
                  return SearchResultPage(0, searchString: illusts.illustTags[index].name);
                }))
              },
              child: RichText(
                text: TextSpan(
                  text: "#" + illusts.illustTags[index].name,
                  style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16),
                  children: [
                    TextSpan(
                      text: illusts.illustTags[index].translatedName,
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(Illusts illusts) {
    return Column(
      children: [SelectableHtml(data: illusts.caption)],
    );
  }

  Widget _buildUserContainer(Illusts illusts) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "@" + illusts.user.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              illusts.title,
              softWrap: true,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAboutPost(Illusts illusts) {
    return ProviderWidget<IllustAboutModel>(
        key: anchorKey,
        model: IllustAboutModel(),
        onModelReady: (model) {
          model.loadAboutList(illusts.id);
        },
        builder: (context, model, child) {
          if (model.isBusy) {
            return SliverToBoxAdapter(
              child: ViewStateBusyWidget(),
            );
          } else if (model.isEmpty) {
            return SliverToBoxAdapter(
              child: ViewStateEmptyWidget(onPressed: () => {model.loadAboutList(illusts.id)}),
            );
          }
          return SliverPadding(
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
                        illustsList: model.illusts.cast(),
                        initPosition: index,
                      );
                    }))
                  },
                  child: PostItemContainer(illusts: model.illusts[index]),
                );
              }, childCount: model.illusts.length),
            ),
          );
        });
  }
}
