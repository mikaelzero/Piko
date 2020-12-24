import 'package:dio/dio.dart';
import 'package:pixiv/model/illust.dart';
import 'package:pixiv/model/recommend.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_model.dart';

class IllustAboutModel extends ViewStateModel {
  List<Illusts> illusts = new List();

  Future<void> loadAboutList(int id) async {
    setBusy();
    Response response = await apiClient.getIllustRelated(id);
    Recommend recommend = Recommend.fromJson(response.data);
    illusts.clear();
    illusts.addAll(recommend.illusts);
    if (illusts.isNotEmpty) {
      setIdle();
    } else {
      setEmpty();
    }
  }
}
