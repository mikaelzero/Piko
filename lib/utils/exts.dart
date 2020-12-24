import 'package:intl/intl.dart';
import 'package:pixiv/main.dart';
import 'package:pixiv/net/api_client.dart';

const ImageHost = "i.pximg.net";
const ImageSHost = "s.pximg.net";

extension TimeExts on String {
  String toShortTime() {
    try {
      var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
      return formatter.format(DateTime.parse(this));
    } catch (e) {
      return this ?? '';
    }
  }

  String toTrueUrl() {
    if (userSettingStore.disableBypassSni) {
      return this;
    }
    if (this.contains(ImageHost)) {
      return this.replaceFirst(ImageHost, ApiClient.BASE_IMAGE_HOST);
    }
    if (this.contains(ImageSHost)) {
      return this.replaceFirst(ImageSHost, ApiClient.BASE_IMAGE_HOST);
    }
    return this;
  }

  String toLegal() {
    return this
        .replaceAll("/", "")
        .replaceAll("\\", "")
        .replaceAll(":", "")
        .replaceAll("*", "")
        .replaceAll("?", "")
        .replaceAll(">", "")
        .replaceAll("|", "")
        .replaceAll("<", "");
  }
}
