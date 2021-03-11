import 'package:flutter/material.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/util/color_utils.dart';
import 'package:strucreport/util/preference_helper.dart';

class AppInputBox extends StatefulWidget {

  final String prefKey, hint;

  AppInputBox({this.prefKey, this.hint = ""});

  @override
  _AppInputBoxState createState() => _AppInputBoxState();
}

class _AppInputBoxState extends State<AppInputBox> {

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = PreferenceHelper.getString(widget.prefKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: NeumorphicTheme.embossDepth(context),
        boxShape: NeumorphicBoxShape.stadium(),
      ),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: TextField(
        controller: _controller,
        onChanged: (value) async {
          await PreferenceHelper.setString(widget.prefKey, value);
        },
        style: TextStyle(
            fontSize: 24,
            color: ColorUtils.textColorByTheme(context)
        ),
        decoration: InputDecoration.collapsed(hintText: widget.hint),
      ),
    );
  }
}
