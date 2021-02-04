class StringUtils {
  static String ellipsedName(String name) {
    var buffer = StringBuffer();
    var split = name.split(' ');
    for (var i = 0 ; i < split.length; i ++) {
      buffer.write(split[i][0]);
    }

    return buffer.toString();
  }
}