import 'package:flutter/material.dart';

import 'app_comment_widget.dart';
import 'app_switch_widget.dart';

class AppSwitchCommentWidget extends StatefulWidget {

  final String label, prefKeySwitch, prefKeyComment;

  AppSwitchCommentWidget({this.label, this.prefKeySwitch, this.prefKeyComment});

  @override
  _AppSwitchCommentWidgetState createState() => _AppSwitchCommentWidgetState();
}

class _AppSwitchCommentWidgetState extends State<AppSwitchCommentWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSwitchWidget(
          label: widget.label,
          prefKey: widget.prefKeySwitch,
        ),
        AppCommentWidget(
          prefKey: widget.prefKeyComment,
        ),
      ],
    );
  }
}
