import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strucreport/bloc/bloc.dart';
import 'package:strucreport/config/application.dart';
import 'package:strucreport/config/params.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/model/report_model.dart';
import 'package:strucreport/widget/app_comment_widget.dart';
import 'package:strucreport/widget/app_dropdown_comment_widget.dart';
import 'package:strucreport/widget/app_switch_comment_widget.dart';
import 'package:strucreport/widget/app_switch_widget.dart';
import 'package:strucreport/widget/dropdown_widget.dart';
import 'package:strucreport/widget/label_widget.dart';
import 'package:strucreport/widget/switch_widget.dart';
import 'package:strucreport/widget/text_field_multiline_widget.dart';

class ExtraInfoScreen extends StatefulWidget {
  @override
  _ExtraInfoScreenState createState() => _ExtraInfoScreenState();
}

class _ExtraInfoScreenState extends State<ExtraInfoScreen> {
  EditorBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<EditorBloc>(context);
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
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 8,
                          width: double.infinity,
                        ),
                        AppSwitchCommentWidget(
                          label: "Have you observed any internal cracks 0-3mm?",
                          prefKeySwitch: Params.observedAnyInternalCracksSmaller3mm,
                          prefKeyComment: Params.observedAnyInternalCracksSmaller3mmComment,
                        ),
                        AppSwitchCommentWidget(
                          label: "Have you observed any cracks larger than 3mm?",
                          prefKeySwitch: Params.observedAnyInternalCracksLager3mm,
                          prefKeyComment: Params.observedAnyInternalCracksLager3mmComment,
                        ),
                        AppSwitchCommentWidget(
                          label: "Have you observed any cracks larger than 10mm?",
                          prefKeySwitch: Params.observedAnyInternalCracksLager10mm,
                          prefKeyComment: Params.observedAnyInternalCracksLager10mmComment,
                        ),
                        AppSwitchCommentWidget(
                          label: "Have you observed defective/cracked mortar joints?",
                          prefKeySwitch: Params.observedDefectiveMortarJoints,
                          prefKeyComment: Params.observedDefectiveMortarJointsComment,
                        ),
                        AppSwitchCommentWidget(
                          label: "Have you observed defective bricks (weathered, cracked, loose, etc)?",
                          prefKeySwitch: Params.observedDefectiveBricks,
                          prefKeyComment: Params.observedDefectiveBricksComment,
                        ),
                        AppDropdownCommentWidget(
                          label: "Type of lintels?",
                          values: Application.LintelTypes,
                          prefKeyDropdown: Params.lintelType,
                          prefKeyComment: Params.lintelTypeComment,
                        ),
                        AppSwitchCommentWidget(
                          label: "Have you observed any cracks above lintels?",
                          prefKeySwitch: Params.observedAnyCracksAboveLintels,
                          prefKeyComment: Params.observedAnyCracksAboveLintelsComment,
                        ),
                        AppDropdownCommentWidget(
                          label: "What is the construction of floors on ground floor?",
                          values: Application.FloorConstructions,
                          prefKeyDropdown: Params.constructionOfFloorsOnGroundFloor,
                          prefKeyComment: Params.constructionOfFloorsOnGroundFloorComment,
                        ),
                        AppSwitchCommentWidget(
                          label: "On ground floor, are floors in below average condition considering the age of the property - uneven/sagging?",
                          prefKeySwitch: Params.belowAverageGroundFloor,
                          prefKeyComment: Params.belowAverageGroundFloorComment,
                        ),
                        AppSwitchCommentWidget(
                          label: "Have you observed any drainage and/or uneven pavement in vicinity of uneven ground floor or wall cracks?",
                          prefKeySwitch: Params.observedDrainagePavement,
                          prefKeyComment: Params.observedDrainagePavementComment,
                        ),
                        AppDropdownCommentWidget(
                          label: "What is the construction of floors on  first floor?",
                          values: Application.FirstFloorConstructions,
                          prefKeyDropdown: Params.constructionOfFloorsOnFirstFloor,
                          prefKeyComment: Params.constructionOfFloorsOnFirstFloorComment,
                        ),
                        AppSwitchCommentWidget(
                          label: "On the first floor, are the floors in below average considering the age of the property - uneven/sagging?",
                          prefKeySwitch: Params.belowAverageFirstFloor,
                          prefKeyComment: Params.belowAverageFirstFloorComment,
                        ),
                        AppDropdownCommentWidget(
                          label: "Based on the internal face of gable wall and/or external elevations, what is the type of construction?",
                          values: Application.GableWallConstructions,
                          prefKeyDropdown: Params.internalFaceGableWall,
                          prefKeyComment: Params.internalFaceGableWallComment,
                        ),
                        AppSwitchCommentWidget(
                          label: "Have you observed any movement of bay window?",
                          prefKeySwitch: Params.observedBayWindowMovement,
                          prefKeyComment: Params.observedBayWindowMovementComment,
                        ),
                        AppSwitchCommentWidget(
                          label: "Have you observed any movement at junction of an extension/porch and the original building?",
                          prefKeySwitch: Params.observedJunctionMovement,
                          prefKeyComment: Params.observedJunctionMovementComment,
                        ),
                        AppSwitchCommentWidget(
                          label: "Is the roof sagging?",
                          prefKeySwitch: Params.roofSagging,
                          prefKeyComment: Params.roofSaggingComment,
                        ),
                        AppSwitchCommentWidget(
                          label: "Have you inspected all rooms, including garage, roof space and all accessible areas?",
                          prefKeySwitch: Params.inspectedAllRooms,
                          prefKeyComment: Params.inspectedAllRoomsComment,
                        ),
                        AppSwitchCommentWidget(
                          label: "Have you recorded 1min video, taken overview and close-up photos of all defects observed?",
                          prefKeySwitch: Params.recordedVideo,
                          prefKeyComment: Params.recordedVideoComment,
                        ),
                        AppSwitchCommentWidget(
                          label: "Have you observed any active movement?",
                          prefKeySwitch: Params.observedActiveMovement,
                          prefKeyComment: Params.observedActiveMovementComment,
                        ),
                        AppSwitchWidget(
                          label: "Are external elevations in an acceptable condition considering the age of the property?",
                          prefKey: Params.externalElevations,
                        ),
                        AppCommentWidget(
                          label: "Input any other information/comments:",
                          prefKey: Params.otherInformation,
                        ),
                      ],
                    ),
                  ),
                )
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
                gotoPrev();
              },
              style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.circle(),
                  shape: NeumorphicShape.concave),
              child: Icon(
                Icons.arrow_left,
                size: Application.IconSize,
                color: NeumorphicTheme.defaultTextColor(context),
              ),
            ),
            SizedBox(
              width: 60,
            ),
            NeumorphicButton(
              onPressed: () {
                gotoNext();
              },
              style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.circle(),
                  shape: NeumorphicShape.concave),
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
    bloc.add(EditorExtraNextEvent(report: updateReport()));
  }

  void gotoPrev() {
    bloc.add(EditorPrevEvent(report: updateReport()));
  }

  ReportModel updateReport() {
    EditorExtraState state = bloc.state;
    ReportModel report = state.report;
    return report;
  }
}
