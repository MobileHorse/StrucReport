import 'package:flutter/material.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';

class LabelWidget extends StatelessWidget {

  final String label;
  final double fontSize;
  final FontWeight weight;

  LabelWidget({this.label, this.fontSize = 20, this.weight = FontWeight.w700});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: weight,
        color: NeumorphicTheme.defaultTextColor(context),
      ),
    );
  }
}
