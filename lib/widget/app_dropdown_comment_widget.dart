import 'package:flutter/material.dart';
import 'package:strucreport/widget/app_comment_widget.dart';
import 'package:strucreport/widget/app_dropdown.dart';

class AppDropdownCommentWidget extends StatefulWidget {

  final String label, prefKeyDropdown, prefKeyComment;
  final List<String> values;

  AppDropdownCommentWidget({this.label, this.prefKeyDropdown, this.prefKeyComment, this.values});

  @override
  _AppDropdownCommentWidgetState createState() => _AppDropdownCommentWidgetState();
}

class _AppDropdownCommentWidgetState extends State<AppDropdownCommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDropdownWidget(
          label: widget.label,
          prefKey: widget.prefKeyDropdown,
          values: widget.values,
        ),
        AppCommentWidget(
          prefKey: widget.prefKeyComment,
        )
      ],
    );
  }
}
