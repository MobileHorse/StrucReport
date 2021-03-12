import 'dart:io';

import 'package:flutter/material.dart';
import 'package:strucreport/config/application.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/model/photo_model.dart';
import 'package:strucreport/util/color_utils.dart';

import 'dropdown_widget.dart';
import 'label_widget.dart';

class PhotoEditDialog extends StatefulWidget {

  final File photo;
  final String category;
  final ValueSetter<PhotoModel> onOK;
  final bool inReport;
  final String caption, comment;

  PhotoEditDialog({this.photo, this.onOK, this.category, this.inReport, this.caption, this.comment = ""});

  @override
  _PhotoEditDialogState createState() => _PhotoEditDialogState();
}

class _PhotoEditDialogState extends State<PhotoEditDialog> {

  bool inReport;
  String caption;
  TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    commentController.text = widget.comment;
    inReport = widget.inReport ?? false;
    caption = widget.caption == null || widget.caption.isEmpty ? Application.PhotoCaptions[0] : widget.caption;
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: NeumorphicTheme.of(context).current.baseColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.file(widget.photo, width: 600, height: 400, fit: BoxFit.cover,),
          SizedBox(height: 30,),
          Row(
            children: [
              LabelWidget(label: "Show in report: "),
              SizedBox(width: 20,),
              NeumorphicCheckbox(
                value: inReport,
                onChanged: (value) {
                setState(() {
                  inReport = value;
                });
              },)
            ],
          ),
          SizedBox(height: 30,),
          Visibility(
            visible: inReport,
            child: DropdownWidget(
              label: "Caption: ",
              initial: caption,
              values: Application.PhotoCaptions,
              padding: 0,
              onChange: (val) {
                setState(() {
                  caption = val;
                });
              },
            ),
          ),
          SizedBox(height: 20,),
          Neumorphic(
            style: NeumorphicStyle(
              depth: NeumorphicTheme.embossDepth(context),
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
            ),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: TextField(
              controller: commentController,
              onChanged: (value) async {
              },
              style: TextStyle(
                  fontSize: 20,
                  color: ColorUtils.textColorByTheme(context)
              ),
              maxLines: 3,
              decoration: InputDecoration.collapsed(hintText: "Comment", hintStyle: TextStyle(fontSize: 20, color: NeumorphicTheme.defaultTextColor(context))),
            ),
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NeumorphicButton(
                onPressed: () {
                  Navigator.pop(context);
                  PhotoModel model = PhotoModel(image: widget.photo, category: widget.category, inReport: inReport, caption: caption, comment: commentController.text);
                  widget.onOK(model);
                },
                child: Text("OK", style: TextStyle(color: ColorUtils.textColorByTheme(context), fontSize: 20),),
              ),
              SizedBox(width: 30,),
              NeumorphicButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: ColorUtils.textColorByTheme(context), fontSize: 20)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
