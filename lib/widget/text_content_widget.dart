import 'package:flutter/material.dart';
import 'package:strucreport/util/color_utils.dart';

class TextContentWidget extends StatelessWidget {

  final String text;
  final double fontSize;

  TextContentWidget({this.text, this.fontSize = 20});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontSize,
          color: ColorUtils.textColorByTheme(context)),
    );
  }
}
