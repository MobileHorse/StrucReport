import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:strucreport/util/color_utils.dart';

import 'image_picker_dialog.dart';

class ImagePickerHandler {
  ImagePickerDialog imagePicker;
  AnimationController _controller;
  ImagePickerListener _listener;

  ImagePickerHandler(this._listener, this._controller);

  openCamera(BuildContext context) async {
    imagePicker.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    cropImage(image, context);
  }

  openGallery(BuildContext context) async {
    imagePicker.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    cropImage(image, context);
  }

  void init() {
    imagePicker = new ImagePickerDialog(this, _controller);
    imagePicker.initState();
  }

  Future cropImage(File image, BuildContext context) async {
    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: Platform.isAndroid
              ? [
            //CropAspectRatioPreset.square,
            //CropAspectRatioPreset.ratio3x2,
            //CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            //CropAspectRatioPreset.ratio16x9
          ]
              : [
            //CropAspectRatioPreset.original,
            //CropAspectRatioPreset.square,
            //CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            //CropAspectRatioPreset.ratio5x3,
            //CropAspectRatioPreset.ratio5x4,
            //CropAspectRatioPreset.ratio7x5,
            //CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Crop',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            title: 'Crop',
          ));
      _listener.userImage(croppedFile);
    }
  }

  showDialog(BuildContext context) {
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}