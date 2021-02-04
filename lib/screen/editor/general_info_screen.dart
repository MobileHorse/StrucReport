import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strucreport/bloc/bloc.dart';
import 'package:strucreport/config/application.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/model/report_model.dart';
import 'package:strucreport/widget/comment_widget.dart';
import 'package:strucreport/widget/dropdown_widget.dart';
import 'package:strucreport/widget/label_widget.dart';
import 'package:strucreport/widget/switch_widget.dart';
import 'package:strucreport/widget/text_content_widget.dart';
import 'package:strucreport/widget/text_field.dart';
import 'package:strucreport/widget/text_field_multiline_widget.dart';

class GeneralInfoScreen extends StatefulWidget {
  @override
  _GeneralInfoScreenState createState() => _GeneralInfoScreenState();
}

class _GeneralInfoScreenState extends State<GeneralInfoScreen> {
  EditorBloc bloc;
  TextEditingController _clientNameController,
      _projectNumberController,
      _addressController,
      _clientBriefController,
      _propertyTypeCommentController,
      _presentAtSiteCommentController,
      _personAtSiteCommentController,
      _estimatedConstructionDecadeController,
      _externalWallsConstructionController,
      _roomNumberCommentController,
      _weatherCommentController,
      _propertyOnHillCommentController,
      _chimneyMaintenanceCommentController;
  DateTime _selectedDate;
  String _inspectedBy,
      _inspectionType,
      _clientBrief,
      _propertyType,
      _presentAtSite,
      _externalWallsConstruction,
      _coverOfRoof,
      _roomNumber,
      _weather,
      _observedDislodgedText;
  bool _anyChimneyStacks,
      _chimneyMaintenance,
      _internalWallsCovered,
      _observedDislodged;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<EditorBloc>(context);
    EditorGeneralInfoState state = bloc.state;
    ReportModel report = state.report;
    _clientNameController = TextEditingController();
    _clientNameController.text = report.clientName;
    _projectNumberController = TextEditingController();
    _projectNumberController.text = report.projectNumber;
    _addressController = TextEditingController();
    _addressController.text = report.address;
    _selectedDate = report.inspectDate ?? DateTime.now();
    _inspectedBy = report.inspectedBy;
    _inspectionType = report.inspectionType;
    _clientBriefController = TextEditingController();
    _clientBriefController.text = report.clientBrief;
    _clientBrief = report.clientBrief;
    _propertyType = report.propertyType;
    _propertyTypeCommentController = TextEditingController();
    _propertyTypeCommentController.text = report.propertyTypeComment;
    _presentAtSite = report.presentAtSite;
    _presentAtSiteCommentController = TextEditingController();
    _presentAtSiteCommentController.text = report.presentAtSiteComment;
    _personAtSiteCommentController = TextEditingController();
    _personAtSiteCommentController.text = report.personAtSiteComment;
    _estimatedConstructionDecadeController = TextEditingController();
    _estimatedConstructionDecadeController.text = report.estimatedConstructionDecadeComment;
    _externalWallsConstruction = report.externalWallsConstruction;
    _externalWallsConstructionController = TextEditingController();
    _externalWallsConstructionController.text = report.externalWallsConstructionComment;
    _coverOfRoof = report.roofCovering;
    _roomNumber = report.roomNumber;
    _roomNumberCommentController = TextEditingController();
    _roomNumberCommentController.text = report.roomNumberComment;
    _weather = report.weather;
    _weatherCommentController = TextEditingController();
    _weatherCommentController.text = report.weatherComment;
    _propertyOnHillCommentController = TextEditingController();
    _propertyOnHillCommentController.text = report.propertyOnHillComment;
    _anyChimneyStacks = report.anyChimneyStacks;
    _chimneyMaintenance = report.chimneyStacksRequireMaintenance;
    _chimneyMaintenanceCommentController = TextEditingController();
    _chimneyMaintenanceCommentController.text = report.chimneyStacksRequireMaintenanceComment;
    _internalWallsCovered = report.internalWallsCoveredInPlaster;
    _observedDislodged = report.observedAnyDislodgedTiles;
    _observedDislodgedText = report.observedAnyDislodgedTilesComment;
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _projectNumberController.dispose();
    _addressController.dispose();
    _clientBriefController.dispose();
    _propertyTypeCommentController.dispose();
    _presentAtSiteCommentController.dispose();
    _personAtSiteCommentController.dispose();
    _estimatedConstructionDecadeController.dispose();
    _externalWallsConstructionController.dispose();
    _roomNumberCommentController.dispose();
    _weatherCommentController.dispose();
    _propertyOnHillCommentController.dispose();
    _chimneyMaintenanceCommentController.dispose();
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
                        TextFieldWidget(
                          label: "Name of client:",
                          hint: "",
                          controller: _clientNameController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFieldWidget(
                          label: "Project number:",
                          hint: "",
                          controller: _projectNumberController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFieldWidget(
                          label: "Address:",
                          hint: "",
                          controller: _addressController,
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
                            LabelWidget(label: "Date: "),
                            SizedBox(
                              width: 20,
                            ),
                            NeumorphicButton(
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex),
                              child: TextContentWidget(
                                text:
                                    "${_selectedDate.toLocal()}".split(' ')[0],
                              ),
                              onPressed: () => _selectDate(context),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownWidget(
                          label: "Inspected by: ",
                          initial: _inspectedBy,
                          values: Application.Employees,
                          onChange: (val) {
                            setState(() {
                              _inspectedBy = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownWidget(
                          label: "Type of inspection: ",
                          initial: _inspectionType,
                          values: Application.InspectionType,
                          onChange: (val) {
                            setState(() {
                              _inspectionType = val;
                              _clientBrief = val.contains("GSI")
                                  ? "The purpose of this report is to provide the client with information regarding the structural condition of the building"
                                  : "";
                              _clientBriefController.text = _clientBrief;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            LabelWidget(
                              label: "Client's brief: ",
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            _inspectionType.contains("GSI")
                                ? Flexible(
                                    child: TextContentWidget(
                                      text: _clientBrief,
                                    ),
                                  )
                                : Expanded(
                                    child: TextFieldMultilineWidget(
                                      controller: _clientBriefController,
                                      hint: "Description",
                                    ),
                                  )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownWidget(
                          label: "Type of property: ",
                          initial: _propertyType,
                          values: Application.PropertyType,
                          onChange: (val) {
                            setState(() {
                              _propertyType = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 160),
                          child: TextFieldMultilineWidget(
                            controller: _propertyTypeCommentController,
                            hint: "Comments",
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownWidget(
                          label: "Present at site: ",
                          initial: _presentAtSite,
                          values: Application.PresentAtSite,
                          onChange: (val) {
                            setState(() {
                              _presentAtSite = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 160),
                          child: TextFieldMultilineWidget(
                            controller: _presentAtSiteCommentController,
                            hint: "Comments",
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CommentWidget(
                          label: "Person at site comments: ",
                          controller: _personAtSiteCommentController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CommentWidget(
                          label: "Estimated construction decade: ",
                          controller: _estimatedConstructionDecadeController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownWidget(
                          label: "External walls construction: ",
                          initial: _externalWallsConstruction,
                          values: Application.ExternalWallsConstruction,
                          onChange: (val) {
                            setState(() {
                              _externalWallsConstruction = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 160),
                          child: TextFieldMultilineWidget(
                            controller: _externalWallsConstructionController,
                            hint: "Comments",
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownWidget(
                          label: "What is covering of roof: ",
                          initial: _coverOfRoof,
                          values: Application.CoverOfRoor,
                          onChange: (val) {
                            setState(() {
                              _coverOfRoof = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownWidget(
                          label: "How many rooms/bedrooms: ",
                          initial: _roomNumber,
                          values: Application.NumberOfRooms,
                          onChange: (val) {
                            setState(() {
                              _roomNumber = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 160),
                          child: TextFieldMultilineWidget(
                            controller: _roomNumberCommentController,
                            hint: "Comments",
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownWidget(
                          label: "Weather: ",
                          initial: _weather,
                          values: Application.Weather,
                          onChange: (val) {
                            setState(() {
                              _weather = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 160),
                          child: TextFieldMultilineWidget(
                            controller: _weatherCommentController,
                            hint: "Comments",
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CommentWidget(
                          label:
                              "Is the property on a hill, slope, any trees in proximity?: ",
                          controller: _propertyOnHillCommentController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SwitchWidget(
                          label: "Any chimney stacks?",
                          value: _anyChimneyStacks,
                          onChange: (val) {
                            setState(() {
                              _anyChimneyStacks = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: _anyChimneyStacks ? 20 : 0,
                        ),
                        _anyChimneyStacks
                            ? SwitchWidget(
                                label: "Do chimney stacks require maintenance?",
                                value: _chimneyMaintenance,
                                onChange: (val) {
                                  setState(() {
                                    _chimneyMaintenance = val;
                                  });
                                },
                              )
                            : Container(),
                        SizedBox(
                          height: _anyChimneyStacks ? 5 : 0,
                        ),
                        _anyChimneyStacks
                            ? Padding(
                                padding: const EdgeInsets.only(left: 160),
                                child: TextFieldMultilineWidget(
                                  controller:
                                      _chimneyMaintenanceCommentController,
                                  hint: "Comments",
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 20,
                        ),
                        SwitchWidget(
                          label: "Are internal walls covered in plaster?",
                          value: _internalWallsCovered,
                          onChange: (val) {
                            setState(() {
                              _internalWallsCovered = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SwitchWidget(
                          label:
                              "Have you observed any dislodged tiles/slates?",
                          value: _observedDislodged,
                          onChange: (val) {
                            setState(() {
                              _observedDislodged = val;
                              _observedDislodgedText = _observedDislodged
                                  ? "Some dislodged tiles/slates were observed, and maintenance repairs are required, a roofing contractor should be consulted for further advice."
                                  : "There did not appear to be any significantly dislodged tiles/slates, but periodic maintenance work is recommended, a roofing contractor should be consulted for further advice.";
                            });
                          },
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 160),
                          child: TextContentWidget(text: _observedDislodgedText,),
                        )
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
    EditorGeneralInfoState state = bloc.state;
    ReportModel report = state.report;
    report.clientName = _clientNameController.text;
    report.projectNumber = _projectNumberController.text;
    report.address = _addressController.text;
    report.inspectDate = _selectedDate;
    report.inspectedBy = _inspectedBy;
    report.inspectionType = _inspectionType;
    report.clientBrief = _clientBriefController.text.isEmpty ? _clientBrief : _clientBriefController.text;
    report.propertyType = _propertyType;
    report.propertyTypeComment = _propertyTypeCommentController.text;
    report.presentAtSite = _presentAtSite;
    report.presentAtSiteComment = _presentAtSiteCommentController.text;
    report.personAtSiteComment = _personAtSiteCommentController.text;
    report.estimatedConstructionDecadeComment = _estimatedConstructionDecadeController.text;
    report.externalWallsConstruction = _externalWallsConstruction;
    report.externalWallsConstructionComment = _externalWallsConstructionController.text;
    report.roofCovering = _coverOfRoof;
    report.roomNumber = _roomNumber;
    report.roomNumberComment = _roomNumberCommentController.text;
    report.weather = _weather;
    report.weatherComment = _weatherCommentController.text;
    report.propertyOnHillComment = _propertyOnHillCommentController.text;
    report.anyChimneyStacks = _anyChimneyStacks;
    report.chimneyStacksRequireMaintenance = _chimneyMaintenance;
    report.chimneyStacksRequireMaintenanceComment = _chimneyMaintenanceCommentController.text;
    report.internalWallsCoveredInPlaster = _internalWallsCovered;
    report.observedAnyDislodgedTiles = _observedDislodged;
    report.observedAnyDislodgedTilesComment = _observedDislodgedText;
    bloc.add(EditorGeneralNextEvent(report: report));
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }
}
