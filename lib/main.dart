import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pixiv/config/storage_manager.dart';
import 'package:pixiv/model/locale_model.dart';
import 'package:pixiv/model/theme_model.dart';
import 'package:pixiv/store/account_store.dart';
import 'package:pixiv/store/user_setting_store.dart';
import 'package:pixiv/utils/platform_utils.dart';
import 'package:pixiv/utils/refresh_util.dart';
import 'package:pixiv/widget/restart_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'config/provider_manager.dart';
import 'config/router_manger.dart';
import 'generated/l10n.dart';

final AccountStore accountStore = AccountStore();
final UserSettingStore userSettingStore = UserSettingStore();

main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.init();
  runApp(RestartWidget(child: MyApp()));
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  userSettingStore.init();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    accountStore.fetch();
    super.initState();
  }

  Future<void> clean() async {}

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: providers,
        child: Consumer2<ThemeModel, LocaleModel>(builder: (context, themeModel, localeModel, child) {
          return RefreshConfiguration(
            hideFooterWhenNotFull: true,
            enableLoadingWhenNoData: false,
            enableBallisticLoad: true,
            footerBuilder: () => PixivRefreshFooter(),
            child: MaterialApp(
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              debugShowCheckedModeBanner: false,
              theme: themeModel.themeData(),
              darkTheme: themeModel.themeData(platformDarkMode: true),
              locale: S.delegate.supportedLocales[localeModel.getRealNum(localeModel.languageNum)],
              localizationsDelegates: const [
                S.delegate,
                RefreshLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              supportedLocales: S.delegate.supportedLocales,
              onGenerateRoute: RouterManager.generateRoute,
              initialRoute: RouteName.splash,
            ),
          );
        }));
  }
}
