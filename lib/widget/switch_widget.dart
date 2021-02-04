import 'package:flutter/material.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';

import 'label_widget.dart';

class SwitchWidget extends StatefulWidget {

  final bool value;
  final String label;
  final Function(bool) onChange;

  SwitchWidget({this.value, this.label, this.onChange});

  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 20,),
        Expanded(child: LabelWidget(label: widget.label),),
        SizedBox(width: 20,),
        NeumorphicSwitch(
          value: widget.value,
          style: NeumorphicSwitchStyle(
            thumbShape: NeumorphicShape.concave, // concave or flat with elevation
          ),
          onChanged: (value) {
            widget.onChange(value);
          },
        ),
      ],
    );
  }
}
