import 'package:pixiv/model/recommend.dart';
import 'package:pixiv/model/user_preview.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_refresh_list_model.dart';

class FollowModel extends ViewStateRefreshListModel {
  final int userId;

  FollowModel(this.userId);

  String nextUrl;

  @override
  Future<List> loadData({int pageNum}) async {
    var result;
    if (pageNum == 0) {
      result = await apiClient.getUserFollowing(userId, "public");
    } else {
      result = await apiClient.getNext(nextUrl);
    }
    UserPreviewsResponse recommend = UserPreviewsResponse.fromJson(result.data);
    nextUrl = recommend.next_url;
    return recommend.user_previews;
  }
}
