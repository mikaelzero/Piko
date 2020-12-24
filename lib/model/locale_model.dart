import 'package:flutter/material.dart';
import 'package:pixiv/config/storage_manager.dart';
import 'package:pixiv/generated/l10n.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/utils/platform_utils.dart';

class LocaleModel with ChangeNotifier {
  final languageList = ['zh', 'en', 'ja'];
  static const kLocaleIndex = 'kLocaleIndex';

  int languageNum = 0;

  LocaleModel() {
    languageNum = StorageManager.sharedPreferences.getInt(kLocaleIndex) ?? 0;
    ApiClient.Accept_Language = languageList[languageNum];
    apiClient.httpClient.options.headers[HttpHeaders.acceptLanguageHeader] = ApiClient.Accept_Language;
    S.load(S.delegate.supportedLocales[getRealNum(languageNum)]);
  }

  int getRealNum(int index) {
    if (index == 0) {
      return 2;
    } else if (index == 1) {
      return 0;
    } else {
      return 1;
    }
  }

  switchLocale(int index) {
    languageNum = index;
    StorageManager.sharedPreferences.setInt(kLocaleIndex, index);
    ApiClient.Accept_Language = languageList[index];
    apiClient.httpClient.options.headers[HttpHeaders.acceptLanguageHeader] = ApiClient.Accept_Language;
    S.load(S.delegate.supportedLocales[getRealNum(languageNum)]);
    notifyListeners();
  }
}
