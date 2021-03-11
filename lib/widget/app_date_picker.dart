import 'package:flutter/material.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/util/preference_helper.dart';

import 'label_widget.dart';
import 'text_content_widget.dart';

class AppDatePicker extends StatefulWidget {

  final String label, prefKey;
  final bool isAlignedEnd;

  AppDatePicker({this.label, this.prefKey, this.isAlignedEnd = false});

  @override
  _AppDatePickerState createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {

  DateTime _dateTime;

  @override
  void initState() {
    _dateTime = PreferenceHelper.getDate(widget.prefKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
            ),
            LabelWidget(label: widget.label),
            widget.isAlignedEnd ?
            Expanded(child: Container()) :
            SizedBox(
              width: 20,
            ),
            NeumorphicButton(
              style: NeumorphicStyle(shape: NeumorphicShape.convex),
              child: TextContentWidget(
                text: "${_dateTime.toLocal()}".split(' ')[0],
              ),
              onPressed: () => _selectDate(context),
            ),
          ],
        ),
        SizedBox(height: 20,)
      ],
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: NeumorphicTheme.of(context).isUsingDark ? ThemeData.dark() : ThemeData.light(),
        child: child,
      ),
    );
    if (picked != null && picked != _dateTime) {
      setState(() {
        _dateTime = picked;
      });
      await PreferenceHelper.setDate(widget.prefKey, picked);
    }
  }
}
