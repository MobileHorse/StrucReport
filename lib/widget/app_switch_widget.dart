import 'package:flutter/material.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/util/preference_helper.dart';

import 'label_widget.dart';

class AppSwitchWidget extends StatefulWidget {

  final String label, prefKey;
  final Function(bool) onChange;

  AppSwitchWidget({this.label = "", this.prefKey, this.onChange});

  @override
  _AppSwitchWidgetState createState() => _AppSwitchWidgetState();
}

class _AppSwitchWidgetState extends State<AppSwitchWidget> {

  bool value;

  @override
  void initState() {
    value = PreferenceHelper.getBool(widget.prefKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 20,),
            Expanded(child: LabelWidget(label: widget.label),),
            SizedBox(width: 20,),
            NeumorphicSwitch(
              value: value,
              style: NeumorphicSwitchStyle(
                thumbShape: NeumorphicShape.concave, // concave or flat with elevation
              ),
              onChanged: (newValue) async {
                setState(() {
                  value = newValue;
                });
                if (widget.onChange != null) widget.onChange(newValue);
                await PreferenceHelper.setBool(widget.prefKey, newValue);
              },
            ),
          ],
        ),
        SizedBox(height: 20,)
      ],
    );
  }
}
