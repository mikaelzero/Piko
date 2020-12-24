import 'package:pixiv/model/recommend.dart';
import 'package:pixiv/model/user_preview.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_refresh_list_model.dart';

class SearchUserModel extends ViewStateRefreshListModel {
  final String word;

  SearchUserModel(this.word);

  String nextUrl;

  @override
  Future<List> loadData({int pageNum}) async {
    var result;
    if (pageNum == 0) {
      result = await apiClient.getSearchUser(word);
    } else {
      result = await apiClient.getNext(nextUrl);
    }
    UserPreviewsResponse userPreviewsResponse = UserPreviewsResponse.fromJson(result.data);
    nextUrl = userPreviewsResponse.next_url;
    return userPreviewsResponse.user_previews;
  }
}
