import 'dart:io';

import 'package:strucreport/config/application.dart';

class PhotoModel {
  File image;
  String category, caption;
  bool inReport;

  PhotoModel({this.image, this.category = "", this.caption = "", this.inReport = false});

  factory PhotoModel.fromString(String value) {
    List<String> elements = value.split(Application.photoElementDelimiter);
    return PhotoModel(image: File(elements[0]), category: elements[1], caption: elements[2], inReport: elements[3] == "1" ? true : false);
  }

  @override
  String toString() {
    return image.path + Application.photoElementDelimiter + category + Application.photoElementDelimiter + caption + Application.photoElementDelimiter + (inReport ? "1" : "0");
  }
}