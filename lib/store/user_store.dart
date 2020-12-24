import 'dart:convert';
import 'package:pixiv/model/user_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStore {
  static setUserData(UserDetail user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_json_sp', json.encode(user.toJson()));
  }

  static Future<UserDetail> getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userJson = prefs.getString('user_json_sp') ?? "";
      if (userJson.isEmpty) {
        return null;
      } else {
        Map<String, dynamic> map = json.decode(userJson);
        UserDetail userDetail = UserDetail.fromJson(map);
        return userDetail;
      }
    } catch (e) {
      return null;
    }
  }
}
