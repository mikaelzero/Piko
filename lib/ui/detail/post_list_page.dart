import 'package:flutter/widgets.dart';
import 'package:pixiv/model/illust.dart';
import 'package:pixiv/ui/detail/illust_page.dart';

class PictureListPage extends StatefulWidget {
  final List<Illusts> illustsList;
  final int initPosition;

  PictureListPage({this.illustsList, this.initPosition = 0});

  @override
  _PictureListPageState createState() => _PictureListPageState();
}

class _PictureListPageState extends State<PictureListPage> {
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.initPosition);
    super.initState();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.illustsList.length,
      controller: _pageController,
      itemBuilder: (BuildContext context, int index) {
        return IllustPage(
          id: widget.illustsList[index].id,
          illusts: widget.illustsList[index],
          heroString: widget.hashCode.toString(),
        );
      },
    );
  }
}
