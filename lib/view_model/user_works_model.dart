import 'package:dio/dio.dart';
import 'package:pixiv/model/illust.dart';
import 'package:pixiv/model/recommend.dart';
import 'package:pixiv/model/user_detail.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_model.dart';
import 'package:pixiv/provider/view_state_refresh_list_model.dart';
import 'package:pixiv/utils/platform_utils.dart';

class UserWorksViewModel extends ViewStateRefreshListModel {
  final int userId;

  UserWorksViewModel(this.userId);

  String nextUrl;

  @override
  Future<List> loadData({int pageNum}) async {
    var result;
    if (pageNum == 0) {
      result = await apiClient.getUserIllusts(userId, 'illust');
    } else {
      result = await apiClient.getNext(nextUrl);
    }
    Recommend recommend = Recommend.fromJson(result.data);
    nextUrl = recommend.nextUrl;
    return recommend.illusts;
  }
}
