import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:pixiv/model/illust_bookmark_tags_response.dart';
import 'package:pixiv/model/tags.dart';
import 'package:pixiv/model/ugoira_metadata_response.dart';
import 'package:pixiv/net/refresh_token_interceptor.dart';
import 'package:pixiv/utils/exts.dart';

final ApiClient apiClient = ApiClient();

class ApiClient {
  Dio httpClient;
  final String hashSalt = "28c1fdd170a5204386cb1313c7077b34f83e4aaf4aa829ce78c231e05b0bae2c";
  static String BASE_API_URL_HOST = 'app-api.pixiv.net';
  static String Accept_Language = "zh";
  static String BASE_IMAGE_HOST = ImageHost;

  String getIsoDate() {
    DateTime dateTime = new DateTime.now();
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'+00:00'");
    return dateFormat.format(dateTime);
  }

  static String getHash(String string) {
    var content = new Utf8Encoder().convert(string);
    var digest = md5.convert(content);
    return digest.toString();
  }

  ApiClient({bool isBookmark = false}) {
    String time = getIsoDate();
    if (isBookmark) {
      httpClient = Dio(apiClient.httpClient.options)
        ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true))
        ..interceptors.add(RefreshTokenInterceptor());
      (httpClient.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
        HttpClient httpClient = new HttpClient();
        httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
          return true;
        };
        return httpClient;
      };
      return;
    }
    httpClient = Dio()
      ..options.baseUrl = "https://210.140.131.188"
      ..options.connectTimeout = 20 * 1000
      ..options.headers = {
        "X-Client-Time": time,
        "X-Client-Hash": getHash(time + hashSalt),
        "User-Agent": "PixivAndroidApp/5.0.155 (Android 10.0; Pixel C)",
        HttpHeaders.acceptLanguageHeader: Accept_Language,
        "App-OS": "Android",
        "App-OS-Version": "Android 10.0",
        "App-Version": "5.0.166",
        "Host": BASE_API_URL_HOST
      }
      ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true))
      ..interceptors.add(RefreshTokenInterceptor());
    (httpClient.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
      return httpClient;
    };
    initA(time);
  }

  initA(time) async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      var headers = httpClient.options.headers;
      headers['User-Agent'] = "PixivAndroidApp/5.0.166 (Android ${androidInfo.version.release}; ${androidInfo.model})";
      headers['App-OS-Version'] = "Android ${androidInfo.version.release}";
    }
  }

  Future<Response> getUserBookmarkNovel(int user_id, String restrict) async {
    return httpClient.get('/v1/user/bookmarks/novel', queryParameters: notNullMap({"user_id": user_id, "restrict": restrict}));
  }

  Future<Response> postNovelBookmarkAdd(int novel_id, String restrict) async {
    return httpClient.post('/v2/novel/bookmark/add',
        data: notNullMap({"novel_id": novel_id, "restrict": restrict}), options: Options(contentType: Headers.formUrlEncodedContentType));
  }

  Future<Response> postNovelBookmarkDelete(int novel_id) async {
    return httpClient.post('/v1/novel/bookmark/delete',
        data: notNullMap({"novel_id": novel_id}), options: Options(contentType: Headers.formUrlEncodedContentType));
  }

  Future<Response> getNovelRanking(String mode, date) async {
    return httpClient.get("/v1/novel/ranking?filter=for_android", queryParameters: notNullMap({"mode": mode, "date": date}));
  }

  Future<Response> getNovelText(int novel_id) async {
    return httpClient.get("/v1/novel/text", queryParameters: notNullMap({"novel_id": novel_id}));
  }

  Future<Response> getNovelFollow(String restrict) {
    return httpClient.get(
      "/v1/novel/follow",
      queryParameters: {"restrict": restrict},
    );
  }

  Future<Response> getNovelRecommended() async {
    return httpClient.get("/v1/novel/recommended?include_privacy_policy=true&filter=for_android&include_ranking_novels=true");
  }

  Future<Response> getRecommend() async {
    return httpClient.get("/v1/illust/recommended?filter=for_ios&include_ranking_label=true");
  }

  Future<Response> getUserRecommended() async {
    return httpClient.get("/v1/user/recommended?filter=for_android");
  }

  Future<Response> getUser(int id) async {
    return httpClient.get("/v1/user/detail?filter=for_android", queryParameters: {"user_id": id});
  }

  Future<Response> postUser(int a, String b) async {
    return httpClient.post("/v1/user", data: {"a": a, "b": b}..removeWhere((k, v) => v == null));
  }

  Map<String, dynamic> notNullMap(Map<String, dynamic> map) {
    return map..removeWhere((k, v) => v == null);
  }

  Future<Response> postLikeIllust(int illust_id, String restrict, List<String> tags) async {
    if (tags != null && tags.isNotEmpty) {
      String tagString = tags.first;
      for (var i = 1; i < tags.length; i++) {
        tagString = tagString + ' ' + tags[i].trim();
      }
      return httpClient.post("/v2/illust/bookmark/add",
          data: notNullMap({
            "illust_id": illust_id,
            "restrict": restrict,
            "tags[]": tagString
            //null toString =="null"
          }),
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } else
      return httpClient.post("/v2/illust/bookmark/add",
          data: notNullMap({
            "illust_id": illust_id,
            "restrict": restrict,
          }),
          options: Options(contentType: Headers.formUrlEncodedContentType));
  }

  Future<Response> postUnLikeIllust(int illust_id) async {
    return httpClient.post("/v1/illust/bookmark/delete",
        data: {"illust_id": illust_id}, options: Options(contentType: Headers.formUrlEncodedContentType));
  }

  Future<Response> getUnlikeIllust(int illust_id) async {
    return httpClient.get("/v1/illust/bookmark/delete?illust_id=$illust_id");
  }

  Future<Response> getNext(String url) async {
    var a = httpClient.options.baseUrl;
    String finalUrl = url.replaceAll("app-api.pixiv.net", a.replaceAll(a, a.replaceFirst("https://", "")));
    return httpClient.get(finalUrl);
  }

  Future<Response> getIllustRanking(String mode, date) async {
    return httpClient.get("/v1/illust/ranking?filter=for_android",
        queryParameters: notNullMap({
          "mode": mode,
          "date": date,
        }));
  }

  Future<Response> getUserIllusts(int user_id, String type) async {
    return httpClient.get("/v1/user/illusts?filter=for_android", queryParameters: {"user_id": user_id, "type": type});
  }

  Future<Response> getUserNovels(int user_id) async {
    return httpClient.get("/v1/user/novels?filter=for_android", queryParameters: {"user_id": user_id});
  }

  Future<Response> getBookmarksIllust(int user_id, String restrict, String tag) async {
    return httpClient.get("/v1/user/bookmarks/illust", queryParameters: notNullMap({"user_id": user_id, "restrict": restrict, "tag": tag}));
  }

  Future<Response> postUnFollowUser(int user_id) {
    return httpClient.post("/v1/user/follow/delete", data: {"user_id": user_id}, options: Options(contentType: Headers.formUrlEncodedContentType));
  }

  Future<Response> getFollowUser(String restrict) {
    return httpClient.get(
      "/v1/user/follower?filter=for_android",
      queryParameters: {"restrict": restrict},
    );
  }

  Future<Response> getFollowIllusts(String restrict) {
    return httpClient.get(
      "/v2/illust/follow",
      queryParameters: {"restrict": restrict},
    );
  }

  Future<Response> getUserFollowing(int user_id, String restrict) {
    return httpClient.get(
      "/v1/user/following?filter=for_android",
      queryParameters: {"restrict": restrict, "user_id": user_id},
    );
  }

  Future<AutoWords> getSearchAutoCompleteKeywords(String word) async {
    final response = await httpClient.get(
      "/v2/search/autocomplete?merge_plain_keyword_results=true",
      queryParameters: {"word": word},
    );
    return AutoWords.fromJson(response.data);
  }

  Future<Response> getIllustTrendTags() async {
    return httpClient.get(
      "/v1/trending-tags/illust?filter=for_android",
    );
  }

  String getFormatDate(DateTime dateTime) {
    if (dateTime == null) {
      return null;
    } else
      return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }

  Future<Response> getSearchIllust(String word,
      {String sort = null, String search_target = null, DateTime start_date = null, DateTime end_date = null, int bookmark_num = null}) async {
    return httpClient.get("/v1/search/illust?filter=for_android&merge_plain_keyword_results=true",
        queryParameters: notNullMap({
          "sort": sort,
          "search_target": search_target,
          "start_date": getFormatDate(start_date),
          "end_date": getFormatDate(end_date),
          "bookmark_num": bookmark_num,
          "word": word
        }));
  }

  Future<Response> getSearchNovel(String word,
      {String sort = null, String search_target = null, DateTime start_date = null, DateTime end_date = null, int bookmark_num = null}) async {
    return httpClient.get("/v1/search/novel?filter=for_android&merge_plain_keyword_results=true",
        queryParameters: notNullMap({
          "sort": sort,
          "search_target": search_target,
          "start_date": getFormatDate(start_date),
          "end_date": getFormatDate(end_date),
          "bookmark_num": bookmark_num,
          "word": word
        }));
  }

  Future<Response> getSearchUser(String word) async {
    return httpClient.get("/v1/search/user?filter=for_android", queryParameters: {"word": word});
  }

  Future<Response> getSearchAutocomplete(String word) async =>
      httpClient.get("/v2/search/autocomplete?merge_plain_keyword_results=true", queryParameters: notNullMap({"word": word}));

  Future<Response> getIllustRelated(int illust_id) async =>
      httpClient.get("/v2/illust/related?filter=for_android", queryParameters: notNullMap({"illust_id": illust_id}));

  Future<Response> getIllustBookmarkDetail(int illust_id) async =>
      httpClient.get("/v2/illust/bookmark/detail", queryParameters: notNullMap({"illust_id": illust_id}));

  Future<Response> postUnfollowUser(int user_id) async => httpClient.post("/v1/user/follow/delete",
      data: notNullMap({"user_id": user_id}), options: Options(contentType: Headers.formUrlEncodedContentType));

  Future<Response> postFollowUser(int user_id, String restrict) {
    return httpClient.post("/v1/user/follow/add",
        data: {"user_id": user_id, "restrict": restrict}, options: Options(contentType: Headers.formUrlEncodedContentType));
  }

  Future<Response> getIllustDetail(int illust_id) {
    return httpClient.get("/v1/illust/detail?filter=for_android", queryParameters: {"illust_id": illust_id});
  }

  Future<Response> getSpotlightArticles(String category) {
    return httpClient.get("/v1/spotlight/articles?filter=for_android", queryParameters: {"category": category});
  }

  Future<Response> getIllustComments(int illust_id) {
    return httpClient.get("/v1/illust/comments", queryParameters: {"illust_id": illust_id});
  }

  Future<Response> postIllustComment(int illust_id, String comment, {int parent_comment_id = null}) {
    return httpClient.post("/v1/illust/comment/add",
        data: notNullMap({"illust_id": illust_id, "comment": comment, "parent_comment_id": parent_comment_id}),
        options: Options(contentType: Headers.formUrlEncodedContentType));
  }

  Future<UgoiraMetadataResponse> getUgoiraMetadata(int illust_id) async {
    final result = await httpClient.get(
      "/v1/ugoira/metadata",
      queryParameters: notNullMap({"illust_id": illust_id}),
    );
    return UgoiraMetadataResponse.fromJson(result.data);
  }

  Future<IllustBookmarkTagsResponse> getUserBookmarkTagsIllust(int user_id, {String restrict = 'public'}) async {
    final result = await httpClient.get(
      "/v1/user/bookmark-tags/illust",
      queryParameters: notNullMap({"user_id": user_id, "restrict": restrict}),
    );
    return IllustBookmarkTagsResponse.fromJson(result.data);
  }

  Future<Response> walkthroughIllusts() async {
    final result = await httpClient.get('/v1/walkthrough/illusts');
    return result;
  }

  Future<Response> getPopularPreview(String keyword) async {
    String a = httpClient.options.baseUrl;
    String previewUrl =
        '${a}/v1/search/popular-preview/illust?filter=for_android&include_translated_tag_results=true&merge_plain_keyword_results=true&word=${keyword}&search_target=partial_match_for_tags';
    final result = await httpClient.get(previewUrl);
    return result;
  }
}
