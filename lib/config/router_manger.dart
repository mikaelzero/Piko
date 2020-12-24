import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixiv/ui/main/splash_page.dart';
import 'package:pixiv/ui/login/login_page.dart';
import 'package:pixiv/ui/main/main_tab.dart';

class RouteName {
  static const String splash = 'splash';
  static const String tab = '/';
  static const String homeSecondFloor = 'homeSecondFloor';
  static const String login = 'login';
  static const String register = 'register';
  static const String articleDetail = 'articleDetail';
  static const String structureList = 'structureList';
  static const String favouriteList = 'favouriteList';
  static const String setting = 'setting';
  static const String coinRecordList = 'coinRecordList';
  static const String coinRankingList = 'coinRankingList';
}

class RouterManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return CupertinoPageRoute(fullscreenDialog: true, builder: (_) => SplashPage());
      case RouteName.login:
        return CupertinoPageRoute(fullscreenDialog: true, builder: (_) => LoginPage());
      case RouteName.tab:
        return CupertinoPageRoute(fullscreenDialog: true, builder: (_) => AndroidHelloPage());
      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}

/// Pop路由
class PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
