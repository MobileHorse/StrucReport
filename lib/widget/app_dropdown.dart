import 'package:flutter/material.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/util/color_utils.dart';
import 'package:strucreport/util/preference_helper.dart';

import 'label_widget.dart';

class AppDropdownWidget extends StatefulWidget {

  final String label, prefKey;
  final List<String> values;
  final double padding, marginBottom;

  AppDropdownWidget({this.label = "", this.prefKey, this.values, this.padding = 20, this.marginBottom = 20});

  @override
  _AppDropdownWidgetState createState() => _AppDropdownWidgetState();
}

class _AppDropdownWidgetState extends State<AppDropdownWidget> {

  String value;

  @override
  void initState() {
    String savedValue = PreferenceHelper.getString(widget.prefKey);
    value = savedValue.isEmpty ? widget.values[0] : savedValue;
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await PreferenceHelper.setString(widget.prefKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: widget.padding,),
            Expanded(child: LabelWidget(label: widget.label),),
            SizedBox(width: 20,),
            DropdownButton<String>(
              value: value,
              icon: Icon(Icons.arrow_drop_down, size: 36, color: NeumorphicTheme.defaultTextColor(context),),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(
                fontSize: 20,
                color: ColorUtils.textColorByTheme(context),
              ),
              onChanged: (String newValue) async {
                setState(() {
                  value = newValue;
                });
                await PreferenceHelper.setString(widget.prefKey, newValue);
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
        ),
        SizedBox(height: widget.marginBottom,)
      ],
    );
  }
}
