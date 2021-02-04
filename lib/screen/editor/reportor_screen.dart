import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strucreport/bloc/bloc.dart';
import 'package:strucreport/config/application.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/model/report_model.dart';
import 'package:strucreport/util/color_utils.dart';
import 'package:strucreport/widget/dropdown_widget.dart';
import 'package:strucreport/widget/label_widget.dart';
import 'package:strucreport/widget/text_content_widget.dart';
import 'package:strucreport/widget/text_field.dart';

class ReporterScreen extends StatefulWidget {
  @override
  _ReporterScreenState createState() => _ReporterScreenState();
}

class _ReporterScreenState extends State<ReporterScreen> {

  EditorBloc bloc;
  DateTime _preparedDate, _checkedDate, _approvedDate;
  String _preparedBy, _checkedBy, _approvedBy;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<EditorBloc>(context);
    EditorReporterState state = bloc.state;
    ReportModel report = state.report;
    _preparedBy = report.preparedBy;
    _preparedDate = report.preparedDate ?? DateTime.now();
    _checkedBy = report.checkedBy;
    _checkedDate = report.checkedDate ?? DateTime.now();
    _approvedBy = report.approvedBy;
    _approvedDate = report.approvedDate ?? DateTime.now();
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
                        DropdownWidget(
                          label: "Prepared by: ",
                          initial: _preparedBy,
                          values: Application.Employees,
                          onChange: (val) {
                            setState(() {
                              _preparedBy = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: LabelWidget(label: "Prepared Date: "),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            NeumorphicButton(
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex),
                              child: TextContentWidget(
                                text:
                                "${_preparedDate.toLocal()}".split(' ')[0],
                              ),
                              onPressed: () => _selectPreparedDate(context),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        DropdownWidget(
                          label: "Checked by: ",
                          initial: _checkedBy,
                          values: Application.Employees,
                          onChange: (val) {
                            setState(() {
                              _checkedBy = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: LabelWidget(label: "Checked Date: "),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            NeumorphicButton(
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex),
                              child: TextContentWidget(
                                text:
                                "${_checkedDate.toLocal()}".split(' ')[0],
                              ),
                              onPressed: () => _selectCheckedDate(context),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        DropdownWidget(
                          label: "Approved by: ",
                          initial: _approvedBy,
                          values: Application.Employees,
                          onChange: (val) {
                            setState(() {
                              _approvedBy = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: LabelWidget(label: "Approved Date: "),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            NeumorphicButton(
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex),
                              child: TextContentWidget(
                                text:
                                "${_approvedDate.toLocal()}".split(' ')[0],
                              ),
                              onPressed: () => _selectApprovedDate(context),
                            ),
                          ],
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
                bloc.add(EditorPrevEvent(report: getUpdatedReport()));
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
                bloc.add(EditorReporterNextEvent(report: getUpdatedReport()));
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

  _selectPreparedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _preparedDate,
      // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: NeumorphicTheme.of(context).isUsingDark
            ? ThemeData.dark()
            : ThemeData.light(),
        child: child,
      ),
    );
    if (picked != null && picked != _preparedDate)
      setState(() {
        _preparedDate = picked;
      });
  }

  _selectCheckedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _checkedDate,
      // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: NeumorphicTheme.of(context).isUsingDark
            ? ThemeData.dark()
            : ThemeData.light(),
        child: child,
      ),
    );
    if (picked != null && picked != _checkedDate)
      setState(() {
        _checkedDate = picked;
      });
  }

  _selectApprovedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _approvedDate,
      // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: NeumorphicTheme.of(context).isUsingDark
            ? ThemeData.dark()
            : ThemeData.light(),
        child: child,
      ),
    );
    if (picked != null && picked != _approvedDate)
      setState(() {
        _approvedDate = picked;
      });
  }

  ReportModel getUpdatedReport() {
    EditorReporterState state = bloc.state;
    ReportModel report = state.report;
    report.preparedBy = _preparedBy;
    report.preparedDate = _preparedDate;
    report.checkedBy = _checkedBy;
    report.checkedDate = _checkedDate;
    report.approvedBy = _approvedBy;
    report.approvedDate = _approvedDate;
    return report;
  }
}
