import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strucreport/bloc/bloc.dart';
import 'package:strucreport/config/application.dart';
import 'package:strucreport/config/params.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/widget/app_date_picker.dart';
import 'package:strucreport/widget/app_dropdown.dart';

class ReporterScreen extends StatefulWidget {
  @override
  _ReporterScreenState createState() => _ReporterScreenState();
}

class _ReporterScreenState extends State<ReporterScreen> {

  EditorBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<EditorBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Neumorphic(
            margin: EdgeInsets.symmetric(horizontal: 32),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            style: NeumorphicStyle(
              boxShape:
              NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                          width: double.infinity,
                        ),
                        AppDropdownWidget(
                          label: "Inspected by: ",
                          prefKey: Params.inspectedDate2,
                          values: Application.Employees2,
                        ),
                        AppDatePicker(
                          label: "Inspected date: ",
                          prefKey: Params.inspector2,
                          isAlignedEnd: true,
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeumorphicButton(
              onPressed: () {
                bloc.add(EditorPrevEvent());
                },
              style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.circle(),
                  shape: NeumorphicShape.concave
              ),
              child: Icon(Icons.arrow_left, size: Application.IconSize, color: NeumorphicTheme.defaultTextColor(context),),
            ),
            SizedBox(width: 60,),
            NeumorphicButton(
              onPressed: () {
                bloc.add(EditorReporterNextEvent());
              },
              style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.circle(),
                  shape: NeumorphicShape.concave
              ),
              child: Icon(Icons.arrow_right, size: Application.IconSize, color: NeumorphicTheme.defaultTextColor(context),),
            )
          ],
        ),
        SizedBox(height: 40,)
      ],
    );
  }

}
