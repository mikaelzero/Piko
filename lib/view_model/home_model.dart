import 'package:dio/dio.dart';
import 'package:pixiv/model/recommend.dart';
import 'package:pixiv/model/spotlight_response.dart';
import 'package:pixiv/model/user_preview.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_refresh_list_model.dart';

class HomeModel extends ViewStateRefreshListModel {
  String nextUrl;
  List<UserPreviews> userPreviewsList = new List();
  List<SpotlightArticle> spotlightArticles = new List();

  @override
  Future<List> loadData({int pageNum}) async {
    final recommendUserResponse = await apiClient.getUserRecommended();
    final recommendUserResult = UserPreviewsResponse.fromJson(recommendUserResponse.data);
    userPreviewsList.clear();
    userPreviewsList.addAll(recommendUserResult.user_previews);

    final spotlightResponse = await apiClient.getSpotlightArticles("all");
    final spotlightResult = SpotlightResponse.fromJson(spotlightResponse.data);
    spotlightArticles.clear();
    spotlightArticles.addAll(spotlightResult.spotlightArticles);

    Response response;
    if (pageNum == 0) {
      response = await apiClient.getRecommend();
    } else {
      response = await apiClient.getNext(nextUrl);
    }
    final result = Recommend.fromJson(response.data);
    nextUrl = result.nextUrl;

    return result.illusts;
  }
}
