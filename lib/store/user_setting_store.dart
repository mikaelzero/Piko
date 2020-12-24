import 'dart:io';

import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingStore {
  SharedPreferences prefs;

  bool disableBypassSni = false;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    disableBypassSni = prefs.getBool('disable_bypass_sni') ?? false;
  }

  setDisableBypassSni(bool value) async {
    await prefs.setBool('disable_bypass_sni', value);
    disableBypassSni = value;
  }
}
