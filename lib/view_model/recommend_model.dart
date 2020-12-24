import 'package:dio/dio.dart';
import 'package:pixiv/model/recommend.dart';
import 'package:pixiv/model/user_preview.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_list_model.dart';
import 'package:pixiv/provider/view_state_refresh_list_model.dart';

class RecommendUserModel extends ViewStateListModel {
  @override
  Future<List> loadData() async {
    final result = await apiClient.getUserRecommended();
    final response = UserPreviewsResponse.fromJson(result.data);
    return response.user_previews;
  }
}

class RecommendPostModel extends ViewStateRefreshListModel {
  String nextUrl;

  @override
  Future<List> loadData({int pageNum}) async {
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
