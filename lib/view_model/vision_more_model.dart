import 'package:pixiv/model/spotlight_response.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_refresh_list_model.dart';

class VisionMoreModel extends ViewStateRefreshListModel {
  String nextUrl;

  @override
  Future<List> loadData({int pageNum}) async {
    var result;
    if (pageNum == 0) {
      result = await apiClient.getSpotlightArticles("all");
    } else {
      result = await apiClient.getNext(nextUrl);
    }
    SpotlightResponse recommend = SpotlightResponse.fromJson(result.data);
    nextUrl = recommend.nextUrl;
    return recommend.spotlightArticles;
  }
}
