import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv/model/amwork.dart';
import 'package:pixiv/model/spotlight_response.dart';
import 'package:pixiv/model/theme_model.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/provider/view_state_widget.dart';
import 'package:pixiv/ui/detail/illust_page.dart';
import 'package:pixiv/view_model/vision_detail_model.dart';
import 'package:pixiv/widget/base_image.dart';

class VisionDetailPage extends StatefulWidget {
  final String articleUrl;
  final SpotlightArticle spotlight;

  const VisionDetailPage({Key key, @required this.articleUrl, this.spotlight}) : super(key: key);

  @override
  _VisionDetailState createState() => _VisionDetailState();
}

class _VisionDetailState extends State<VisionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeModel().userDarkMode ? ThemeModel.darkColor : Colors.white70,
        title: Text(widget.spotlight.pureTitle, style: TextStyle(color: ThemeModel().userDarkMode ? Colors.white70 : ThemeModel.darkColor)),
        iconTheme: IconThemeData(color: ThemeModel().userDarkMode ? Colors.white70 : ThemeModel.darkColor),
      ),
      body: SafeArea(
          child: ProviderWidget<VisionDetailModel>(
        model: VisionDetailModel(),
        onModelReady: (model) => model.loadData(widget.articleUrl),
        builder: (context, model, child) {
          if (model.isBusy) {
            return ViewStateBusyWidget();
          } else if (model.isEmpty) {
            return ViewStateEmptyWidget(onPressed: () {
              model.loadData(widget.articleUrl);
            });
          }
          return CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      widget.spotlight.pureTitle,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(model.description),
                    )
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(top: 16, left: 20, right: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => {},
                      child: _getDetailItem(model.amWorks[index]),
                    );
                  }, childCount: model.amWorks.length),
                ),
              )
            ],
          );
        },
      )),
    );
  }

  Widget _getDetailItem(AmWork item) {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) {
          return IllustPage(
            id: int.parse(Uri.parse(item.arworkLink).pathSegments[Uri.parse(item.arworkLink).pathSegments.length - 1]),
          );
        }))
      },
      child: Padding(
        padding: EdgeInsets.only(top: 16),
        child: Container(
          child: PixivImage(
            item.showImage,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
