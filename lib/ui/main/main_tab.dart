import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/main.dart';
import 'package:pixiv/ui/login/login_page.dart';
import 'package:pixiv/ui/home/home_page.dart';
import 'package:pixiv/ui/main/activities_page.dart';
import 'package:pixiv/ui/search/search_page.dart';
import 'package:pixiv/ui/mine/mine_page.dart';
import 'package:pixiv/ui/rank/rank_page.dart';
import 'package:pixiv/widget/restart_widget.dart';

class AndroidHelloPage extends StatefulWidget {
  const AndroidHelloPage({Key key}) : super(key: key);

  @override
  _AndroidHelloPageState createState() => _AndroidHelloPageState();
}

class _AndroidHelloPageState extends State<AndroidHelloPage> {
  List<Widget> _pageList;
  DateTime _preTime;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_preTime == null || DateTime.now().difference(_preTime) > Duration(seconds: 2)) {
          _preTime = DateTime.now();
          BotToast.showText(text: S.of(context).return_again_to_exit);
          return false;
        }
        return true;
      },
      child: _getChild(context),
    );
  }

  Widget _getChild(BuildContext context) {
    if (accountStore.now != null) {
      return _buildScaffold(context);
    }
    return LoginPage();
  }

  Widget _buildScaffold(BuildContext context) {
    double iconSize = 20;
    return Scaffold(
      body: PageView.builder(
        itemBuilder: (context, index) {
          return _pageList[index];
        },
        onPageChanged: (index) {
          setState(() {
            this.index = index;
          });
        },
        controller: _pageController,
        itemCount: 5,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          currentIndex: index,
          onTap: (index) {
            if (this.index == index) {}
            setState(() {
              this.index = index;
            });
            _pageController.jumpToPage(index);
          },
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/ic_main_home.svg",
                  color: this.index == 0 ? Theme.of(context).accentColor : Colors.grey,
                  width: iconSize,
                  height: iconSize,
                ),
                label: S.of(context).home),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/ic_main_rank.svg",
                  color: this.index == 1 ? Theme.of(context).accentColor : Colors.grey,
                  width: iconSize,
                  height: iconSize,
                ),
                label: S.of(context).rank),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/ic_main_search.svg",
                  color: this.index == 2 ? Theme.of(context).accentColor : Colors.grey,
                  width: iconSize,
                  height: iconSize,
                ),
                label: S.of(context).search),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/ic_main_activities.svg",
                  color: this.index == 3 ? Theme.of(context).accentColor : Colors.grey,
                  width: iconSize,
                  height: iconSize,
                ),
                label: S.of(context).activities),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/ic_main_mine.svg",
                  color: this.index == 4 ? Theme.of(context).accentColor : Colors.grey,
                  width: iconSize,
                  height: iconSize,
                ),
                label: S.of(context).mine),
          ]),
    );
  }

  PageController _pageController;

  bool hasNewVersion = false;

  @override
  void initState() {
    _pageList = [HomePage(), RankPage(), SearchPage(), ActivitiesPage(), MinePage()];
    _pageController = PageController(initialPage: index);
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    var status = await Permission.storage.status;
    if (status.isUndetermined || status.isDenied || status.isPermanentlyDenied) {
      PermissionStatus statuses = await Permission.storage.request();
      if (statuses.isDenied) {
        openAppSettings();
        pop();
      }
    }
  }

  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}
