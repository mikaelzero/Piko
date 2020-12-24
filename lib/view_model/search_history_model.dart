import 'dart:convert';

import 'package:pixiv/provider/view_state_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryModel extends ViewStateModel {
  List<String> historyList = List();

  Future<void> getHistory() async {
    setBusy();
    String historyKey = "historyKey";
    final prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.get(historyKey);
    if (jsonString == null || jsonString.isEmpty) {
      historyList.clear();
      setEmpty();
    } else {
      historyList.clear();
      historyList.addAll(List.from(json.decode(jsonString)));
      setIdle();
    }
  }

  static void saveHistory(String word) async {
    String historyKey = "historyKey";
    final prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.get(historyKey);
    List<String> historyList = List();
    if (jsonString == null || jsonString.isEmpty) {
      historyList.add(word);
    } else {
      historyList = List.from(json.decode(jsonString));
      if (!historyList.contains(word)) {
        historyList.add(word);
      }
    }
    prefs.setString(historyKey, json.encode(historyList));
  }
}
