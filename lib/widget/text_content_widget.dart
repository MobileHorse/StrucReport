import 'package:flutter/material.dart';
import 'package:strucreport/util/color_utils.dart';

class TextContentWidget extends StatelessWidget {

  final String text;

  TextContentWidget({this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 20,
          color: ColorUtils.textColorByTheme(context)),
    );
  }
}
