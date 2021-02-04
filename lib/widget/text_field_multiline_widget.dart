import 'package:flutter/material.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/util/color_utils.dart';

class TextFieldMultilineWidget extends StatefulWidget {

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  TextFieldMultilineWidget({this.controller, this.hint = "", this.maxLines = 3});

  @override
  _TextFieldMultilineWidgetState createState() => _TextFieldMultilineWidgetState();
}

class _TextFieldMultilineWidgetState extends State<TextFieldMultilineWidget> {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
      style: NeumorphicStyle(
        depth: NeumorphicTheme.embossDepth(context),
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
      ),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      child: TextField(
        controller: widget.controller,
        style: TextStyle(
            fontSize: 20,
            color: ColorUtils.textColorByTheme(context)
        ),
        maxLines: widget.maxLines,
        decoration: InputDecoration.collapsed(hintText: this.widget.hint, hintStyle: TextStyle(fontSize: 20, color: NeumorphicTheme.defaultTextColor(context))),
      ),
    );
  }
}
