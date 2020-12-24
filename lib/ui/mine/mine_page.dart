import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/main.dart';
import 'package:pixiv/model/locale_model.dart';
import 'package:pixiv/model/theme_model.dart';
import 'package:pixiv/provider/provider_widget.dart';
import 'package:pixiv/provider/view_state_widget.dart';
import 'package:pixiv/ui/mine/about_page.dart';
import 'package:pixiv/ui/mine/mine_collections_page.dart';
import 'package:pixiv/ui/mine/mine_follow_page.dart';
import 'package:pixiv/ui/user/user_home_page.dart';
import 'package:pixiv/view_model/user_model.dart';
import 'package:pixiv/widget/base_image.dart';
import 'package:pixiv/widget/restart_widget.dart';
import 'package:provider/provider.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with AutomaticKeepAliveClientMixin {
  bool isSwitched = ThemeModel().userDarkMode;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<UserViewModel>(
        model: UserViewModel(),
        onModelReady: (model) => model.getUserDetail(int.parse(accountStore.now.userId), isFetchSelf: true),
        builder: (context, model, child) {
          if (model.isBusy) {
            return ViewStateBusyWidget();
          } else if (model.isEmpty) {
            return ViewStateEmptyWidget(onPressed: () => {model.getUserDetail(int.parse(accountStore.now.userId), isFetchSelf: true)});
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 56),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) {
                        return UserHomePage(model.userDetail.user.id);
                      }));
                    },
                    child: Column(children: [
                      PixivCircleImage(model.userDetail.user.profile_image_urls.medium, width: 100, height: 100),
                      SizedBox(height: 16),
                      Text(model.userDetail.user.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 16),
                      Text(model.userDetail.profile.region, style: TextStyle(color: Colors.grey))
                    ])),
                SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) {
                            return UserHomePage(model.userDetail.user.id);
                          }));
                        },
                        child: Column(
                          children: [
                            Text(model.userDetail.profile.total_illusts.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "MPLUS1p")),
                            Text(S.of(context).user_page_tab1, style: TextStyle(color: Colors.grey)),
                          ],
                        )),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) {
                            return MineCollectionsPage(userId: model.userDetail.user.id);
                          }));
                        },
                        child: Column(
                          children: [
                            Text(model.userDetail.profile.total_illust_bookmarks_public.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "MPLUS1p")),
                            Text(S.of(context).user_page_tab2, style: TextStyle(color: Colors.grey)),
                          ],
                        )),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) {
                          return MineFollowPage(userId: model.userDetail.user.id);
                        }));
                      },
                      child: Column(
                        children: [
                          Text(model.userDetail.profile.total_follow_users.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "MPLUS1p")),
                          Text(S.of(context).follow, style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
                        builder: (_) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text("简体中文"),
                                  onTap: () {
                                    changeLanguage(context, 0);
                                  },
                                ),
                                ListTile(
                                  title: Text("English"),
                                  onTap: () {
                                    changeLanguage(context, 1);
                                  },
                                ),
                                ListTile(
                                  title: Text("日本語"),
                                  onTap: () {
                                    changeLanguage(context, 2);
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, top: 24,),
                      child: Text(S.of(context).settingLanguage, style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 12, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).dark_mode, style: TextStyle(fontSize: 18)),
                      Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            changeDarkMode(value);
                          })
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 12, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          S.of(context).accelerate,
                          style: TextStyle(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Switch(
                          value: userSettingStore.disableBypassSni,
                          onChanged: (value) async {
                            if (value) {
                              final result = await showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text(S.of(context).please_note_that),
                                      content: Text(S.of(context).please_note_that_content),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(S.of(context).cancel)),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop('OK');
                                            },
                                            child: Text(S.of(context).ok)),
                                      ],
                                    );
                                  });
                              if (result == 'OK') {
                                await userSettingStore.setDisableBypassSni(value);
                                RestartWidget.restartApp(context);
                              }
                            } else {
                              await userSettingStore.setDisableBypassSni(value);
                              RestartWidget.restartApp(context);
                            }
                          })
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) {
                      return AboutPage();
                    }));
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, top: 12, bottom: 12),
                      child: Text(S.of(context).about, style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: () => _showLogoutDialog(context),
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, top: 12, bottom: 12),
                      child: Text(S.of(context).logout, style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void changeLanguage(BuildContext context, int index) {
    Provider.of<LocaleModel>(context, listen: false).switchLocale(index);
    Navigator.of(context).pop();
    setState(() {});
  }

  void changeDarkMode(bool value) {
    setState(() {
      isSwitched = value;
    });
    ThemeModel().switchTheme(userDarkMode: isSwitched);
    RestartWidget.restartApp(context);
  }

  Future _showLogoutDialog(BuildContext context) async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(S.of(context).logout),
            actions: <Widget>[
              FlatButton(
                child: Text(S.of(context).cancel),
                onPressed: () {
                  Navigator.of(context).pop("CANCEL");
                },
              ),
              FlatButton(
                child: Text(S.of(context).ok),
                onPressed: () {
                  Navigator.of(context).pop("OK");
                },
              ),
            ],
          );
        });
    switch (result) {
      case "OK":
        {
          accountStore.deleteAll();
        }
        break;
      case "CANCEL":
        {}
        break;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
