import 'package:dio/dio.dart';
import 'package:pixiv/model/illust.dart';
import 'package:pixiv/model/recommend.dart';
import 'package:pixiv/model/user_detail.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_model.dart';
import 'package:pixiv/provider/view_state_refresh_list_model.dart';
import 'package:pixiv/utils/platform_utils.dart';

class UserCollectionsViewModel extends ViewStateRefreshListModel {
  final int userId;

  UserCollectionsViewModel(this.userId);

  String nextUrl;

  @override
  Future<List> loadData({int pageNum}) async {
    Response response = await apiClient.getBookmarksIllust(userId, "public", null);
    Recommend recommend = Recommend.fromJson(response.data);
    nextUrl = recommend.nextUrl;
    return recommend.illusts;
  }
}
