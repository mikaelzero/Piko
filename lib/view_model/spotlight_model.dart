import 'package:dio/dio.dart';
import 'package:pixiv/model/spotlight_response.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_refresh_list_model.dart';

class SpotlightModel extends ViewStateRefreshListModel {
  String nextUrl;

  @override
  Future<List> loadData({int pageNum}) async {
    Response response;
    if (pageNum == 0) {
      response = await apiClient.getSpotlightArticles("all");
    } else {
      response = await apiClient.getNext(nextUrl);
    }
    final result = SpotlightResponse.fromJson(response.data);
    nextUrl = result.nextUrl;
    return result.spotlightArticles;
  }
}
