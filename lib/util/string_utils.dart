import 'preference_helper.dart';

class StringUtils {
  static String ellipsedName(String name) {
    var buffer = StringBuffer();
    var split = name.split(' ');
    for (var i = 0 ; i < split.length; i ++) {
      buffer.write(split[i][0]);
    }

    return buffer.toString();
  }

  static bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  static String naDefaultedValue({String param}) {
    String value = PreferenceHelper.getString(param);
    if (value.isEmpty) value = "N/A";
    return value;
  }
}