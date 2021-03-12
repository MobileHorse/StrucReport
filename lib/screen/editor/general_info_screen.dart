import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strucreport/bloc/bloc.dart';
import 'package:strucreport/config/application.dart';
import 'package:strucreport/config/params.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/util/preference_helper.dart';
import 'package:strucreport/util/toasts.dart';
import 'package:strucreport/widget/app_comment_widget.dart';
import 'package:strucreport/widget/app_date_picker.dart';
import 'package:strucreport/widget/app_dropdown.dart';
import 'package:strucreport/widget/app_switch_widget.dart';
import 'package:strucreport/widget/single_line_input.dart';

class GeneralInfoScreen extends StatefulWidget {
  @override
  _GeneralInfoScreenState createState() => _GeneralInfoScreenState();
}

class _GeneralInfoScreenState extends State<GeneralInfoScreen> {
  EditorBloc bloc;
  bool _anyChimneyStacks;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<EditorBloc>(context);
    _anyChimneyStacks = PreferenceHelper.getBool(Params.anyChimneyStacks);
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
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 8,
                          width: double.infinity,
                        ),
                        SingleLineInput(
                          label: "Name of client:",
                          prefKey: Params.clientName,
                        ),
                        SingleLineInput(
                          label: "Project number:",
                          prefKey: Params.projectNumber,
                        ),
                        SingleLineInput(
                          label: "Address:",
                          prefKey: Params.address,
                        ),
                        AppDatePicker(
                          label: "Date: ",
                          prefKey: Params.inspectedDate,
                        ),
                        AppDropdownWidget(
                          label: "Inspected by: ",
                          prefKey: Params.inspectedBy,
                          values: Application.Employees,
                        ),
                        AppDropdownWidget(
                          label: "Type of inspection: ",
                          prefKey: Params.inspectionType,
                          values: Application.InspectionType,
                        ),
                        AppCommentWidget(
                          prefKey: Params.inspectionTypeComment,
                        ),
                        AppCommentWidget(
                          label: "Client's Brief: ",
                          prefKey: Params.clientBrief,
                        ),
                        AppDropdownWidget(
                          label: "Type of property: ",
                          prefKey: Params.propertyType,
                          values: Application.PropertyType,
                        ),
                        AppCommentWidget(
                          prefKey: Params.propertyTypeComment,
                        ),
                        AppDropdownWidget(
                          label: "Present at site: ",
                          prefKey: Params.presentAtSite,
                          values: Application.PresentAtSite,
                        ),
                        AppCommentWidget(
                          prefKey: Params.presentAtSiteComment,
                        ),
                        AppCommentWidget(
                          label: "Person at site comments: ",
                          prefKey: Params.personAtSiteComment,
                        ),
                        AppCommentWidget(
                          label: "Estimated construction decade: ",
                          prefKey: Params.estimatedConstructionDecade,
                        ),
                        AppDropdownWidget(
                          label: "External walls construction: ",
                          prefKey: Params.externalWallsConstruction,
                          values: Application.ExternalWallsConstruction,
                        ),
                        AppCommentWidget(
                          prefKey: Params.externalWallsConstructionComment,
                        ),
                        AppDropdownWidget(
                          label: "What is covering of roof: ",
                          prefKey: Params.coverOfRoof,
                          values: Application.CoverOfRoor,
                        ),
                        AppCommentWidget(
                          prefKey: Params.coverOfRoofComment,
                        ),
                        AppDropdownWidget(
                          label: "How many rooms/bedrooms: ",
                          prefKey: Params.roomNumber,
                          values: Application.NumberOfRooms,
                        ),
                        AppCommentWidget(
                          prefKey: Params.roomNumberComment,
                        ),
                        AppDropdownWidget(
                          label: "Weather: ",
                          prefKey: Params.weather,
                          values: Application.Weather,
                        ),
                        AppCommentWidget(
                          prefKey: Params.weatherComment,
                        ),
                        AppCommentWidget(
                          label: "Is the property on a hill, slope, any trees in proximity?: ",
                          prefKey: Params.propertyOnHillComment,
                        ),
                        AppSwitchWidget(
                          label: "Any chimney stacks?",
                          prefKey: Params.anyChimneyStacks,
                          onChange: (val) {
                            setState(() {
                              _anyChimneyStacks = val;
                            });
                          },
                        ),
                        _anyChimneyStacks
                            ? AppSwitchWidget(
                                label: "Do chimney stacks require maintenance?",
                                prefKey: Params.chimneyMaintenance,
                              )
                            : Container(),
                        _anyChimneyStacks
                            ? AppCommentWidget(
                                prefKey: Params.chimneyMaintenanceComment,
                              )
                            : Container(),
                        AppSwitchWidget(
                          label: "Are internal walls covered in plaster?",
                          prefKey: Params.internalWallsCovered,
                        ),
                        AppCommentWidget(
                          prefKey: Params.internalWallsCoveredComment,
                        ),
                        AppSwitchWidget(
                          label: "Have you observed any dislodged tiles/slates?",
                          prefKey: Params.observedDislodged,
                        ),
                        AppCommentWidget(
                          prefKey: Params.observedDislodgedComment,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeumorphicButton(
              onPressed: () {
                gotoNext();
              },
              style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle(), shape: NeumorphicShape.concave),
              child: Icon(
                Icons.arrow_right,
                size: Application.IconSize,
                color: NeumorphicTheme.defaultTextColor(context),
              ),
            )
          ],
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
  }

  void gotoNext() {
    if (PreferenceHelper.getString(Params.projectNumber).isEmpty) {
      ToastUtils.showErrorToast(context, "Project number is required");
    } else {
      bloc.add(EditorGeneralNextEvent());
    }
  }
}
