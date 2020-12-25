import 'package:pixiv/main.dart';
import 'package:pixiv/model/recommend.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_refresh_list_model.dart';
import 'package:pixiv/store/user_store.dart';

class SearchIllustModel extends ViewStateRefreshListModel {
  final String word;
  String sort;

  String search_target;

  DateTime start_date;

  DateTime end_date;

  int bookmark_num;

  SearchIllustModel(this.word);

  void setFilter({String sort, String search_target, DateTime start_date, DateTime end_date, int bookmark_num}) {
    this.sort = sort;
    this.search_target = search_target;
    this.start_date = start_date;
    this.end_date = end_date;
    this.bookmark_num = bookmark_num;
  }

  String nextUrl;

  @override
  Future<List> loadData({int pageNum}) async {
    var result;
    if (pageNum == 0) {
      if (sort == "popular_desc" && accountStore.userDetail != null && !accountStore.userDetail.profile.is_premium) {
        result = await apiClient.getPopularPreview(word);
      } else if (this.bookmark_num != null && this.bookmark_num != 0) {
        result = await apiClient.getSearchIllust('$word ${bookmark_num}users入り',
            sort: sort, search_target: search_target, start_date: start_date, end_date: end_date);
      } else {
        result = await apiClient.getSearchIllust(word, sort: sort, search_target: search_target, start_date: start_date, end_date: end_date);
      }
    } else {
      result = await apiClient.getNext(nextUrl);
    }
    Recommend recommend = Recommend.fromJson(result.data);
    nextUrl = recommend.nextUrl;
    return recommend.illusts;
  }
}
