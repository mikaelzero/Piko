import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv/config/storage_manager.dart';
import 'package:pixiv/helper/theme_helper.dart';

//const Color(0xFF5394FF),

class ThemeModel with ChangeNotifier {
  static const kThemeColorIndex = 'kThemeColorIndex';
  static const kThemeUserDarkMode = 'kThemeUserDarkMode';
  static const darkColor = Color(0xFF161A23);

  /// 用户选择的明暗模式
  bool userDarkMode;

  /// 当前主题颜色
  MaterialColor _themeColor;

  ThemeModel() {
    /// 用户选择的明暗模式
    userDarkMode = StorageManager.sharedPreferences.getBool(kThemeUserDarkMode) ?? false;

    /// 获取主题色
    _themeColor = Colors.primaries[StorageManager.sharedPreferences.getInt(kThemeColorIndex) ?? 7];
  }

  /// 切换指定色彩
  ///
  /// 没有传[brightness]就不改变brightness,color同理
  void switchTheme({bool userDarkMode, MaterialColor color}) {
    userDarkMode = userDarkMode ?? userDarkMode;
    _themeColor = color ?? _themeColor;
    notifyListeners();
    saveTheme2Storage(userDarkMode, _themeColor);
  }

  /// 随机一个主题色彩
  ///
  /// 可以指定明暗模式,不指定则保持不变
  void switchRandomTheme({Brightness brightness}) {
    int colorIndex = Random().nextInt(Colors.primaries.length - 1);
    switchTheme(
      userDarkMode: Random().nextBool(),
      color: Colors.primaries[colorIndex],
    );
  }

  /// 根据主题 明暗 和 颜色 生成对应的主题
  /// [dark]系统的Dark Mode
  themeData({bool platformDarkMode: false}) {
    var isDark = platformDarkMode || userDarkMode;
    Brightness brightness = isDark ? Brightness.dark : Brightness.light;

    var themeColor = _themeColor;
    var accentColor = isDark ? themeColor[700] : _themeColor;
    var themeData = ThemeData(
      brightness: brightness,
      // 主题颜色属于亮色系还是属于暗色系(eg:dark时,AppBarTitle文字及状态栏文字的颜色为白色,反之为黑色)
      // 这里设置为dark目的是,不管App是明or暗,都将appBar的字体颜色的默认值设为白色.
      // 再AnnotatedRegion<SystemUiOverlayStyle>的方式,调整响应的状态栏颜色
      primaryColorBrightness: Brightness.light,
      accentColorBrightness: Brightness.light,
      primarySwatch: themeColor,
      accentColor: accentColor,
    );

    themeData = themeData.copyWith(
      brightness: brightness,
      accentColor: accentColor,
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: themeColor,
        brightness: brightness,
      ),
      appBarTheme: themeData.appBarTheme.copyWith(elevation: 0),
      splashColor: themeColor.withAlpha(50),
      hintColor: themeData.hintColor.withAlpha(90),
      errorColor: Colors.red,
      cursorColor: accentColor,
      textTheme: themeData.textTheme.copyWith(
        subhead: themeData.textTheme.subhead.copyWith(textBaseline: TextBaseline.alphabetic),
        ///暗黑模式文字样式修改
        body1: isDark ? TextStyle(color: Colors.white70) : TextStyle(color: Colors.black87),
      ),
      textSelectionColor: accentColor.withAlpha(60),
      textSelectionHandleColor: accentColor.withAlpha(60),
      toggleableActiveColor: accentColor,
      chipTheme: themeData.chipTheme.copyWith(
        pressElevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        labelStyle: themeData.textTheme.caption,
        backgroundColor: themeData.chipTheme.backgroundColor.withOpacity(0.1),
      ),
      inputDecorationTheme: ThemeHelper.inputDecorationTheme(themeData),
    );
    return themeData;
  }

  /// 数据持久化到shared preferences
  saveTheme2Storage(bool userDarkMode, MaterialColor themeColor) async {
    var index = Colors.primaries.indexOf(themeColor);
    await Future.wait([
      StorageManager.sharedPreferences.setBool(kThemeUserDarkMode, userDarkMode),
      StorageManager.sharedPreferences.setInt(kThemeColorIndex, index)
    ]);
  }
}
