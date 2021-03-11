import 'package:flutter/material.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/util/color_utils.dart';
import 'package:strucreport/util/preference_helper.dart';

import 'label_widget.dart';

class AppCommentWidget extends StatefulWidget {

  final String hint, prefKey, label;
  final int maxLines;

  AppCommentWidget({this.label = "", this.hint = "Comment", this.prefKey, this.maxLines = 3});

  @override
  _AppCommentWidgetState createState() => _AppCommentWidgetState();
}

class _AppCommentWidgetState extends State<AppCommentWidget> {

  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.text = PreferenceHelper.getString(widget.prefKey);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label.isNotEmpty ?
        Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
          child: LabelWidget(label: widget.label),
        ) :
        Container(),
        Padding(
          padding: const EdgeInsets.only(left: 160, bottom: 20),
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: NeumorphicTheme.embossDepth(context),
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
            ),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: TextField(
              controller: _controller,
              onChanged: (value) async {
                await PreferenceHelper.setString(widget.prefKey, value);
              },
              style: TextStyle(
                  fontSize: 20,
                  color: ColorUtils.textColorByTheme(context)
              ),
              maxLines: widget.maxLines,
              decoration: InputDecoration.collapsed(hintText: this.widget.hint, hintStyle: TextStyle(fontSize: 20, color: NeumorphicTheme.defaultTextColor(context))),
            ),
          ),
        )
      ],
    );
  }
}
