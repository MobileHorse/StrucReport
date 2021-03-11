import 'package:flutter/material.dart';
import 'package:strucreport/widget/app_inputbox.dart';

import 'label_widget.dart';

class SingleLineInput extends StatefulWidget {
  final String label, prefKey, hint;

  SingleLineInput({this.label = "", this.prefKey, this.hint = ""});

  @override
  _SingleLineInputState createState() => _SingleLineInputState();
}

class _SingleLineInputState extends State<SingleLineInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: LabelWidget(label: widget.label),
        ),
        Padding(padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 20),
          child: AppInputBox(prefKey: widget.prefKey, hint: widget.hint,),
        ),
      ],
    );
  }
}
