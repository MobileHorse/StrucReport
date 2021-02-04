import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strucreport/bloc/bloc.dart';
import 'package:strucreport/config/application.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/model/report_model.dart';
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
  bool observedAnyInternalCracksSmaller3mm,
      observedAnyInternalCracksLager3mm,
      observedAnyInternalCracksLager10mm,
      observedDefectiveMortarJoints,
      observedDefectiveBricks,
      observedAnyCracksAboveLintels,
      belowAverageGroundFloor,
      observedDrainagePavement,
      belowAverageFirstFloor,
      observedBayWindowMovement,
      observedJunctionMovement,
      roofSagging,
      inspectedAllRooms,
      recordedVideo,
      observedActiveMovement,
      externalElevations;

  TextEditingController observedAnyInternalCracksSmaller3mmCommentController,
      observedAnyInternalCracksLager3mmCommentController,
      observedAnyInternalCracksLager10mmCommentController,
      observedDefectiveMortarJointsCommentController,
      observedDefectiveBricksCommentController,
      lintelTypeCommentController,
      observedAnyCracksAboveLintelsCommentController,
      constructionOfFloorsOnGroundFloorCommentController,
      belowAverageGroundFloorCommentController,
      observedDrainagePavementCommentController,
      constructionOfFloorsOnFirstFloorCommentController,
      belowAverageFirstFloorCommentController,
      internalFaceGableWallCommentController,
      observedBayWindowMovementCommentController,
      observedJunctionMovementCommentController,
      roofSaggingCommentController,
      inspectedAllRoomsCommentController,
      recordedVideoCommentController,
      observedActiveMovementCommentController,
      otherInformationController;

  String lintelType,
      constructionOfFloorsOnGroundFloor,
      constructionOfFloorsOnFirstFloor,
      internalFaceGableWall;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<EditorBloc>(context);
    EditorExtraState state = bloc.state;
    ReportModel report = state.report;

    observedAnyInternalCracksSmaller3mm =
        report.observedAnyInternalCracksSmaller3mm;
    observedAnyInternalCracksSmaller3mmCommentController =
        TextEditingController();
    observedAnyInternalCracksSmaller3mmCommentController.text =
        report.observedAnyInternalCracksSmaller3mmComment;

    observedAnyInternalCracksLager3mm =
        report.observedAnyInternalCracksLager3mm;
    observedAnyInternalCracksLager3mmCommentController =
        TextEditingController();
    observedAnyInternalCracksLager3mmCommentController.text =
        report.observedAnyInternalCracksLager3mmComment;

    observedAnyInternalCracksLager10mm =
        report.observedAnyInternalCracksLager10mm;
    observedAnyInternalCracksLager10mmCommentController =
        TextEditingController();
    observedAnyInternalCracksLager10mmCommentController.text =
        report.observedAnyInternalCracksLager10mmComment;

    observedDefectiveMortarJoints = report.observedDefectiveMortarJoints;
    observedDefectiveMortarJointsCommentController = TextEditingController();
    observedDefectiveMortarJointsCommentController.text =
        report.observedDefectiveMortarJointsComment;

    observedDefectiveBricks = report.observedDefectiveBricks;
    observedDefectiveBricksCommentController = TextEditingController();
    observedDefectiveBricksCommentController.text =
        report.observedDefectiveBricksComment;

    lintelType = report.lintelType;
    lintelTypeCommentController = TextEditingController();
    lintelTypeCommentController.text = report.lintelTypeComment;

    observedAnyCracksAboveLintels = report.observedAnyCracksAboveLintels;
    observedAnyCracksAboveLintelsCommentController = TextEditingController();
    observedAnyCracksAboveLintelsCommentController.text =
        report.observedAnyCracksAboveLintelsComment;

    constructionOfFloorsOnGroundFloor =
        report.constructionOfFloorsOnGroundFloor;
    constructionOfFloorsOnGroundFloorCommentController =
        TextEditingController();
    constructionOfFloorsOnGroundFloorCommentController.text =
        report.constructionOfFloorsOnGroundFloorComment;

    belowAverageGroundFloor =
        report.belowAverageGroundFloor;
    belowAverageGroundFloorCommentController =
        TextEditingController();
    belowAverageGroundFloorCommentController.text =
        report.belowAverageFirstFloorComment;

    observedDrainagePavement =
        report.observedDrainagePavement;
    observedDrainagePavementCommentController =
        TextEditingController();
    observedDrainagePavementCommentController.text =
        report.observedDrainagePavementComment;

    constructionOfFloorsOnFirstFloor = report.constructionOfFloorsOnFirstFloor;
    constructionOfFloorsOnFirstFloorCommentController = TextEditingController();
    constructionOfFloorsOnFirstFloorCommentController.text = report.constructionOfFloorsOnFirstFloorComment;

    belowAverageFirstFloor = report.belowAverageFirstFloor;
    belowAverageFirstFloorCommentController = TextEditingController();
    belowAverageFirstFloorCommentController.text = report.belowAverageFirstFloorComment;

    internalFaceGableWall = report.internalFaceGableWall;
    internalFaceGableWallCommentController = TextEditingController();
    internalFaceGableWallCommentController.text = report.internalFaceGableWallComment;

    observedBayWindowMovement = report.observedBayWindowMovement;
    observedBayWindowMovementCommentController = TextEditingController();
    observedBayWindowMovementCommentController.text = report.observedBayWindowMovementComment;

    observedJunctionMovement = report.observedJunctionMovement;
    observedJunctionMovementCommentController = TextEditingController();
    observedJunctionMovementCommentController.text = report.observedJunctionMovementComment;

    roofSagging = report.roofSagging;
    roofSaggingCommentController = TextEditingController();
    roofSaggingCommentController.text = report.roofSaggingComment;

    inspectedAllRooms = report.inspectedAllRooms;
    inspectedAllRoomsCommentController = TextEditingController();
    inspectedAllRoomsCommentController.text = report.inspectedAllRoomsComment;

    recordedVideo = report.recordedVideo;
    recordedVideoCommentController = TextEditingController();
    recordedVideoCommentController.text = report.recordedVideoComment;

    observedActiveMovement = report.observedActiveMovement;
    observedActiveMovementCommentController = TextEditingController();
    observedActiveMovementCommentController.text = report.observedActiveMovementComment;

    externalElevations = report.externalElevations;

    otherInformationController = TextEditingController();
    otherInformationController.text = report.otherInformation;
  }

  @override
  void dispose() {
    observedAnyInternalCracksSmaller3mmCommentController.dispose();
    observedAnyInternalCracksLager3mmCommentController.dispose();
    observedAnyInternalCracksLager10mmCommentController.dispose();
    observedDefectiveMortarJointsCommentController.dispose();
    observedDefectiveBricksCommentController.dispose();
    lintelTypeCommentController.dispose();
    observedAnyCracksAboveLintelsCommentController.dispose();
    constructionOfFloorsOnGroundFloorCommentController.dispose();
    belowAverageGroundFloorCommentController.dispose();
    observedDrainagePavementCommentController.dispose();
    constructionOfFloorsOnFirstFloorCommentController.dispose();
    belowAverageFirstFloorCommentController.dispose();
    internalFaceGableWallCommentController.dispose();
    observedBayWindowMovementCommentController.dispose();
    observedJunctionMovementCommentController.dispose();
    roofSaggingCommentController.dispose();
    inspectedAllRoomsCommentController.dispose();
    recordedVideoCommentController.dispose();
    observedActiveMovementCommentController.dispose();
    otherInformationController.dispose();
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
                        ...buildSwitchCommentWidget(
                            label:
                                "Have you observed any internal cracks 0-3mm?",
                            value: observedAnyInternalCracksSmaller3mm,
                            controller:
                                observedAnyInternalCracksSmaller3mmCommentController,
                            onChange: (val) => setState(() {
                                  observedAnyInternalCracksSmaller3mm = val;
                                })),
                        ...buildSwitchCommentWidget(
                            label:
                                "Have you observed any cracks larger than 3mm?",
                            value: observedAnyInternalCracksLager3mm,
                            controller:
                                observedAnyInternalCracksLager3mmCommentController,
                            onChange: (val) => setState(() {
                                  observedAnyInternalCracksLager3mm = val;
                                })),
                        ...buildSwitchCommentWidget(
                            label:
                                "Have you observed any cracks larger than 10mm?",
                            value: observedAnyInternalCracksLager10mm,
                            controller:
                                observedAnyInternalCracksLager10mmCommentController,
                            onChange: (val) => setState(() {
                                  observedAnyInternalCracksLager10mm = val;
                                })),
                        ...buildSwitchCommentWidget(
                            label:
                                "Have you observed defective/cracked mortar joints?",
                            value: observedDefectiveMortarJoints,
                            controller:
                                observedDefectiveMortarJointsCommentController,
                            onChange: (val) => setState(() {
                                  observedDefectiveMortarJoints = val;
                                })),
                        ...buildSwitchCommentWidget(
                            label:
                                "Have you observed defective bricks (weathered, cracked, loose, etc)?",
                            value: observedDefectiveBricks,
                            controller:
                                observedDefectiveBricksCommentController,
                            onChange: (val) => setState(() {
                                  observedDefectiveBricks = val;
                                })),
                        ...buildDropdownCommentWidget(
                            label: "Type of lintels?",
                            initial: lintelType,
                            values: Application.LintelTypes,
                            controller: lintelTypeCommentController,
                            onChange: (val) => setState(() {
                                  lintelType = val;
                                })),
                        ...buildSwitchCommentWidget(
                            label:
                                "Have you observed any cracks above lintels?",
                            value: observedAnyCracksAboveLintels,
                            controller:
                                observedAnyCracksAboveLintelsCommentController,
                            onChange: (val) => setState(() {
                                  observedAnyCracksAboveLintels = val;
                                })),
                        ...buildDropdownCommentWidget(
                            label: "What is the construction of floors on ground floor?",
                            initial: constructionOfFloorsOnGroundFloor,
                            values: Application.FloorConstructions,
                            controller: constructionOfFloorsOnGroundFloorCommentController,
                            onChange: (val) => setState(() {
                              constructionOfFloorsOnGroundFloor = val;
                            })),
                        ...buildSwitchCommentWidget(
                            label:
                            "On ground floor, are floors in below average condition considering the age of the property - uneven/sagging?",
                            value: belowAverageGroundFloor,
                            controller:
                            belowAverageGroundFloorCommentController,
                            onChange: (val) => setState(() {
                              belowAverageGroundFloor = val;
                            })),
                        ...buildSwitchCommentWidget(
                            label:
                            "Have you observed any drainage and/or uneven pavement in vicinity of uneven ground floor or wall cracks?",
                            value: observedDrainagePavement,
                            controller:
                            observedDrainagePavementCommentController,
                            onChange: (val) => setState(() {
                              observedDrainagePavement = val;
                            })),
                        ...buildDropdownCommentWidget(
                            label: "What is the construction of floors on  first floor?",
                            initial: constructionOfFloorsOnFirstFloor,
                            values: Application.FirstFloorConstructions,
                            controller: constructionOfFloorsOnFirstFloorCommentController,
                            onChange: (val) => setState(() {
                              constructionOfFloorsOnFirstFloor = val;
                            })),
                        ...buildSwitchCommentWidget(
                            label:
                            "On the first floor, are the floors in below average considering the age of the property - uneven/sagging?",
                            value: belowAverageFirstFloor,
                            controller:
                            belowAverageFirstFloorCommentController,
                            onChange: (val) => setState(() {
                              belowAverageFirstFloor = val;
                            })),
                        ...buildDropdownCommentWidget(
                            label: "Based on the internal face of gable wall and/or external elevations, what is the type of construction?",
                            initial: internalFaceGableWall,
                            values: Application.GableWallConstructions,
                            controller: internalFaceGableWallCommentController,
                            onChange: (val) => setState(() {
                              internalFaceGableWall = val;
                            })),
                        ...buildSwitchCommentWidget(
                            label:
                            "Have you observed any movement of bay window?",
                            value: observedBayWindowMovement,
                            controller:
                            observedBayWindowMovementCommentController,
                            onChange: (val) => setState(() {
                              observedBayWindowMovement = val;
                            })),
                        ...buildSwitchCommentWidget(
                            label:
                            "Have you observed any movement at junction of an extension/porch and the original building?",
                            value: observedJunctionMovement,
                            controller:
                            observedJunctionMovementCommentController,
                            onChange: (val) => setState(() {
                              observedJunctionMovement = val;
                            })),
                        ...buildSwitchCommentWidget(
                            label:
                            "Is the roof sagging?",
                            value: roofSagging,
                            controller:
                            roofSaggingCommentController,
                            onChange: (val) => setState(() {
                              roofSagging = val;
                            })),
                        ...buildSwitchCommentWidget(
                            label:
                            "Have you inspected all rooms, including garage, roof space and all accessible areas?",
                            value: inspectedAllRooms,
                            controller:
                            inspectedAllRoomsCommentController,
                            onChange: (val) => setState(() {
                              inspectedAllRooms = val;
                            })),
                        ...buildSwitchCommentWidget(
                            label:
                            "Have you recorded 1min video, taken overview and close-up photos of all defects observed?",
                            value: recordedVideo,
                            controller:
                            recordedVideoCommentController,
                            onChange: (val) => setState(() {
                              recordedVideo = val;
                            })),
                        ...buildSwitchCommentWidget(
                            label:
                            "Have you observed any active movement?",
                            value: observedActiveMovement,
                            controller:
                            observedActiveMovementCommentController,
                            onChange: (val) => setState(() {
                              observedActiveMovement = val;
                            })),
                        SwitchWidget(
                          label: "Are external elevations in an acceptable condition considering the age of the property?",
                          value: externalElevations,
                          onChange: (val) => setState(() {
                            externalElevations = val;
                          }),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: LabelWidget(label: "Input any other information/comments:",),
                        ),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.only(left: 160),
                          child: TextFieldMultilineWidget(
                            controller: otherInformationController,
                            hint: "",
                          ),
                        )
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
    report.observedAnyInternalCracksSmaller3mm = observedAnyInternalCracksSmaller3mm;
    report.observedAnyInternalCracksLager3mm = observedAnyInternalCracksLager3mm;
    report.observedAnyInternalCracksLager10mm = observedAnyInternalCracksLager10mm;
    report.observedDefectiveMortarJoints = observedDefectiveMortarJoints;
    report.observedDefectiveBricks = observedDefectiveBricks;
    report.observedAnyCracksAboveLintels = observedAnyCracksAboveLintels;
    report.belowAverageGroundFloor = belowAverageGroundFloor;
    report.observedDrainagePavement = observedDrainagePavement;
    report.belowAverageFirstFloor = belowAverageFirstFloor;
    report.observedBayWindowMovement = observedBayWindowMovement;
    report.observedJunctionMovement = observedJunctionMovement;
    report.roofSagging = roofSagging;
    report.inspectedAllRooms = inspectedAllRooms;
    report.recordedVideo = recordedVideo;
    report.observedActiveMovement = observedActiveMovement;
    report.externalElevations = externalElevations;
    report.lintelType = lintelType;
    report.constructionOfFloorsOnGroundFloor = constructionOfFloorsOnGroundFloor;
    report.constructionOfFloorsOnFirstFloor = constructionOfFloorsOnFirstFloor;
    report.internalFaceGableWall = internalFaceGableWall;
    report.observedAnyInternalCracksSmaller3mmComment = observedAnyInternalCracksSmaller3mmCommentController.text;
    report.observedAnyInternalCracksLager3mmComment = observedAnyInternalCracksLager3mmCommentController.text;
    report.observedAnyInternalCracksLager10mmComment = observedAnyInternalCracksLager10mmCommentController.text;
    report.observedDefectiveMortarJointsComment = observedDefectiveMortarJointsCommentController.text;
    report.observedDefectiveBricksComment = observedDefectiveBricksCommentController.text;
    report.lintelTypeComment = lintelTypeCommentController.text;
    report.observedAnyCracksAboveLintelsComment = observedAnyCracksAboveLintelsCommentController.text;
    report.belowAverageGroundFloorComment = belowAverageGroundFloorCommentController.text;
    report.observedDrainagePavementComment = observedDrainagePavementCommentController.text;
    report.constructionOfFloorsOnFirstFloorComment = constructionOfFloorsOnFirstFloorCommentController.text;
    report.belowAverageFirstFloorComment = belowAverageFirstFloorCommentController.text;
    report.internalFaceGableWallComment = internalFaceGableWallCommentController.text;
    report.observedBayWindowMovementComment = observedBayWindowMovementCommentController.text;
    report.observedJunctionMovementComment = observedJunctionMovementCommentController.text;
    report.roofSaggingComment = roofSaggingCommentController.text;
    report.inspectedAllRoomsComment = inspectedAllRoomsCommentController.text;
    report.recordedVideoComment = recordedVideoCommentController.text;
    report.observedActiveMovementComment = observedActiveMovementCommentController.text;
    report.otherInformation = otherInformationController.text;
    return report;
  }

  List<Widget> buildSwitchCommentWidget(
      {String label,
      bool value,
      TextEditingController controller,
      String hint = "Comments",
      Function(bool) onChange}) {
    List<Widget> widgets = [];
    widgets.add(SwitchWidget(
      label: label,
      value: value,
      onChange: (val) => onChange(val),
    ));
    widgets.add(SizedBox(
      height: 5,
    ));
    widgets.add(Padding(
      padding: const EdgeInsets.only(left: 160),
      child: TextFieldMultilineWidget(
        controller: controller,
        hint: hint,
      ),
    ));
    widgets.add(SizedBox(
      height: 20,
    ));
    return widgets;
  }

  List<Widget> buildDropdownCommentWidget(
      {String label,
      String initial,
      List<String> values,
      TextEditingController controller,
      String hint = "Comments",
      Function(String) onChange}) {
    List<Widget> widgets = [];
    widgets.add(DropdownWidget(
      label: label,
      initial: initial,
      values: values,
      onChange: (val) => onChange(val),
    ));
    widgets.add(SizedBox(
      height: 5,
    ));
    widgets.add(Padding(
      padding: const EdgeInsets.only(left: 160),
      child: TextFieldMultilineWidget(
        controller: controller,
        hint: hint,
      ),
    ));
    widgets.add(SizedBox(
      height: 20,
    ));
    return widgets;
  }
}
