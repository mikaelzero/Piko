import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/main.dart';
import 'package:pixiv/store/login_store.dart';
import 'package:pixiv/ui/login/login_widget.dart';
import 'package:pixiv/ui/main/main_tab.dart';
import 'package:pixiv/utils/platform_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginStore _loginStore = LoginStore();
  bool _obscureText = true;
  bool _showBorder = false;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            S.of(context).appName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, fontFamily: "MPLUS1p"),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).welcome_back, style: TextStyle(fontSize: 35)),
              Text(
                S.of(context).welcome_sign,
                style: TextStyle(color: Colors.blueGrey[200], fontSize: 30, fontFamily: "MPLUS1p"),
              ),
            ],
          ),
          Column(
            children: [
              TextField(
                maxLines: 1,
                style: TextStyle(fontSize: 16, fontFamily: "MPLUS1p"),
                decoration: InputDecoration(hintText: S.of(context).login_account_hint),
                controller: _nameController,
                keyboardType: TextInputType.text,
              ),
              Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: TextField(
                    maxLines: 1,
                    obscureText: _obscureText,
                    style: TextStyle(fontSize: 16, fontFamily: "MPLUS1p"),
                    decoration: InputDecoration(
                      hintText: S.of(context).login_password_hint,
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          _obscureText = !_obscureText;
                        }),
                        icon: Icon(Icons.visibility),
                      ),
                    ),
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                  )),
            ],
          ),
          GestureDetector(
            child: _getLoginWidget(),
            onTap: onLoginPress,
          ),
          GestureDetector(
            onTap: () => _showRegisterDialog(context),
            child: Text(
              S.of(context).register,
              style: TextStyle(color: Colors.grey, fontSize: 18, fontFamily: "MPLUS1p"),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _getLoginWidget() {
    if (_showBorder) {
      return LineBorderText(
        autoAnim: true,
        child: Text(
          S.of(context).login,
          style: TextStyle(color: Colors.blue, fontSize: 45, fontFamily: "MPLUS1p"),
        ),
      );
    } else {
      return Text(
        S.of(context).login,
        style: TextStyle(color: Colors.blue, fontSize: 45, fontFamily: "MPLUS1p"),
      );
    }
  }

  void onLoginPress() async {
    if (_nameController.value.text.isEmpty || _passwordController.value.text.isEmpty) {
      BotToast.showText(text: S.of(context).login_empty_error);
      return;
    }
    setState(() {
      _showBorder = true;
    });
    bool isAuth = await _loginStore.auth(_nameController.value.text.trim(), _passwordController.value.text.trim());
    if (isAuth) {
      await accountStore.fetch();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Platform.isIOS ? AndroidHelloPage() : AndroidHelloPage()),
        (route) => route == null,
      );
    } else {
      BotToast.showText(text: _loginStore.errorMessage);
      setState(() {
        _showBorder = false;
      });
      return;
    }
  }

  Future _showRegisterDialog(BuildContext context) async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(S.of(context).register_notice),
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
          launch(
              "https://accounts.pixiv.net/signup?return_to=https%3A%2F%2Fwww.pixiv.net%2F&lang=zh&source=pc&view_type=page&ref=wwwtop_accounts_index");
        }
        break;
      case "CANCEL":
        {}
        break;
    }
  }
}
