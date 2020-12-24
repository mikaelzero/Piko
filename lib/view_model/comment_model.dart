import 'package:pixiv/model/comment_response.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_refresh_list_model.dart';

class CommentModel extends ViewStateRefreshListModel {
  final int illustId;

  CommentModel(this.illustId);

  String nextUrl;

  @override
  Future<List> loadData({int pageNum}) async {
    var result;
    if (pageNum == 0) {
      result = await apiClient.getIllustComments(illustId);
    } else {
      result = await apiClient.getNext(nextUrl);
    }
    CommentResponse commentResponse = CommentResponse.fromJson(result.data);
    nextUrl = commentResponse.nextUrl;
    return commentResponse.comments;
  }
}
