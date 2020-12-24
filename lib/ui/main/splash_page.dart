import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pixiv/main.dart';
import 'package:pixiv/ui/main/main_tab.dart';
import 'package:pixiv/utils/assets_util.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  Timer _timer;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 56),
            child: Text(
              "Welcome to Pixiv",
              style: TextStyle(fontSize: 35, fontFamily: "DancingScript"),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 26, right: 26),
              child: Lottie.asset(splash_loading),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Text(
              "develop by mikaelzero",
              style: TextStyle(fontSize: 16, fontFamily: "DancingScript"),
            ),
          ),
        ],
      ),
    );
  }

  void fetchData() async {
    await accountStore.fetch();
    startCountdownTimer();
  }

  void startCountdownTimer() {
    const oneSec = const Duration(milliseconds: 600);
    var callback = (timer) => {
          setState(() {
            _timer.cancel();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => AndroidHelloPage()),
              (route) => route == null,
            );
          })
        };
    _timer = Timer.periodic(oneSec, callback);
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
}
