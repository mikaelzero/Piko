import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/model/theme_model.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeModel().userDarkMode ? ThemeModel.darkColor : Colors.white70,
        title: Text(
          S.of(context).about,
          style: TextStyle(color: ThemeModel().userDarkMode ? Colors.white70 : ThemeModel.darkColor),
        ),
        iconTheme: IconThemeData(color: ThemeModel().userDarkMode ? Colors.white70 : ThemeModel.darkColor),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).about_developer, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 16),
            Text("MikaelZero"),
            SizedBox(height: 36),
            Text(S.of(context).about_ui_design, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 16),
            Text("MikaelZero"),
            SizedBox(height: 36),
            Text("Github", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 16),
            SelectableText("https://github.com/MikaelZero"),
            SizedBox(height: 36),
            Text("Thanks", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 16),
            SelectableText("https://github.com/Notsfsssf/pixez-flutter \n\nhttps://github.com/phoenixsky/fun_android_flutter"),
            SizedBox(height: 36),
            Text(S.of(context).about_feed_back, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 16),
            SelectableText("miaoyongjun0118@gmail.com"),
          ],
        ),
      ),
    );
  }
}
