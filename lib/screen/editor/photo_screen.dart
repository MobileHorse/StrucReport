import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strucreport/bloc/bloc.dart';
import 'package:strucreport/config/application.dart';
import 'package:strucreport/config/params.dart';
import 'package:strucreport/library/image_picker/image_picker_handler.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/model/photo_model.dart';
import 'package:strucreport/model/report_model.dart';
import 'package:strucreport/util/preference_helper.dart';
import 'package:strucreport/widget/label_widget.dart';
import 'package:strucreport/widget/material_circle_button.dart';
import 'package:strucreport/widget/photo_edit_dialog.dart';

class PhotoScreen extends StatefulWidget {
  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  EditorBloc bloc;
  List<PhotoModel> photos;
  AnimationController _imgPickerAnimationController;
  ImagePickerHandler _imagePicker;
  String _selectedCategory;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<EditorBloc>(context);
    photos = PreferenceHelper.getPhotos(Params.photos);
    _imgPickerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _imagePicker = ImagePickerHandler(this, _imgPickerAnimationController);
    _imagePicker.init();
  }

  @override
  void dispose() {
    _imgPickerAnimationController.dispose();
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
                      children: [
                        SizedBox(
                          height: 8,
                          width: double.infinity,
                        ),
                        ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: Application.PhotoCategories.length,
                          separatorBuilder: (context, index) => SizedBox(
                            height: 20,
                          ),
                          itemBuilder: (context, index) => buildPhotoCategory(
                              Application.PhotoCategories[index]),
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
                EditorPhotoState state = bloc.state;
                ReportModel report = state.report;
                report.photos = photos;
                bloc.add(EditorPrevEvent(report: report));
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
                EditorPhotoState state = bloc.state;
                ReportModel report = state.report;
                report.photos = photos;
                bloc.add(EditorPhotoNextEvent(report: report));
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

  Widget buildPhotoCategory(String category) {
    List<PhotoModel> categoryPhotos =
        photos.where((element) {
          return element.category == category;
        }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: LabelWidget(label: category),
            ),
            SizedBox(
              width: 20,
            ),
            NeumorphicButton(
              onPressed: () {
                _selectedCategory = category;
                _imagePicker.showDialog(context);
              },
              style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.circle(),
                  shape: NeumorphicShape.concave),
              child: Icon(
                Icons.add,
                size: 32,
                color: NeumorphicTheme.defaultTextColor(context),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        categoryPhotos.length > 0
            ? SizedBox(
                height: 300,
                child: ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categoryPhotos.length,
                  itemBuilder: (context, index) =>
                      buildPhotoItem(categoryPhotos[index]),
                  separatorBuilder: (context, index) => SizedBox(width: 20,),
                ),
              )
            : Container()
      ],
    );
  }

  Widget buildPhotoItem(PhotoModel item) {
    String caption = "";
    int index = 0;
    if (item.inReport) {
      for (int i = 0; i < photos.length; i++) {
        if (photos[i].inReport) {
          index++;
        }
        if (item == photos[i]) break;
      }
      caption = "Photo $index - " + item.caption;
    }
    return Stack(
      children: [
        Column(
          children: [
            Image.file(
              item.image,
              width: 320,
              height: 240,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 320,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: NeumorphicTheme.defaultTextColor(context)),
                ),
              ),
            )
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Row(
            children: [
              MaterialCircleButton(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return PhotoEditDialog(
                          photo: item.image,
                          category: item.category,
                          inReport: item.inReport,
                          caption: item.caption,
                          onOK: (value) {
                            setState(() {
                              photos[photos.indexOf(item)] = value;
                              PreferenceHelper.savePhotos(Params.photos, photos);
                            });
                          },
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.settings, color: Colors.yellow, size: 28,),),
              MaterialCircleButton(
                onTap: () {
                  setState(() {
                    photos.remove(item);
                    PreferenceHelper.savePhotos(Params.photos, photos);
                  },);
                },
                icon: Icon(Icons.delete_forever, color: Colors.yellow, size: 28,),),
            ],
          ),
        )
      ],
    );
  }

  @override
  userImage(File _image) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PhotoEditDialog(
          photo: _image,
          category: _selectedCategory,
          onOK: (value) {
            setState(() {
              photos.add(value);
              PreferenceHelper.savePhotos(Params.photos, photos);
            });
          },
        );
      },
    );
  }
}
