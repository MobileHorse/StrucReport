import 'package:flutter/material.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/util/color_utils.dart';
import 'package:strucreport/widget/label_widget.dart';

class DropdownWidget extends StatefulWidget {

  final String initial, label;
  final List<String> values;
  final Function(String) onChange;
  final double padding;

  DropdownWidget({this.label, this.initial, this.values, this.onChange, this.padding = 20});

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: widget.padding,),
        Expanded(child: LabelWidget(label: widget.label),),
        SizedBox(width: 20,),
        DropdownButton<String>(
          value: widget.initial,
          icon: Icon(Icons.arrow_drop_down, size: 36, color: NeumorphicTheme.defaultTextColor(context),),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(
            fontSize: 20,
            color: ColorUtils.textColorByTheme(context),
          ),
          onChanged: (String newValue) {
            widget.onChange(newValue);
          },
          dropdownColor: NeumorphicTheme.baseColor(context),
          underline: Container(),
          items: widget.values.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ],
    );
  }
}
