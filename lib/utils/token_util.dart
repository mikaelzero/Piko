import 'package:pixiv/config/storage_manager.dart';

class TokenUtil {
  static const String TOKEN_KEY = "TOKEN_KEY";

  static String getToken() {
    return StorageManager.sharedPreferences.getString(TOKEN_KEY);
  }

  static void setToken(String token){
    StorageManager.localStorage.setItem(TOKEN_KEY, token);
  }
}