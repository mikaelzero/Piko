import 'package:pixiv/model/recommend.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_refresh_list_model.dart';

class RankModel extends ViewStateRefreshListModel {
  final String mode;
  final String date;

  RankModel(this.mode, this.date);

  String nextUrl;

  @override
  Future<List> loadData({int pageNum}) async {
    var result;
    if (pageNum == 0) {
      result = await apiClient.getIllustRanking(
        mode,
        date,
      );
    } else {
      result = await apiClient.getNext(nextUrl);
    }
    Recommend recommend = Recommend.fromJson(result.data);
    nextUrl = recommend.nextUrl;
    return recommend.illusts;
  }
}
