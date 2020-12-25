import 'dart:convert';
import 'package:pixiv/config/storage_manager.dart';
import 'package:pixiv/model/user_detail.dart';

class UserStore {
  static setUserData(UserDetail user) async {
    await StorageManager.sharedPreferences.setString('user_json_sp', json.encode(user.toJson()));
  }

  static Future<UserDetail> getUserData() async {
    try {
      var userJson = StorageManager.sharedPreferences.getString('user_json_sp') ?? "";
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
