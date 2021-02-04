import 'package:flutter/material.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';

class ColorUtils {
  static Color textColorByTheme(BuildContext context) {
    return NeumorphicTheme.of(context).isUsingDark
        ? Colors.white
        : Colors.black;
  }
}