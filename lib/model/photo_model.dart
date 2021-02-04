import 'dart:io';

class PhotoModel {
  File image;
  String category, caption;
  bool inReport;

  PhotoModel({this.image, this.category = "", this.caption = "", this.inReport = false});
}