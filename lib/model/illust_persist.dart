class IllustPersist {
  IllustPersist();

  int id;
  int illustId;
  int userId;
  String pictureUrl;
  int time;

  IllustPersist.fromJson(Map<String, dynamic> json) {
    id = json[cid];
    illustId = json[cillust_id];
    userId = json[cuser_id];
    pictureUrl = json[cpicture_url];
    time = json[ctime];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[cid] = this.id;
    data[cillust_id] = this.illustId;
    data[cuser_id] = this.userId;
    data[cpicture_url] = this.pictureUrl;
    data[ctime] = this.time;
    return data;
  }
}

final String tableIllustPersist = 'illustpersist';
final String cid = "id";
final String cillust_id = "illust_id";
final String cuser_id = "user_id";
final String cpicture_url = "picture_url";
final String ctime = "time";
