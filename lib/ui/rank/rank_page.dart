import 'package:flutter/material.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/model/theme_model.dart';
import 'package:pixiv/ui/rank/rank_mode_page.dart';

class RankPage extends StatefulWidget {
  RankPage({
    Key key,
  }) : super(key: key);

  @override
  _RankPageState createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> with AutomaticKeepAliveClientMixin {
  final modeList = ["day", "day_male", "day_female", "week_original", "week", "month"];
  var boolList = Map<int, bool>();
  DateTime nowDate;

  @override
  void initState() {
    nowDate = DateTime.now();
    int i = 0;
    modeList.forEach((element) {
      boolList[i] = false;
      i++;
    });
    super.initState();
  }

  String dateTime;

  String toRequestDate(DateTime dateTime) {
    if (dateTime == null) {
      return null;
    }
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }

  DateTime nowDateTime = DateTime.now();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final nameList = [
      S.of(context).rank_day,
      S.of(context).rank_male_hot,
      S.of(context).rank_women_hot,
      S.of(context).rank_original,
      S.of(context).rank_week,
      S.of(context).rank_month,
    ];
    super.build(context);
    return DefaultTabController(
      length: modeList.length,
      child: Column(
        children: <Widget>[
          _buildAppbar(nameList),
          Expanded(
            child: TabBarView(children: [
              for (var element in modeList)
                RankModePage(
                  date: dateTime,
                  mode: element,
                ),
            ]),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildAppbar(nameList) {
    var darkColor = ThemeModel.darkColor;
    if (ThemeModel().userDarkMode) {
      return AppBar(
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: darkColor,
        title: TabBar(
          onTap: (i) {
            setState(() {
              this.index = i;
            });
          },
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.white70,
          isScrollable: true,
          labelColor: Colors.white70,
          unselectedLabelColor: Colors.grey,
          tabs: <Widget>[
            for (var i in nameList)
              Tab(
                text: i,
              ),
          ],
        ),
      );
    } else {
      return AppBar(
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.white,
        title: TabBar(
          onTap: (i) {
            setState(() {
              this.index = i;
            });
          },
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.black26,
          isScrollable: true,
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.grey,
          tabs: <Widget>[
            for (var i in nameList)
              Tab(
                text: i,
              ),
          ],
        ),
      );
    }
  }
}
