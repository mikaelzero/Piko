import 'package:dio/dio.dart';
import 'package:pixiv/model/illust.dart';
import 'package:pixiv/model/recommend.dart';
import 'package:pixiv/model/user_detail.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_model.dart';
import 'package:pixiv/store/user_store.dart';
import 'package:pixiv/utils/platform_utils.dart';

class UserViewModel extends ViewStateModel {
  UserDetail userDetail;
  bool isFollow = false;

  Future<void> getUserDetail(int userId, {bool isFetchSelf = false}) async {
    setBusy();
    if (isFetchSelf) {
      userDetail = await UserStore.getUserData();
      if (userDetail != null) {
        setIdle();
      }
    }
    try {
      Response response = await apiClient.getUser(userId);
      UserDetail userDetail = UserDetail.fromJson(response.data);
      this.userDetail = userDetail;
      this.isFollow = this.userDetail.user.is_followed;
      if (isFetchSelf) {
        await UserStore.setUserData(this.userDetail);
      }
      setIdle();
    } on DioError catch (e) {
      if (e.response != null && e.response.statusCode == HttpStatus.notFound) {
        setEmpty();
      } else {
        setEmpty();
      }
    }
  }

  Future<void> follow(int targetUserId) async {
    if (isFollow) {
      return;
    }
    try {
      Response response = await apiClient.postFollowUser(targetUserId, "public");
      isFollow = true;
    } on DioError catch (e) {
      if (e.response != null && e.response.statusCode == HttpStatus.badRequest) {}
    }
  }

  Future<void> unFollow(int targetUserId) async {
    if (!isFollow) {
      return;
    }
    try {
      Response response = await apiClient.postUnFollowUser(targetUserId);
      isFollow = false;
    } on DioError catch (e) {
      if (e.response != null && e.response.statusCode == HttpStatus.badRequest) {}
    }
  }
}
