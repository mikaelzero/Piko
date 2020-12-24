import 'dart:convert';
import 'package:pixiv/model/trend_tags.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TagsModel extends ViewStateModel {
  List<Trend_tags> trendTags = List();

  Future<List> loadData() async {
    setBusy();
    trendTags = await geTagsData();
    if (trendTags != null && trendTags.isNotEmpty) {
      setIdle();
    } else {
      trendTags = List();
    }
    try {
      var result = await apiClient.getIllustTrendTags();
      TrendingTag trendingTag = TrendingTag.fromJson(result.data);
      trendTags.clear();
      trendTags.addAll(trendingTag.trend_tags);
      await setTagsData(trendTags);
      setIdle();
    } catch (e) {
      setEmpty();
    }
  }

  setTagsData(List<Trend_tags> trendTags) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('trendTags_json_sp', json.encode(trendTags));
  }

  Future<List<Trend_tags>> geTagsData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userJson = prefs.getString('trendTags_json_sp') ?? "";
      if (userJson.isEmpty) {
        return null;
      } else {
        List<Trend_tags> list = (json.decode(userJson) as List).map((e) => Trend_tags.fromJson(e)).toList();
        return list;
      }
    } catch (e) {
      return null;
    }
  }
}
