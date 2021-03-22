import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:strucreport/bloc/bloc.dart';
import 'package:strucreport/config/application.dart';
import 'package:strucreport/config/params.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/model/photo_model.dart';
import 'package:strucreport/util/color_utils.dart';
import 'package:strucreport/util/file_utils.dart';
import 'package:strucreport/util/preference_helper.dart';
import 'package:strucreport/util/string_utils.dart';
import 'package:strucreport/util/toasts.dart';
import 'package:strucreport/widget/loading_dialog.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PreviewScreen extends StatefulWidget {
  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  EditorBloc bloc;
  BaseOptions baseOptions = BaseOptions(
    baseUrl: "https://cat.prolocalize.com/",
    connectTimeout: 30000,
    receiveTimeout: 30000,
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  );
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

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
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                          width: double.infinity,
                        ),
                        NeumorphicButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 20),
                          onPressed: () async {
                            await generateChecklist();
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.send,
                                size: 64,
                                color: ColorUtils.textColorByTheme(context),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Email Checklist(.pdf)",
                                style: TextStyle(
                                    color: ColorUtils.textColorByTheme(context),
                                    fontSize: 24),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        /*NeumorphicButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 20),
                          onPressed: () async {
                            await generateReport();
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.send,
                                size: 64,
                                color: ColorUtils.textColorByTheme(context),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Email Structural Report(.docx)",
                                style: TextStyle(
                                    color: ColorUtils.textColorByTheme(context),
                                    fontSize: 24),
                              )
                            ],
                          ),
                        )*/
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
  }

  Future<void> generateChecklist() async {
    //Create a new PDF document
    final PdfDocument document = PdfDocument();
    PdfPageSettings pageSettings = PdfPageSettings(PdfPageSize.a4);
    pageSettings.setMargins(0);
    document.pageSettings = pageSettings;

    //Add new Section
    final PdfSection section = document.sections.add();
    section.pageSettings.setMargins(20);

    final PdfPage contentPage = section.pages.add();

    //Create a header template and draw a text.
    section.template.top = await generateChecklistHeader(contentPage);

    //Create a footer template and draw a text.
    section.template.bottom = generateFooter(contentPage);

    PdfTextElement(
            text: "Contents:",
            brush: PdfBrushes.cornflowerBlue,
            font: PdfStandardFont(PdfFontFamily.helvetica, 16,
                style: PdfFontStyle.bold),
            format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(
            page: contentPage,
            bounds: Rect.fromLTWH(20, 80, contentPage.getClientSize().width,
                contentPage.getClientSize().height));

    // draw checklist
    PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 14,
        multiStyle: [PdfFontStyle.bold, PdfFontStyle.underline]);
    PdfFont italicFont = PdfStandardFont(PdfFontFamily.helvetica, 10,
        multiStyle: [PdfFontStyle.regular, PdfFontStyle.italic]);
    PdfFont regularFont = PdfStandardFont(PdfFontFamily.helvetica, 10,
        multiStyle: [PdfFontStyle.regular]);
    PdfFont underlineFont = PdfStandardFont(PdfFontFamily.helvetica, 10,
        multiStyle: [PdfFontStyle.regular, PdfFontStyle.underline]);

    PdfPage page1 = document.pages.add();
    PdfLayoutResult result = PdfTextElement(
            text: "1) General Information",
            brush: PdfBrushes.black,
            font: titleFont,
            format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(
            page: page1,
            bounds: Rect.fromLTWH(20, 20, page1.getClientSize().width, 20));
    //Add to table of content
    PdfLayoutResult tableContent = _addTableOfContents(
        contentPage,
        '1) General Information',
        Rect.fromLTWH(20, 120, result.page.getClientSize().width - 40,
            result.page.getClientSize().height),
        document.pages.indexOf(page1) + 1,
        20,
        result.bounds.top,
        result.page);

    result = writeChecklistRegularParagraph(
        text: "Name of client: ${PreferenceHelper.getString(Params.clientName)}",
        page: result.page,
        top: result.bounds.bottom + 20);

    result = writeChecklistRegularParagraph(
        text: "Project number: ${PreferenceHelper.getString(Params.projectNumber)}",
        page: result.page,
        top: result.bounds.bottom + 10);

    result = writeChecklistRegularParagraph(
        text: "Address: ${PreferenceHelper.getString(Params.address)}",
        page: result.page,
        top: result.bounds.bottom + 10);

    result = writeChecklistRegularParagraph(
        text: "Date: ${DateFormat('dd/MM/yyyy').format(PreferenceHelper.getDate(Params.inspectedDate))}",
        page: result.page,
        top: result.bounds.bottom + 10);

    String inspector = PreferenceHelper.getString(Params.inspectedBy);
    String secondInspector = PreferenceHelper.getString(Params.inspector2);
    if (secondInspector.isNotEmpty) inspector += ", $secondInspector";
    result = writeChecklistRegularParagraph(
        text: "Inspected by: $inspector",
        page: result.page,
        top: result.bounds.bottom + 10);

    String insepctionType = StringUtils.naDefaultedValue(param: Params.inspectionType);
    result = writeChecklistRegularParagraph(
        text: "Type of inspection: $insepctionType}",
        page: result.page,
        top: result.bounds.bottom + 10);
    String inspectionTypeComment = PreferenceHelper.getString(Params.inspectionTypeComment);
    if (inspectionTypeComment.isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: inspectionTypeComment,
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Client\'s brief:",
        page: result.page,
        top: result.bounds.bottom + 10);
    String clientBrief = PreferenceHelper.getString(Params.clientBrief);
    if (clientBrief.isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: clientBrief,
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    String propertyType = StringUtils.naDefaultedValue(param: Params.propertyType);
    result = writeChecklistRegularParagraph(
        text: "Property type: $propertyType",
        page: result.page,
        top: result.bounds.bottom + 10);
    String propertyTypeComment = PreferenceHelper.getString(Params.propertyTypeComment);
    if (propertyTypeComment.isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: propertyTypeComment,
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    String presentAtSite = StringUtils.naDefaultedValue(param: Params.presentAtSite);
    result = writeChecklistRegularParagraph(
        text: "Present at site: $presentAtSite",
        page: result.page,
        top: result.bounds.bottom + 10);
    String presentAtSiteComment = PreferenceHelper.getString(Params.presentAtSiteComment);
    if (presentAtSiteComment.isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: presentAtSiteComment,
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Person at site comments:",
        page: result.page,
        top: result.bounds.bottom + 10);
    String personAtSiteComment = PreferenceHelper.getString(Params.personAtSiteComment);
    if (personAtSiteComment.isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "$personAtSiteComment",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Estimated construction decade: ${PreferenceHelper.getString(Params.estimatedConstructionDecade)}",
        page: result.page,
        top: result.bounds.bottom + 10);

    String externalWallsConstruction = StringUtils.naDefaultedValue(param: Params.externalWallsConstruction);
    result = writeChecklistRegularParagraph(
        text: "External walls construction: $externalWallsConstruction",
        page: result.page,
        top: result.bounds.bottom + 10);

    String externalWallsConstructionComment = PreferenceHelper.getString(Params.externalWallsConstructionComment);
    if (externalWallsConstructionComment.isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "$externalWallsConstructionComment",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "What is covering of roof: ${StringUtils.naDefaultedValue(param: Params.coverOfRoof)}",
        page: result.page,
        top: result.bounds.bottom + 10);
    String roofCoverComment = PreferenceHelper.getString(Params.coverOfRoofComment);
    if (roofCoverComment.isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "$roofCoverComment",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "How many rooms/bedrooms: ${StringUtils.naDefaultedValue(param: Params.roomNumber)}",
        page: result.page,
        top: result.bounds.bottom + 10);
    String roomNumberComment = PreferenceHelper.getString(Params.roomNumberComment);
    if (roomNumberComment.isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "$roomNumberComment",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Weather: ${StringUtils.naDefaultedValue(param: Params.weather)}",
        page: result.page,
        top: result.bounds.bottom + 10);
    String weatherComment = PreferenceHelper.getString(Params.weatherComment);
    if (weatherComment.isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "$weatherComment",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Is the property on a hill, slope, any trees in proximity? : ",
        page: result.page,
        top: result.bounds.bottom + 10);

    String propertyOnHillComment = PreferenceHelper.getString(Params.propertyOnHillComment);
    if (propertyOnHillComment.isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "$propertyOnHillComment",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    bool anyChimneyStacks = PreferenceHelper.getBool(Params.anyChimneyStacks);
    result = writeChecklistRegularParagraph(
        text: "Any chimney stacks? : ${anyChimneyStacks ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (anyChimneyStacks) {
      result = writeChecklistRegularParagraph(
          text: "Do chimney stacks require maintenance? : ${PreferenceHelper.getBool(Params.chimneyMaintenance) ? 'Yes' : 'No'}",
          page: result.page,
          top: result.bounds.bottom + 10);
      String chimneyMaintenanceComment = PreferenceHelper.getString(Params.chimneyMaintenanceComment);
      if (chimneyMaintenanceComment.isNotEmpty) {
        result = writeChecklistCommentParagraph(
            text: "$chimneyMaintenanceComment",
            page: result.page,
            top: result.bounds.bottom + 6);
      }
    }

    result = writeChecklistRegularParagraph(
        text: "Are internal walls covered in plaster? : ${PreferenceHelper.getBool(Params.internalWallsCovered) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);
    String internalWallsCoveredComment = PreferenceHelper.getString(Params.internalWallsCoveredComment);
    if (internalWallsCoveredComment.isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "$internalWallsCoveredComment",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Have you observed any dislodged tiles/slates? : ${PreferenceHelper.getBool(Params.observedDislodged) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);
    String observedDislodgedTilesComment = PreferenceHelper.getString(Params.observedDislodgedComment);
    if (observedDislodgedTilesComment.isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "$observedDislodgedTilesComment",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    // insert photos
    PdfPage page2 = document.pages.add();

    result = PdfTextElement(
        text: "2) Photos",
        brush: PdfBrushes.black,
        font: titleFont,
        format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(
        page: page2,
        bounds: Rect.fromLTWH(20, 20, page2.getClientSize().width, 20));

    tableContent = _addTableOfContents(
        contentPage,
        '2) Photos',
        Rect.fromLTWH(20, 160, result.page.getClientSize().width - 40,
            result.page.getClientSize().height),
        document.pages.indexOf(page2) + 1,
        20,
        result.bounds.top,
        result.page);

    int index = 0;
    int count = 0;
    List<PhotoModel> reportPhotos = PreferenceHelper.getPhotos(Params.photos);
    for (int i = 0; i < Application.PhotoCategories.length; i++) {
      String category = Application.PhotoCategories[i];
      List<PhotoModel> photos = reportPhotos.where((elementPhoto) => elementPhoto.category == category).toList();
      if (photos.length > 0) {
        // add new page if new category
        if (count != 0 && count % 2 == 0) {
          page2 = document.pages.add();
        }

        // write photo category
        double catTop = count % 2 == 0 ? 60 : 356;
        result = PdfTextElement(
            text: "(${index + 1}) $category",
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(alignment: PdfTextAlignment.left))
            .draw(
            page: page2,
            bounds: Rect.fromLTWH(40, catTop, page2.getClientSize().width, 20));

        // draw photo
        for (int indexInCategory = 0; indexInCategory < photos.length; indexInCategory++) {
          PhotoModel photo = photos[indexInCategory];
          if (count % 2 == 0 && indexInCategory != 0) {
            page2 = document.pages.add();
          }
          final bytes = await photo.image.readAsBytes();
          double top = count % 2 == 0 ? 100 : 396;
          page2.graphics
              .drawImage(PdfBitmap(bytes), Rect.fromLTWH(140, top, 275, 206));
          String comment = "";
          if (photo.inReport) {
            comment = photo.caption;
          }
          if (photo.comment.isNotEmpty) {
            if (comment.isNotEmpty) comment += " - ";
            comment += photo.comment;
          }
          if (comment.isNotEmpty) {
            Size captionSize = regularFont.measureString(comment);
            PdfTextElement(
                text: comment,
                brush: PdfBrushes.black,
                font: regularFont,
                format: PdfStringFormat(alignment: PdfTextAlignment.left))
                .draw(
                page: page2,
                bounds: Rect.fromLTWH((555 - captionSize.width) / 2, top + 206 + 15,
                    page2.getClientSize().width, page2.getClientSize().height));
            page2.graphics.drawRectangle(
                bounds: Rect.fromLTWH((555 - captionSize.width) / 2 - 10, top + 206 + 10,
                    captionSize.width + 20, 20),
                pen: PdfPen(PdfColor(0, 0, 0, 255)));
          }
          count++;
        }
        index++;
      }
    }

    // insert additional information
    PdfPage page3 = document.pages.add();

    result = PdfTextElement(
        text: "3) Additional Information",
        brush: PdfBrushes.black,
        font: titleFont,
        format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(
        page: page3,
        bounds: Rect.fromLTWH(20, 20, page3.getClientSize().width, 20));

    tableContent = _addTableOfContents(
        contentPage,
        '3) Additional Information',
        Rect.fromLTWH(20, 200, result.page.getClientSize().width - 40,
            result.page.getClientSize().height),
        document.pages.indexOf(page3) + 1,
        20,
        result.bounds.top,
        result.page);

    result = writeChecklistRegularParagraph(
        text: "Have you observed any internal cracks 0-3mm? : ${getBool(Params.observedAnyInternalCracksSmaller3mm) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 20);

    if (getString(Params.observedAnyInternalCracksSmaller3mmComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.observedAnyInternalCracksSmaller3mmComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Have you observed any cracks larger than 3mm? : ${getBool(Params.observedAnyInternalCracksLager3mm) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.observedAnyInternalCracksLager3mmComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.observedAnyInternalCracksLager3mmComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Have you observed any cracks larger than 10mm? : ${getBool(Params.observedAnyInternalCracksLager10mm) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.observedAnyInternalCracksLager10mmComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.observedAnyInternalCracksLager10mmComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Have you observed defective/cracked mortar joints? : ${getBool(Params.observedDefectiveMortarJoints) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.observedDefectiveMortarJointsComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.observedDefectiveMortarJointsComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Have you observed defective bricks (weathered, cracked, loose, etc)? : ${getBool(Params.observedDefectiveBricks) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.observedDefectiveBricksComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.observedDefectiveBricksComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Type of lintels? : ${getString(Params.lintelType).substring(4)}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.lintelTypeComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.lintelTypeComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Have you observed any cracks above lintels? : ${getBool(Params.observedAnyCracksAboveLintels) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.observedAnyCracksAboveLintelsComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.observedAnyCracksAboveLintelsComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "What is the construction of floors on ground floor? : ${getString(Params.constructionOfFloorsOnGroundFloor)}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.constructionOfFloorsOnGroundFloorComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.constructionOfFloorsOnGroundFloorComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "On ground floor, are floors in below average condition considering the age of the property - uneven/sagging? : ${getBool(Params.belowAverageGroundFloor) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.belowAverageGroundFloorComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.belowAverageGroundFloorComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Have you observed any drainage and/or uneven pavement in vicinity of uneven ground floor or wall cracks? : ${getBool(Params.observedDrainagePavement) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.observedDrainagePavementComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.observedDrainagePavementComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "What is the construction of floors on  first floor? : ${getString(Params.constructionOfFloorsOnFirstFloor)}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.constructionOfFloorsOnFirstFloorComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.constructionOfFloorsOnFirstFloorComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "On the first floor, are the floors in below average considering the age of the property - uneven/sagging? : ${getBool(Params.belowAverageFirstFloor) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.belowAverageFirstFloorComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.belowAverageFirstFloorComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Based on the internal face of gable wall and/or external elevations, what is the type of construction? : ${getString(Params.internalFaceGableWall)}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.internalFaceGableWallComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.internalFaceGableWallComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Have you observed any movement of bay window? : ${getBool(Params.observedBayWindowMovement) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.observedBayWindowMovementComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.observedBayWindowMovementComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Have you observed any movement at junction of an extension/porch and the original building? : ${getBool(Params.observedJunctionMovement) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    print("error debug:");
    print(getString(Params.observedJunctionMovementComment));
    if (getString(Params.observedJunctionMovementComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.observedJunctionMovementComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Is the roof sagging? : ${getBool(Params.roofSagging) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.roofSaggingComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.roofSaggingComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Have you inspected all rooms, including garage, roof space and all accessible areas? : ${getBool(Params.inspectedAllRooms) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.inspectedAllRoomsComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.inspectedAllRoomsComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Have you recorded 1min video, taken overview and close-up photos of all defects observed? : ${getBool(Params.recordedVideo) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.recordedVideoComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.recordedVideoComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Have you observed any active movement? : ${getBool(Params.observedActiveMovement) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.observedActiveMovementComment).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.observedActiveMovementComment)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    result = writeChecklistRegularParagraph(
        text: "Are external elevations in an acceptable condition considering the age of the property? : ${getBool(Params.externalElevations) ? 'Yes' : 'No'}",
        page: result.page,
        top: result.bounds.bottom + 10);

    result = writeChecklistRegularParagraph(
        text: "Any other information/comments:",
        page: result.page,
        top: result.bounds.bottom + 10);

    if (getString(Params.otherInformation).isNotEmpty) {
      result = writeChecklistCommentParagraph(
          text: "${getString(Params.otherInformation)}",
          page: result.page,
          top: result.bounds.bottom + 6);
    }

    // draw rectangle on pages
    for (int i = 0; i < section.pages.count; i++) {
      section.pages[i].graphics.drawRectangle(
          bounds: Rect.fromLTWH(0, 0, contentPage.getClientSize().width,
              contentPage.getClientSize().height),
          pen: PdfPen(PdfColor(0, 0, 0, 255)));
    }

    //Save and dispose the document.
    final List<int> bytes = document.save();
    document.dispose();
    final String projectNumber = PreferenceHelper.getString(Params.projectNumber);
    final Directory directory = await FileUtils.getProjectDirectory(projectNumber);
    final String path = directory.path;
    String formattedDate = DateFormat('dd.MM.yyyy').format(DateTime.now());
    String filename = "$projectNumber-Checklist-$formattedDate.pdf";
    final File file = File('$path/$filename');
    bool isExist = await file.exists();
    try {
      if (!isExist) {
        await file.create();
      }
      await file.writeAsBytes(bytes, flush: true);
    }
    catch (e) {
      if (!isExist) {
        await file.create();
      }
      await file.writeAsBytes(bytes, flush: true);
    }

    print("========================= PDF created ======================");
    print('$path/$filename');

    //// Email Send
    final Email email = Email(
      body: "StrucReport",
      subject: "New checklist created",
      recipients: Application.Emails,
      attachmentPaths: ['$path/$filename'],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }
    print("========= Send Email ===============");
    print(platformResponse);
  }

  Future<void> generateReport() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      } else {
        ToastUtils.showErrorToast(context, "Please connect to Internet");
        return;
      }
    } on SocketException catch (_) {
      ToastUtils.showErrorToast(context, "Please connect to Internet");
      return;
    }

    LoadingDialog.showLoadingDialog(context, _keyLoader);

    //Create a new PDF document
    final PdfDocument document = PdfDocument();
    PdfPageSettings pageSettings = PdfPageSettings(PdfPageSize.a4);
    pageSettings.setMargins(0);
    document.pageSettings = pageSettings;

    //Add new Section
    final PdfSection section = document.sections.add();
    section.pageSettings.setMargins(20);

    final PdfPage contentPage = section.pages.add();

    //Create a header template and draw a text.
    section.template.top = await generateHeader(contentPage);

    //Create a footer template and draw a text.
    section.template.bottom = generateFooter(contentPage);

    PdfTextElement(
            text: "Contents:",
            brush: PdfBrushes.cornflowerBlue,
            font: PdfStandardFont(PdfFontFamily.helvetica, 16,
                style: PdfFontStyle.bold),
            format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(
            page: contentPage,
            bounds: Rect.fromLTWH(20, 80, contentPage.getClientSize().width,
                contentPage.getClientSize().height));

    // draw report
    PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 14, multiStyle: [PdfFontStyle.bold, PdfFontStyle.underline]);
    PdfFont italicFont = PdfStandardFont(PdfFontFamily.helvetica, 10, multiStyle: [PdfFontStyle.regular, PdfFontStyle.italic]);
    PdfFont regularFont = PdfStandardFont(PdfFontFamily.helvetica, 10, multiStyle: [PdfFontStyle.regular]);
    PdfFont underlineFont = PdfStandardFont(PdfFontFamily.helvetica, 10, multiStyle: [PdfFontStyle.regular, PdfFontStyle.underline]);

    /**
     * 1) Introduction - Client Brief
     */
    PdfPage page = document.pages.add();
    PdfLayoutResult result = PdfTextElement(
        text: "1) Introduction - Client Brief",
        brush: PdfBrushes.black,
        font: titleFont,
        format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(
        page: page,
        bounds: Rect.fromLTWH(20, 20, page.getClientSize().width - 40, page.getClientSize().height));

    PdfLayoutResult tableContent = _addTableOfContents(
        contentPage,
        '1) Introduction - Client Brief',
        Rect.fromLTWH(20, 120, result.page.getClientSize().width - 40, result.page.getClientSize().height),
        document.pages.indexOf(page) + 1,
        20,
        result.bounds.top,
        result.page);

    String clientBrief = getString(Params.clientBrief);
    if (getString(Params.inspectionType).contains("GSI")) {
      clientBrief += "\r\n\r\n";
      clientBrief += "The purpose of this report is to provide the client with information regarding the structural condition of the building.";
    }
    result = PdfTextElement(text: clientBrief, brush: PdfBrushes.black, font: regularFont, format: PdfStringFormat(alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(page: page, bounds: Rect.fromLTWH(20, result.bounds.bottom + 20, page.getClientSize().width - 40, page.getClientSize().height));

    /**
     * 2) Scope of the Structural Survey
     */
    result = PdfTextElement(
            text: "2) Scope of the Structural Survey",
            brush: PdfBrushes.black,
            font: titleFont,
            format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(page: page, bounds: Rect.fromLTWH(20, result.bounds.bottom + 20, page.getClientSize().width - 40, page.getClientSize().height));
    //Add to table of content
    tableContent = _addTableOfContents(
        contentPage,
        '2) Scope of the Structural Survey',
        Rect.fromLTWH(20, 160, result.page.getClientSize().width - 40,
            result.page.getClientSize().height),
        document.pages.indexOf(page) + 1,
        20,
        result.bounds.top,
        result.page);
    result = PdfTextElement(
            text: "The survey and inspection aims were to: \r\n\r\n" +
                "   - Visually assess external elevations and accessible internal spaces \r\n" +
                "   - Provide a report describing our observations and findings \r\n" +
                "   - Make recommendations for further actions \r\n\r\n" +
                "This report is produced as a result of a visual, non-disruptive inspection of the above premises. Binoculars were used to inspect roof slopes, chimney stacks, and higher-level brickwork. I have not inspected the other woodwork, or any other inaccessible parts of the structure, which are covered or unexposed and I am therefore unable to confirm that these parts of the building are free from defects. \r\n\r\n" +
                "The engineer acknowledges the co-operation of the occupants in allowing access to the property at the agreed time and their assistance in the clarification of points raised during on-site discussions. \r\n",
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(page: page, bounds: Rect.fromLTWH(20, result.bounds.bottom + 20, page.getClientSize().width - 40, page.getClientSize().height));

    /**
     * 3) Exclusions
     */
    result = PdfTextElement(
            text: "3) Exclusions",
            brush: PdfBrushes.black,
            font: titleFont,
            format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(page: result.page, bounds: Rect.fromLTWH(20, result.bounds.bottom + 20, page.getClientSize().width - 40, page.getClientSize().height));

    tableContent = _addTableOfContents(
        contentPage,
        '3) Exclusions',
        Rect.fromLTWH(20, 200, result.page.getClientSize().width - 40,
            result.page.getClientSize().height),
        document.pages.indexOf(result.page) + 1,
        20,
        result.bounds.top,
        result.page);

    result = PdfTextElement(
            text: "- Damp proofing, roofing, and waterproofing \r\n" +
                "- Non-structural systems: electrics, plumbing, heating, non-structural plasters, paints, and renders \r\n" +
                "- Not exposed, hidden, inaccessible structural elements \r\n\r\n",
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(page: page, bounds: Rect.fromLTWH(20, result.bounds.bottom + 20, result.page.getClientSize().width - 40, result.page.getClientSize().height));

    /**
     * 4) Client Details
     */
    page = document.pages.add();
    result = PdfTextElement(
            text: "4) Client Details",
            brush: PdfBrushes.black,
            font: titleFont,
            format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(page: page, bounds: Rect.fromLTWH(20, 20, page.getClientSize().width - 40, page.getClientSize().height));

    tableContent = _addTableOfContents(
        contentPage,
        '4) Client Details',
        Rect.fromLTWH(20, 240, result.page.getClientSize().width - 40,
            result.page.getClientSize().height),
        document.pages.indexOf(result.page) + 1,
        20,
        result.bounds.top,
        result.page);

    result = PdfTextElement(
            text: "Name of client:",
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
            page: result.page,
            bounds: Rect.fromLTWH(
                20,
                result.bounds.bottom + 20,
                result.page.getClientSize().width - 40,
                result.page.getClientSize().height));
    result = PdfTextElement(
            text: getString(Params.clientName),
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
            page: result.page,
            bounds: Rect.fromLTWH(
                200,
                result.bounds.top,
                result.page.getClientSize().width - 220,
                result.page.getClientSize().height));
    result = PdfTextElement(
            text: "Address of property inspected:",
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
            page: result.page,
            bounds: Rect.fromLTWH(
                20,
                result.bounds.bottom + 20,
                result.page.getClientSize().width - 40,
                result.page.getClientSize().height));
    result = PdfTextElement(
            text: getString(Params.address),
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
            page: result.page,
            bounds: Rect.fromLTWH(
                200,
                result.bounds.top,
                result.page.getClientSize().width - 220,
                result.page.getClientSize().height));
    result = PdfTextElement(
            text: "Project Reference:",
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
            page: result.page,
            bounds: Rect.fromLTWH(
                20,
                result.bounds.bottom + 20,
                result.page.getClientSize().width - 40,
                result.page.getClientSize().height));
    result = PdfTextElement(
            text: getString(Params.projectNumber),
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
            page: result.page,
            bounds: Rect.fromLTWH(
                200,
                result.bounds.top,
                result.page.getClientSize().width - 220,
                result.page.getClientSize().height));
    result = PdfTextElement(
            text: "Date of Inspection:",
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
            page: result.page,
            bounds: Rect.fromLTWH(
                20,
                result.bounds.bottom + 20,
                result.page.getClientSize().width - 40,
                result.page.getClientSize().height));
    result = PdfTextElement(
            text: DateFormat('dd/MM/yyyy').format(getDate(Params.inspectedDate)),
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
            page: result.page,
            bounds: Rect.fromLTWH(
                200,
                result.bounds.top,
                result.page.getClientSize().width - 220,
                result.page.getClientSize().height));
    result = PdfTextElement(
            text: "Weather:",
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
            page: result.page,
            bounds: Rect.fromLTWH(
                20,
                result.bounds.bottom + 20,
                result.page.getClientSize().width - 40,
                result.page.getClientSize().height));
    result = PdfTextElement(
            text: getString(Params.weatherComment).isNotEmpty ? getString(Params.weatherComment) : getString(Params.weather),
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
            page: result.page,
            bounds: Rect.fromLTWH(
                200,
                result.bounds.top,
                result.page.getClientSize().width - 220,
                result.page.getClientSize().height));
    /**
     * 5) General Description
     */
    result = PdfTextElement(
            text: "5) General Description",
            brush: PdfBrushes.black,
            font: titleFont,
            format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(page: result.page, bounds: Rect.fromLTWH(20, result.bounds.bottom + 60, result.page.getClientSize().width - 40, result.page.getClientSize().height));

    tableContent = _addTableOfContents(
        contentPage,
        '5) General Description',
        Rect.fromLTWH(20, 280, result.page.getClientSize().width - 40,
            result.page.getClientSize().height),
        document.pages.indexOf(result.page) + 1,
        20,
        result.bounds.top,
        result.page);

    String generalDescription = "";
    String propertyTypeComment = getString(Params.propertyTypeComment);
    if (propertyTypeComment.isNotEmpty) {
      generalDescription += propertyTypeComment;
    } else {
      generalDescription += "The property is a ${getString(Params.propertyType).toLowerCase()} house.";
    }
    String decade = getString(Params.estimatedConstructionDecade);
    if (decade.isNotEmpty) {
      if (StringUtils.isNumeric(decade)) {
        generalDescription += " The building appears to be constructed crica ${decade}s.";
      } else if (decade.length > 5) {
        generalDescription += " $decade";
      } else {
        generalDescription += " The building appears to be constructed crica $decade.";
      }
    }
    String roomNumberComment = getString(Params.roomNumberComment);
    if (roomNumberComment.isNotEmpty) {
      generalDescription += " \r\n\r\n " + roomNumberComment;
    } else {
      String roomNumber = getString(Params.roomNumber);
      if (roomNumber.isEmpty) roomNumber = Application.NumberOfRooms[0];
      if (roomNumber != "Other") {
        generalDescription += " \r\n\r\n " + "It is a $roomNumber property.";
      }
    }
    generalDescription += "\r\n\r\n The property is constructed as follows: ";
    result = PdfTextElement(
            text: generalDescription,
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(page: result.page, bounds: Rect.fromLTWH(20, result.bounds.bottom + 20, result.page.getClientSize().width - 40, result.page.getClientSize().height));

    result = PdfTextElement(
        text: "Main walls:",
        brush: PdfBrushes.black,
        font: regularFont,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
        page: result.page,
        bounds: Rect.fromLTWH(
            80,
            result.bounds.bottom + 20,
            result.page.getClientSize().width - 100,
            result.page.getClientSize().height));
    String externalWallsComment = getString(Params.externalWallsConstructionComment);
    if (externalWallsComment.isEmpty) externalWallsComment = getString(Params.externalWallsConstruction);
    result = PdfTextElement(
        text: externalWallsComment,
        brush: PdfBrushes.black,
        font: regularFont,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
        page: result.page,
        bounds: Rect.fromLTWH(
            200,
            result.bounds.top,
            result.page.getClientSize().width - 220,
            result.page.getClientSize().height));

    result = PdfTextElement(
        text: "Internal walls:",
        brush: PdfBrushes.black,
        font: regularFont,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
        page: result.page,
        bounds: Rect.fromLTWH(
            80,
            result.bounds.bottom + 20,
            result.page.getClientSize().width - 100,
            result.page.getClientSize().height));
    String internalWalls = getString(Params.internalFaceGableWallComment);
    if (internalWalls.isEmpty) internalWalls = getString(Params.internalFaceGableWall);
    result = PdfTextElement(
        text: internalWalls,
        brush: PdfBrushes.black,
        font: regularFont,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
        page: result.page,
        bounds: Rect.fromLTWH(
            200,
            result.bounds.top,
            result.page.getClientSize().width - 220,
            result.page.getClientSize().height));

    result = PdfTextElement(
        text: "Roof:",
        brush: PdfBrushes.black,
        font: regularFont,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
        page: result.page,
        bounds: Rect.fromLTWH(
            80,
            result.bounds.bottom + 20,
            result.page.getClientSize().width - 100,
            result.page.getClientSize().height));
    String roofCover = getString(Params.coverOfRoofComment);
    if (roofCover.isEmpty) roofCover = getString(Params.coverOfRoof);
    result = PdfTextElement(
        text: roofCover,
        brush: PdfBrushes.black,
        font: regularFont,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
        page: result.page,
        bounds: Rect.fromLTWH(
            200,
            result.bounds.top,
            result.page.getClientSize().width - 220,
            result.page.getClientSize().height));

    result = PdfTextElement(
        text: "Floors:",
        brush: PdfBrushes.black,
        font: regularFont,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
        page: result.page,
        bounds: Rect.fromLTWH(
            80,
            result.bounds.bottom + 20,
            result.page.getClientSize().width - 100,
            result.page.getClientSize().height));
    String floorConstruction = getString(Params.constructionOfFloorsOnGroundFloor);
    floorConstruction += ", " + getString(Params.constructionOfFloorsOnFirstFloor);
    result = PdfTextElement(
        text: floorConstruction,
        brush: PdfBrushes.black,
        font: regularFont,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
        page: result.page,
        bounds: Rect.fromLTWH(
            200,
            result.bounds.top,
            result.page.getClientSize().width - 220,
            result.page.getClientSize().height));

    /**
     * 6) Observations and Findings
     */
    page = document.pages.add();
    result = PdfTextElement(
            text: "6) Observations and Findings",
            brush: PdfBrushes.black,
            font: titleFont,
            format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(20, 20, page.getClientSize().width, page.getClientSize().height));
    tableContent = _addTableOfContents(
        tableContent.page,
        '6) Observations and Findings',
        Rect.fromLTWH(20, 320, result.page.getClientSize().width - 40,
            result.page.getClientSize().height),
        document.pages.indexOf(page) + 1,
        20,
        result.bounds.top,
        result.page);

    List<PhotoModel> reportPhotos = PreferenceHelper.getPhotos(Params.photos);
    List<PhotoModel> photos = reportPhotos.where((element) => element.inReport).toList();
    for (int i = 0; i < photos.length; i++) {
      if (i % 2 == 0 && i > 0) {
        page = document.pages.add();
      }
      String caption = "Photo ${i + 1} - " + photos[i].caption;
      Size captionSize = regularFont.measureString(caption);
      final bytes = await photos[i].image.readAsBytes();
      if (i % 2 == 0) {
        page.graphics
            .drawImage(PdfBitmap(bytes), Rect.fromLTWH(120, 50, 320, 240));
        PdfTextElement(
                text: caption,
                brush: PdfBrushes.black,
                font: regularFont,
                format: PdfStringFormat(alignment: PdfTextAlignment.left))
            .draw(
                page: page,
                bounds: Rect.fromLTWH((555 - captionSize.width) / 2, 315,
                    page.getClientSize().width, page.getClientSize().height));
        page.graphics.drawRectangle(
            bounds: Rect.fromLTWH((555 - captionSize.width) / 2 - 20, 305,
                captionSize.width + 40, captionSize.height + 20),
            pen: PdfPen(PdfColor(0, 0, 0, 255)));
      } else {
        page.graphics
            .drawImage(PdfBitmap(bytes), Rect.fromLTWH(120, 345, 320, 240));
        PdfTextElement(
                text: caption,
                brush: PdfBrushes.black,
                font: regularFont,
                format: PdfStringFormat(alignment: PdfTextAlignment.left))
            .draw(
                page: page,
                bounds: Rect.fromLTWH(
                    (555 - captionSize.width) / 2,
                    page.getClientSize().height - 50,
                    page.getClientSize().width,
                    page.getClientSize().height));
        page.graphics.drawRectangle(
            bounds: Rect.fromLTWH(
                (555 - captionSize.width) / 2 - 20,
                page.getClientSize().height - 60,
                captionSize.width + 40,
                captionSize.height + 20),
            pen: PdfPen(PdfColor(0, 0, 0, 255)));
      }
    }

    page = document.pages.add();
    result = PdfTextElement(
        text: "External wall elevations",
        brush: PdfBrushes.black,
        font: titleFont,
        format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(
        page: page,
        bounds:
        Rect.fromLTWH(20, 20, page.getClientSize().width - 40, 20));
    String externalWallElevations = "";
    if (getBool(Params.externalElevations)) {
      externalWallElevations += "The external elevations appeared to be in acceptable condition.";
    } else {
      externalWallElevations += "The external elevations appeared to be in not acceptable condition.";
    }

    bool mortarJoints = getBool(Params.observedDefectiveMortarJoints);
    bool crackLintel = getBool(Params.observedAnyCracksAboveLintels);
    String observedSomeMotar = "";
    if (mortarJoints && crackLintel) {
      observedSomeMotar = "We observed some defective mortar joints and cracking to the solider course lintel and below the front elevation window.";
    } else if (mortarJoints) {
      observedSomeMotar = "We observed some defective mortar joints.";
    } else if (crackLintel) {
      observedSomeMotar = "We observed some cracking to the solider course lintel and below the front elevation window.";
    }
    if (observedSomeMotar.isNotEmpty) externalWallElevations += observedSomeMotar;
    
    if (getBool(Params.observedJunctionMovement)) {
      externalWallElevations += "\r\n\r\n";
      externalWallElevations += "We observed some cracking/movement between the porch and main building, this appears to be due to the historical settlement of the porch. Presently, the porch appears to be in acceptable condition and a movement joint could be installed to accommodate differential movement between the porch and the main building. If any further movement is observed in the future (more than 5mm) it should be investigated further.";
    }

    result = PdfTextElement(
        text: externalWallElevations,
        brush: PdfBrushes.black,
        font: regularFont,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
        page: result.page,
        bounds: Rect.fromLTWH(
            20,
            result.bounds.bottom + 20,
            result.page.getClientSize().width - 40,
            result.page.getClientSize().height));

    if (getBool(Params.internalWallsCovered)) {
      result = PdfTextElement(
          text: "Internal walls & ceilings",
          brush: PdfBrushes.black,
          font: titleFont,
          format: PdfStringFormat(alignment: PdfTextAlignment.left))
          .draw(
          page: page,
          bounds:
          Rect.fromLTWH(20, result.bounds.bottom + 20, page.getClientSize().width - 40, 20));
      result = PdfTextElement(
          text: "The internal walls are covered with paint and plaster therefore we are unable to confirm that these parts of the building are free from defects. However, there are various cracks in the plaster that were noticed during our site visit. The cracks observed could be repaired or made-good during normal redecoration",
          brush: PdfBrushes.black,
          font: regularFont,
          format: PdfStringFormat(
              alignment: PdfTextAlignment.left, lineSpacing: 8))
          .draw(
          page: result.page,
          bounds: Rect.fromLTWH(
              20,
              result.bounds.bottom + 20,
              result.page.getClientSize().width - 40,
              result.page.getClientSize().height));
    }

    result = PdfTextElement(
        text: "Floors",
        brush: PdfBrushes.black,
        font: titleFont,
        format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(
        page: page,
        bounds:
        Rect.fromLTWH(20, result.bounds.bottom + 20, page.getClientSize().width - 40, 20));
    result = PdfTextElement(
        text: "All floors appear to be in acceptable condition, considering the age of the property.",
        brush: PdfBrushes.black,
        font: regularFont,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
        page: result.page,
        bounds: Rect.fromLTWH(
            20,
            result.bounds.bottom + 20,
            result.page.getClientSize().width - 40,
            result.page.getClientSize().height));

    result = PdfTextElement(
        text: "Roof",
        brush: PdfBrushes.black,
        font: titleFont,
        format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(
        page: page,
        bounds:
        Rect.fromLTWH(20, result.bounds.bottom + 20, page.getClientSize().width - 40, 20));
    String roof = "The roof is a traditional timber construction and was in acceptable condition. The roof tiles illustrated signs of natural weathering throughout (slightly cracked/chipped in places).";
    if (getBool(Params.observedDislodged)) {
      roof += "There did not appear to be any significantly dislodged [tiles/slates], but periodic maintenance work is recommended, a roofing contractor should be consulted for further advice. ";
    } else {
      roof += "Some dislodged tiles/slates were observed, and maintenance repairs are required, a roofing contractor should be consulted for further advice.";
    }
    roof += "\r\n\r\n";
    roof += "Generally, the roof appears to be in acceptable condition based on internal and external observations only, we have not inspected any covered or not accessible timberwork.";

    result = PdfTextElement(
        text: roof,
        brush: PdfBrushes.black,
        font: regularFont,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
        page: result.page,
        bounds: Rect.fromLTWH(
            20,
            result.bounds.bottom + 20,
            result.page.getClientSize().width - 40,
            result.page.getClientSize().height));

    if (getBool(Params.chimneyMaintenance)) {
      result = PdfTextElement(
          text: "Chimney",
          brush: PdfBrushes.black,
          font: titleFont,
          format: PdfStringFormat(alignment: PdfTextAlignment.left))
          .draw(
          page: page,
          bounds:
          Rect.fromLTWH(20, result.bounds.bottom + 20, page.getClientSize().width - 40, 20));
      result = PdfTextElement(
          text: "The chimney stack appeared to be in acceptable condition, we did observe some defective mortar joints. It is recommended, as a precautionary measure that the chimney is to be inspected closely when any roof maintenance work is carried out and when a safe working platform is in place, to fully confirm the exact condition of the masonry and mortar.",
          brush: PdfBrushes.black,
          font: regularFont,
          format: PdfStringFormat(
              alignment: PdfTextAlignment.left, lineSpacing: 8))
          .draw(
          page: result.page,
          bounds: Rect.fromLTWH(
              20,
              result.bounds.bottom + 20,
              result.page.getClientSize().width - 40,
              result.page.getClientSize().height));
    }

    /**
     * 7) Conclusion and Recommendations
     */
    page = document.pages.add();
    result = PdfTextElement(
            text: "7) Conclusion and Recommendations",
            brush: PdfBrushes.black,
            font: titleFont,
            format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(
            page: page,
            bounds:
                Rect.fromLTWH(20, 20, page.getClientSize().width - 40, 20));

    tableContent = _addTableOfContents(
        contentPage,
        '7) Conclusion and Recommendations',
        Rect.fromLTWH(20, 360, result.page.getClientSize().width - 40,
            result.page.getClientSize().height),
        document.pages.indexOf(result.page) + 1,
        20,
        result.bounds.top,
        result.page);

    result = PdfTextElement(
            text:
                "The property appears to be in ${getBool(Params.externalElevations) ? 'acceptable' : 'not acceptable'} condition from the structural perspective, and we ${getBool(Params.observedActiveMovement) ? 'have' : 'have not'} observed any significant active structural movement, but we did observe some historic settlement of the porch and diagonal crack along the front extension wall. If any new movement and/or cracking is found in the future, it should be reported to a Structural Engineer. The building requires some minor repairs and maintenance work. \r\n\r\n",
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
            page: result.page,
            bounds: Rect.fromLTWH(
                20,
                result.bounds.bottom + 20,
                result.page.getClientSize().width - 40,
                result.page.getClientSize().height));
    result = PdfTextElement(
            text: "We recommend the following repairs: \r\n",
            brush: PdfBrushes.black,
            font: underlineFont,
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(
            page: result.page,
            bounds: Rect.fromLTWH(
                20,
                result.bounds.bottom + 20,
                result.page.getClientSize().width - 40,
                result.page.getClientSize().height));
    int index = 1;
    if (getBool(Params.observedAnyInternalCracksSmaller3mm)) {
      result = PdfTextElement(
              text: index.toString() +
                  ". All internal cracking to be repaired during future redecoration.",
              brush: PdfBrushes.black,
              font: regularFont,
              format: PdfStringFormat(
                  alignment: PdfTextAlignment.left, lineSpacing: 8))
          .draw(
              page: result.page,
              bounds: Rect.fromLTWH(
                  60,
                  result.bounds.bottom + 15,
                  result.page.getClientSize().width - 80,
                  result.page.getClientSize().height));
      index++;
    }
    if (getBool(Params.observedAnyInternalCracksLager3mm)) {
      result = PdfTextElement(
              text: index.toString() +
                  ". External cracks between 3-10 mm to be fixed by installation of helical bars as per attached Appendix and repointing as per attached Appendix.",
              brush: PdfBrushes.black,
              font: regularFont,
              format: PdfStringFormat(
                  alignment: PdfTextAlignment.left, lineSpacing: 8))
          .draw(
              page: result.page,
              bounds: Rect.fromLTWH(
                  60,
                  result.bounds.bottom + 15,
                  result.page.getClientSize().width - 80,
                  result.page.getClientSize().height));
      index++;
    }
    if (getBool(Params.observedAnyInternalCracksLager10mm)) {
      result = PdfTextElement(
              text: index.toString() +
                  ". The extensive cracks larger than 10 mm to be repaired by replacement of defective masonry and installation of helical bars as per attached Appendix. Underpinning might be required if the cracks re-appear.",
              brush: PdfBrushes.black,
              font: regularFont,
              format: PdfStringFormat(
                  alignment: PdfTextAlignment.left, lineSpacing: 8))
          .draw(
              page: result.page,
              bounds: Rect.fromLTWH(
                  60,
                  result.bounds.bottom + 15,
                  result.page.getClientSize().width - 80,
                  result.page.getClientSize().height));
      index++;
    }
    if (getBool(Params.observedDefectiveMortarJoints)) {
      result = PdfTextElement(
              text: index.toString() +
                  ". All defective mortar joints to be cut out and repointed.",
              brush: PdfBrushes.black,
              font: regularFont,
              format: PdfStringFormat(
                  alignment: PdfTextAlignment.left, lineSpacing: 8))
          .draw(
              page: result.page,
              bounds: Rect.fromLTWH(
                  60,
                  result.bounds.bottom + 15,
                  result.page.getClientSize().width - 80,
                  result.page.getClientSize().height));
      index++;
    }
    if (getBool(Params.observedDefectiveBricks)) {
      result = PdfTextElement(
              text: index.toString() +
                  ". All defective bricks to be removed and replaced during future maintenance repairs.",
              brush: PdfBrushes.black,
              font: regularFont,
              format: PdfStringFormat(
                  alignment: PdfTextAlignment.left, lineSpacing: 8))
          .draw(
              page: result.page,
              bounds: Rect.fromLTWH(
                  60,
                  result.bounds.bottom + 15,
                  result.page.getClientSize().width - 80,
                  result.page.getClientSize().height));
      index++;
    }
    if (getBool(Params.observedAnyCracksAboveLintels)) {
      result = PdfTextElement(
              text: index.toString() +
                  ". Cracked masonry above windows to be repaired by installation of helical bars  as per Appendix.",
              brush: PdfBrushes.black,
              font: regularFont,
              format: PdfStringFormat(
                  alignment: PdfTextAlignment.left, lineSpacing: 8))
          .draw(
              page: result.page,
              bounds: Rect.fromLTWH(
                  60,
                  result.bounds.bottom + 15,
                  result.page.getClientSize().width - 80,
                  result.page.getClientSize().height));
      index++;
    }
    if (getBool(Params.observedBayWindowMovement)) {
      result = PdfTextElement(
              text: index.toString() +
                  ". Cracks at junction of the bay window and front wall should be repaired as per attached Appendix.",
              brush: PdfBrushes.black,
              font: regularFont,
              format: PdfStringFormat(
                  alignment: PdfTextAlignment.left, lineSpacing: 8))
          .draw(
              page: result.page,
              bounds: Rect.fromLTWH(
                  60,
                  result.bounds.bottom + 15,
                  result.page.getClientSize().width - 80,
                  result.page.getClientSize().height));
      index++;
    }
    if (getBool(Params.observedJunctionMovement)) {
      result = PdfTextElement(
              text: index.toString() +
                  ". Cracks at junctions  of the original building and extension should be repaired by installation of helical bars, if the cracks re-appear a Structural Engineer should be consulted for further advice.",
              brush: PdfBrushes.black,
              font: regularFont,
              format: PdfStringFormat(
                  alignment: PdfTextAlignment.left, lineSpacing: 8))
          .draw(
              page: result.page,
              bounds: Rect.fromLTWH(
                  60,
                  result.bounds.bottom + 15,
                  result.page.getClientSize().width - 80,
                  result.page.getClientSize().height));
      index++;
    }
    if (getBool(Params.roofSagging)) {
      result = PdfTextElement(
              text: index.toString() +
                  ". Sagging rafters/purlins should be repaired by doubling up of existing purlins and/or installation of collar ties (50x100 C24), every other rafter, at 1m from the ridge board.",
              brush: PdfBrushes.black,
              font: regularFont,
              format: PdfStringFormat(
                  alignment: PdfTextAlignment.left, lineSpacing: 8))
          .draw(
              page: result.page,
              bounds: Rect.fromLTWH(
                  60,
                  result.bounds.bottom + 15,
                  result.page.getClientSize().width - 80,
                  result.page.getClientSize().height));
      index++;
    }

    /**
     * 8) Terms & Conditions
     */
    final PdfPage page8 = document.pages.add();
    result = PdfTextElement(
            text: "8) Terms & Conditions",
            brush: PdfBrushes.black,
            font: titleFont,
            format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(
            page: page8,
            bounds: Rect.fromLTWH(20, 20, page8.getClientSize().width, 20));
    //Add to table of content
    tableContent = _addTableOfContents(
        tableContent.page,
        '8) Terms & Conditions',
        Rect.fromLTWH(20, 400, result.page.getClientSize().width - 40,
            result.page.getClientSize().height),
        document.pages.indexOf(page8) + 1,
        20,
        result.bounds.top,
        result.page);
    result = PdfTextElement(
            text: "1. These Terms and Conditions are designed to clarify to the Client the scope and extent of the Survey and type of Report to be undertaken and prepared by Simplify Structural Engineering LLP, Chartered Engineers.\r\n" +
                "2. The Report will advise the Client as to the Engineer\u0027s opinion of the structural elements listed in 1. Instructions - Client\u0027s Brief and 2. Scope of Services and which are reasonably accessible subject to the under mentioned restrictions and conditions \r\n" +
                "3. It must be pointed out that the Engineer cannot cause damage to someone else\u0027s property and, therefore, concealed parts of the building and structure will not be opened or disturbed. Parts of the building which are covered, unexposed or inaccessible will not be inspected and, as such, we will not be able to report or establish the condition in that location. The Engineer will inspect as much of the surface areas as is practicable, and will lift loose floorboards and trap doors where accessible, but will be under no obligation to raise fixed floorboards or to inspect those areas of the property that are covered, unexposed, or are not readily accessible. The Report will not intend to express an opinion about or to advise upon the condition of uninspected parts and should not be taken as making any implied representation or statement about such parts, nor will it list minor defects that do not materially affect the value of the property. Any such defects that may be referred to should not imply that the property is free from other such defects. \r\n" +
                "4. External inspections of chimney stacks and upper structures will be made if listed in 1. Instructions - Client\u0027s Brief and/or 2. Scope of Services and where possible and practical from above or by using a 3.0m telescopic ladder. In the event of easy access is not feasible, binocular inspection will be made as an alternative \r\n " +
                "5. Testing of rainwater goods such as gutters and valley gutters will not be carried out, this being beyond the scope of this Structural Survey. Obvious defects visibly apparent at the time of the inspection will be commented upon if listed in the Scope of Services. \r\n " +
                "6. If foundations are not exposed during the Survey and, therefore, we cannot comment as to the type, depth, and thickness of the foundations, nor are we able to determine the type of sub-soil conditions. Where cracking or distortion is evident in walls, the Engineer will comment and advise accordingly. Calculations to check the strength of the structural fabric will not be undertaken. \r\n " +
                "7. Fitted floor coverings and heavy items of furniture will not be moved and, therefore, a total overall inspection of the floor structure will not be able to be made. Access to the sub-floor will, however, be made where possible or practical, but will only be gained where access hatches or loose floorboards are made available. This with the express permission of the Vendor. \r\n" +
                "8. Specialist service tests can be arranged at an additional fee although, unless previously determined, no services tests will be carried out. General overall comments will be made as far as possible and practical. The Engineer will not be responsible for arranging the testing of services unless specifically instructed to do so. \r\n" +
                "9. Easements, Planning Proposals, and relevant Planning and Building Regulations Approvals are considered to be outside the scope of a Building Structural Survey, although general overall comments may be able to be made. \r\n" +
                "10. The Engineer reserves the right to reduce or increase the extent of the Survey according to the circumstances. \r\n" +
                "11. Unless otherwise expressly stated, in making the Report, the following assumptions will be made: \r\n" +
                "(a) that no High Alumina Cement Concrete, calcium chlorate additive, asbestos, or other deleterious or hazardous materials or techniques have been used and that it is impracticable to comment on the state of any wall ties. \r\n" +
                "(b) that the house is not subject to any unusual or especially onerous restrictions, encumbrances, or outgoings and that good title can be shown. \r\n " +
                "(c) that the house and its value are unaffected by any matters which would be revealed by a Local Search (or Search in Scotland ) and Replies to the Usual Enquiries, or by a Statutory Notice, and that neither the property, nor its condition, nor its use, nor its intended use, is or will be unlawful; \r\n" +
                "(d) that inspection of those parts which have not been inspected would not reveal material defects. \r\n" +
                "12. The Report is provided for the sole use of the Client and confidential to the Client and/or their Legal Advisers. The Report is prepared with the skill and care expected of a competent, qualified Engineer, but accepts no responsibility whatsoever to any other person other than the Client. The Report should not be reproduced without express permission from Simplify Structural Engineering LLP. The Engineer will be under no duty to verify these assumptions.",
            brush: PdfBrushes.black,
            font: italicFont,
            format: PdfStringFormat(alignment: PdfTextAlignment.left))
        .draw(
            page: page8,
            bounds: Rect.fromLTWH(20, 50, page8.getClientSize().width - 40,
                page8.getClientSize().height));

    // draw rectangle on pages
    for (int i = 0; i < section.pages.count; i++) {
      section.pages[i].graphics.drawRectangle(
          bounds: Rect.fromLTWH(0, 5, contentPage.getClientSize().width,
              contentPage.getClientSize().height - 5),
          pen: PdfPen(PdfColor(0, 0, 0, 255)));
    }

    // add appendix
    PdfSection appendixSection = document.sections.add();
    appendixSection.template.top = null;
    appendixSection.template.bottom = null;

    appendixSection.pages.add().graphics.drawImage(
        PdfBitmap(await _readImageData('appendix1.png')),
        const Rect.fromLTWH(0, 0, 595, 842));
    appendixSection.pages.add().graphics.drawImage(
        PdfBitmap(await _readImageData('appendix2.png')),
        const Rect.fromLTWH(0, 0, 595, 842));

    //Save and dispose the document.
    final List<int> bytes = document.save();
    document.dispose();

    final String projectNumber = PreferenceHelper.getString(Params.projectNumber);
    final Directory directory = await FileUtils.getProjectDirectory(projectNumber);
    final String path = directory.path;
    String formattedDate = DateFormat('dd.MM.yyyy').format(DateTime.now());
    String filename = "$projectNumber-StrucReport-$formattedDate.pdf";
    final File file = File('$path/$filename');
    bool isExist = await file.exists();
    try {
      if (!isExist) {
        await file.create();
      }
      await file.writeAsBytes(bytes, flush: true);
    }
    catch (e) {
      if (!isExist) {
        await file.create();
      }
      await file.writeAsBytes(bytes, flush: true);
    }

    print("========================= PDF created ======================");
    print('$path/$filename');

    // convert to docx
    String filename2 = "$projectNumber-StrucReport-$formattedDate.docx";
    Dio dio = new Dio(baseOptions);
    dynamic response = await dio.post(
      "upload/pdf",
      data: FormData.fromMap({
        "file": await MultipartFile.fromFile('$path/$filename', filename: 'strucreport.pdf'),
      }),
      onSendProgress: (int sent, int total) {
        print("Progress: Sent - $sent, Total - $total");
      },
    );
    print("Response: $response");

    response = await dio.download(
        "media/$response",
        '$path/$filename2',
        onReceiveProgress: (int received, int total) {
          print("Progress: Received - $received, Total - $total");
        });

    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

    //// Email Send
    final Email email = Email(
      body: "StrucReport",
      subject: "New report created",
      recipients: Application.Emails,
      attachmentPaths: ['$path/$filename2'/*, '$path/$filename'*/],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }
    print("========= Send Email ===============");
    print(platformResponse);
  }

  Future<PdfPageTemplateElement> generateChecklistHeader(PdfPage contentPage) async {
    PdfBorders noBorder = PdfBorders(
        left: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        top: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        bottom: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        right: PdfPen(PdfColor(0, 0, 0, 0), width: 0));
    PdfBorders bottomBorder = PdfBorders(
        left: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        top: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        bottom: PdfPen(PdfColor(0, 0, 0), width: 1),
        right: PdfPen(PdfColor(0, 0, 0, 0), width: 0));
    PdfBorders rightBorder = PdfBorders(
        left: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        top: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        bottom: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        right: PdfPen(PdfColor(0, 0, 0), width: 1));

    PdfPageTemplateElement headerElement = PdfPageTemplateElement(
        const Rect.fromLTWH(0, 0, 555, 120), contentPage);
    headerElement.graphics.setTransparency(1);
    headerElement.graphics.drawImage(
        PdfBitmap(await _readImageData("pdf_logo.png")),
        Rect.fromLTWH(5, 5, 148, 44));
    headerElement.graphics.drawString(
        "Head Office:\r\nLeicester Office: 6 Frederick St, Units 6 & 7 \r\nWigston LE18 1PJ, Tel: 0116 452 0511 \r\n\r\nE: info@simplifyengineering.co.uk",
        PdfStandardFont(PdfFontFamily.helvetica, 8),
        bounds: Rect.fromLTWH(5, 60, 160, 80));

    //Create a grid
    PdfGrid grid = PdfGrid();

    //Adds the columns to the grid
    grid.columns.add(count: 3);
    grid.columns[0].width = 170;
    grid.columns[2].width = 80;

    //Add rows to grid. Set the cells style
    PdfGridRow row1 = grid.rows.add();
    row1.cells[0].value = "";

    // center column
    row1.cells[1].style = PdfGridCellStyle(
        borders: PdfBorders(
            left: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
            top: PdfPen(PdfColor(0, 0, 0), width: 1),
            bottom: PdfPen(PdfColor(0, 0, 0), width: 1),
            right: PdfPen(PdfColor(0, 0, 0), width: 1)));

    PdfGrid grid2 = PdfGrid();
    grid2.columns.add(count: 1);

    PdfGridRow row21 = grid2.rows.add();
    row21.cells[0].style = PdfGridCellStyle(borders: bottomBorder);
    row21.cells[0].value = generateCell("Property Address:", PreferenceHelper.getString(Params.address));

    PdfGridRow row22 = grid2.rows.add();
    row22.cells[0].style = PdfGridCellStyle(borders: bottomBorder);
    row22.cells[0].value = generateCell("Description:", "Inspection Checklist");

    PdfGridRow row23 = grid2.rows.add();
    row23.cells[0].style = PdfGridCellStyle(borders: noBorder);
    String inspector = PreferenceHelper.getString(Params.inspectedBy);
    String secondInspector = PreferenceHelper.getString(Params.inspector2);
    if (secondInspector.isNotEmpty) inspector += ", $secondInspector";
    row23.cells[0].value = generateCell("Inspected by:", inspector);

    row1.cells[1].value = grid2;

    PdfGrid grid3 = PdfGrid();
    grid3.columns.add(count: 1);

    PdfGridRow row31 = grid3.rows.add();
    row31.cells[0].style = PdfGridCellStyle(borders: bottomBorder);
    row31.cells[0].value = generateCell("Job Ref.", getString(Params.projectNumber));

    PdfGridRow row32 = grid3.rows.add();
    row32.cells[0].style = PdfGridCellStyle(borders: bottomBorder);
    row32.cells[0].value = generateCell(
        " ", " ");

    PdfGridRow row33 = grid3.rows.add();
    row33.cells[0].style = PdfGridCellStyle(borders: noBorder);
    row33.cells[0].value = generateCell(
        "Date:", DateFormat('dd/MM/yyyy').format(getDate(Params.inspectedDate)));

    row1.cells[2].value = grid3;
    grid.draw(
        graphics: headerElement.graphics,
        bounds: const Rect.fromLTWH(0, 0, 0, 0));
    return headerElement;
  }

  Future<PdfPageTemplateElement> generateHeader(PdfPage contentPage, {bool isPdf = false}) async {
    PdfBorders noBorder = PdfBorders(
        left: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        top: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        bottom: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        right: PdfPen(PdfColor(0, 0, 0, 0), width: 0));
    PdfBorders bottomBorder = PdfBorders(
        left: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        top: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        bottom: PdfPen(PdfColor(0, 0, 0), width: 1),
        right: PdfPen(PdfColor(0, 0, 0, 0), width: 0));
    PdfBorders rightBorder = PdfBorders(
        left: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        top: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        bottom: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        right: PdfPen(PdfColor(0, 0, 0), width: 1));

    PdfPageTemplateElement headerElement = PdfPageTemplateElement(
        const Rect.fromLTWH(0, 0, 555, 120), contentPage);
    headerElement.graphics.setTransparency(1);
    headerElement.graphics.drawImage(
        PdfBitmap(await _readImageData("pdf_logo.png")),
        Rect.fromLTWH(5, 5, 148, 44));
    headerElement.graphics.drawString(
        "Head Office:\r\nLeicester Office: 6 Frederick St, Units 6 & 7 \r\nWigston LE18 1PJ, Tel: 0116 452 0511 \r\n\r\nE: info@simplifyengineering.co.uk",
        PdfStandardFont(PdfFontFamily.helvetica, 8),
        bounds: Rect.fromLTWH(5, 60, 160, 80));

    //Create a grid
    PdfGrid grid = PdfGrid();

    //Adds the columns to the grid
    grid.columns.add(count: 3);
    grid.columns[0].width = 170;
    grid.columns[2].width = 80;

    //Add rows to grid. Set the cells style
    PdfGridRow row1 = grid.rows.add();
    row1.cells[0].value = "";
    if (!isPdf) {
      row1.cells[0].style = PdfGridCellStyle(
          borders: PdfBorders(
              left: PdfPen(PdfColor(0, 0, 0, 0), width: 1),
              top: PdfPen(PdfColor(0, 0, 0), width: 1),
              bottom: PdfPen(PdfColor(0, 0, 0), width: 1),
              right: PdfPen(PdfColor(0, 0, 0), width: 1)));
    }

    // center column
    row1.cells[1].style = PdfGridCellStyle(
        borders: PdfBorders(
            left: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
            top: PdfPen(PdfColor(0, 0, 0), width: 1),
            bottom: PdfPen(PdfColor(0, 0, 0), width: 1),
            right: PdfPen(PdfColor(0, 0, 0), width: 1)));

    PdfGrid grid2 = PdfGrid();
    grid2.columns.add(count: 4);

    PdfGridRow row21 = grid2.rows.add();
    row21.cells[0].columnSpan = 4;
    row21.cells[0].style = PdfGridCellStyle(borders: bottomBorder);
    row21.cells[0].value = generateCell("Property Address:", PreferenceHelper.getString(Params.address));

    PdfGridRow row22 = grid2.rows.add();
    row22.cells[0].columnSpan = 4;
    row22.cells[0].style = PdfGridCellStyle(borders: bottomBorder);
    row22.cells[0].value = generateCell("Description:", isPdf ? "Inspection Checklist" : getString(Params.inspectionType));

    PdfGridRow row23 = grid2.rows.add();
    row23.cells[0].style = PdfGridCellStyle(borders: rightBorder);
    row23.cells[0].value = generateCell(
        "Prepared by:", StringUtils.ellipsedName(getString(Params.inspectedBy)));
    row23.cells[1].style = PdfGridCellStyle(borders: rightBorder);
    row23.cells[1].value = generateCell(
        "Date:", DateFormat('dd/MM/yyyy').format(getDate(Params.inspectedDate)));
    row23.cells[2].style = PdfGridCellStyle(borders: rightBorder);
    row23.cells[2].value =
        generateCell("Checked by:", StringUtils.ellipsedName(getString(Params.inspectedBy)));
    row23.cells[3].style = PdfGridCellStyle(borders: noBorder);
    row23.cells[3].value = generateCell(
        "Date:", DateFormat('dd/MM/yyyy').format(getDate(Params.inspectedDate)));

    row1.cells[1].value = grid2;

    PdfGrid grid3 = PdfGrid();
    grid3.columns.add(count: 1);

    PdfGridRow row31 = grid3.rows.add();
    row31.cells[0].style = PdfGridCellStyle(borders: bottomBorder);
    row31.cells[0].value = generateCell("Job Ref.", getString(Params.projectNumber));

    PdfGridRow row32 = grid3.rows.add();
    row32.cells[0].style = PdfGridCellStyle(borders: bottomBorder);
    row32.cells[0].value = generateCell(
        "Approved by:", StringUtils.ellipsedName(getString(Params.inspectedBy)));

    PdfGridRow row33 = grid3.rows.add();
    row33.cells[0].style = PdfGridCellStyle(borders: noBorder);
    row33.cells[0].value = generateCell(
        "Date::", DateFormat('dd/MM/yyyy').format(getDate(Params.inspectedDate)));

    row1.cells[2].value = grid3;
    if (!isPdf) {
      row1.cells[2].style = PdfGridCellStyle(
          borders: PdfBorders(
              left: PdfPen(PdfColor(0, 0, 0, 0), width: 1),
              top: PdfPen(PdfColor(0, 0, 0), width: 1),
              bottom: PdfPen(PdfColor(0, 0, 0), width: 1),
              right: PdfPen(PdfColor(0, 0, 0), width: 1)));
    }
    grid.draw(
        graphics: headerElement.graphics,
        bounds: const Rect.fromLTWH(0, 0, 0, 0));
    return headerElement;
  }

  PdfPageTemplateElement generateFooter(PdfPage contentPage) {
    PdfPageTemplateElement footerElement =
        PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 555, 30), contentPage);
    footerElement.graphics.setTransparency(0.6);
    PdfCompositeField(text: 'Page {0} of {1}', fields: <PdfAutomaticField>[
      PdfPageNumberField(brush: PdfBrushes.black),
      PdfPageCountField(brush: PdfBrushes.black)
    ]).draw(footerElement.graphics, const Offset(500, 10));
    return footerElement;
  }

  dynamic generateCell(String label, String content) {
    PdfBorders border = PdfBorders(
        left: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        top: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        bottom: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
        right: PdfPen(PdfColor(0, 0, 0, 0), width: 0));
    PdfStringFormat labelFormat = PdfStringFormat(
        alignment: PdfTextAlignment.left,
        lineAlignment: PdfVerticalAlignment.middle,
        wordSpacing: 3);
    PdfStringFormat contentFormat = PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
        wordSpacing: 3);
    PdfGridCellStyle labelCellStyle = PdfGridCellStyle(
      borders: border,
      cellPadding: PdfPaddings(left: 3, top: 3),
      font: PdfStandardFont(PdfFontFamily.helvetica, 8),
      format: labelFormat,
    );
    PdfGridCellStyle contentCellStyle = PdfGridCellStyle(
      borders: border,
      cellPadding: PdfPaddings(top: 6, bottom: 6),
      font: PdfStandardFont(PdfFontFamily.helvetica, 10),
      format: contentFormat,
    );

    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 1);
    PdfGridRow row0 = grid.rows.add();
    row0.cells[0].style = labelCellStyle;
    row0.cells[0].value = label;

    PdfGridRow row1 = grid.rows.add();
    row1.cells[0].style = contentCellStyle;
    row1.cells[0].value = content;
    return grid;
  }

  Future<List<int>> _readImageData(String name) async {
    final ByteData data = await rootBundle.load('assets/images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  PdfLayoutResult _addTableOfContents(PdfPage page, String text, Rect bounds,
      int pageNo, double x, double y, PdfPage destPage) {
    final PdfFont font =
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);
    final Size pageNoSize = font.measureString(pageNo.toString());
    page.graphics.drawString(pageNo.toString(), font,
        bounds: Rect.fromLTWH(535 - pageNoSize.width, bounds.top + 5,
            bounds.width, bounds.height));
    String str = text + '   ';
    final num value = font.measureString(text).width.round() + 30;
    for (num i = value;
        i < 555 - font.measureString(pageNo.toString()).width - 10;) {
      str = str + '.';
      i = i + 3.6140000000000003;
    }
    return PdfTextElement(text: str, font: font).draw(
        page: page,
        bounds: Rect.fromLTWH(
            bounds.left, bounds.top + 5, bounds.width, bounds.height));
  }

  PdfLayoutResult writeChecklistRegularParagraph(
      {String text = "", PdfPage page, double left = 20, double top = 0}) {
    PdfFont regularFont = PdfStandardFont(PdfFontFamily.helvetica, 10,
        multiStyle: [PdfFontStyle.regular]);
    print("------ checklist paragraph -------");
    print(text);
    print("top: $top");
    return PdfTextElement(
            text: text,
            brush: PdfBrushes.black,
            font: regularFont,
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(page: page, bounds: Rect.fromLTWH(left, top,
        page.getClientSize().width - left - 20, page.getClientSize().height));
  }

  PdfLayoutResult writeChecklistCommentParagraph(
      {String text = "", PdfPage page, double left = 120, double top = 0}) {
    PdfFont regularFont = PdfStandardFont(PdfFontFamily.helvetica, 8,
        multiStyle: [PdfFontStyle.italic]);
    return PdfTextElement(
        text: text,
        brush: PdfBrushes.black,
        font: regularFont,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left, lineSpacing: 8))
        .draw(page: page, bounds: Rect.fromLTWH(left, top,
        page.getClientSize().width - left - 20, page.getClientSize().height));
  }
  
  String getString(key) {
    return PreferenceHelper.getString(key);
  }
  
  bool getBool(key) {
    return PreferenceHelper.getBool(key);
  }
  
  DateTime getDate(key) {
    return PreferenceHelper.getDate(key);
  }
}
