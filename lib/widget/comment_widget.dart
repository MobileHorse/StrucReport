import 'package:flutter/material.dart';

import 'label_widget.dart';
import 'text_field_multiline_widget.dart';

class CommentWidget extends StatelessWidget {

  final TextEditingController controller;
  final String label, hint;
  final int maxLines;

  CommentWidget({this.controller, this.label, this.maxLines = 3, this.hint = "Comments"});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: LabelWidget(label: label,),
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.only(left: 160),
          child: TextFieldMultilineWidget(controller: controller, maxLines: maxLines, hint: hint,),
        )
      ],
    );
  }
}
