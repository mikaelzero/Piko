import 'package:pixiv/model/recommend.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_refresh_list_model.dart';

class CollectionsModel extends ViewStateRefreshListModel {
  final int userId;

  CollectionsModel(this.userId);

  String nextUrl;

  @override
  Future<List> loadData({int pageNum}) async {
    var result;
    if (pageNum == 0) {
      result = await apiClient.getBookmarksIllust(userId, "public", null);
    } else {
      result = await apiClient.getNext(nextUrl);
    }
    Recommend recommend = Recommend.fromJson(result.data);
    nextUrl = recommend.nextUrl;
    return recommend.illusts;
  }
}
