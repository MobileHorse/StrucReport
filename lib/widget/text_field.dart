import 'package:flutter/material.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/util/color_utils.dart';
import 'package:strucreport/widget/label_widget.dart';

class TextFieldWidget extends StatefulWidget {

  final String label, hint;
  final TextEditingController controller;

  TextFieldWidget({this.label, this.hint, this.controller});

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: LabelWidget(label: widget.label),
        ),
        Neumorphic(
          margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
          style: NeumorphicStyle(
            depth: NeumorphicTheme.embossDepth(context),
            boxShape: NeumorphicBoxShape.stadium(),
          ),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          child: TextField(
            controller: widget.controller,
            style: TextStyle(
              fontSize: 24,
              color: ColorUtils.textColorByTheme(context)
            ),
            decoration: InputDecoration.collapsed(hintText: this.widget.hint),
          ),
        )
      ],
    );
  }
}
