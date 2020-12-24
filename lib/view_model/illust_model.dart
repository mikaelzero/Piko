import 'package:dio/dio.dart';
import 'package:pixiv/model/illust.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_model.dart';

class IllustModel extends ViewStateModel {
  Illusts illusts;

  Future<bool> star(Illusts illusts, {String restrict = 'public', List<String> tags}) async {
    if (!illusts.isBookmarked) {
      try {
        Response response = await ApiClient(isBookmark: true).postLikeIllust(illusts.id, restrict, tags);
        illusts.isBookmarked = true;
        return true;
      } catch (e) {}
    } else {
      try {
        Response response = await ApiClient(isBookmark: true).postUnLikeIllust(illusts.id);
        illusts.isBookmarked = false;
        return false;
      } catch (e) {}
    }
    return null;
  }

  Future<void> loadDetail(int id, Illusts item) async {
    illusts = null;
    if (item != null) {
      illusts = item;
      setIdle();
    } else {
      setBusy();
      try {
        Response response = await apiClient.getIllustDetail(id);
        illusts = Illusts.fromJson(response.data['illust']);
        if (illusts == null) {
          setEmpty();
        } else {
          setIdle();
        }
      } catch (e) {
        setError(e, e);
      }
    }
  }
}
