import 'package:intl/intl.dart';

class DateUtil {
  static String getNormal(DateTime dateTime) {
    var now = DateTime.now();
    if (now.year == dateTime.year) {
      return DateFormat('MM-dd').format(dateTime);
    }
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static String getFormat(DateTime dateTime, String newPattern) {
    return DateFormat(newPattern).format(dateTime);
  }
}
