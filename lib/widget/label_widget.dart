import 'package:flutter/material.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';

class LabelWidget extends StatelessWidget {

  final String label;
  final double fontSize;

  LabelWidget({this.label, this.fontSize = 20});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: NeumorphicTheme.defaultTextColor(context),
      ),
    );
  }
}
