import 'package:flutter/material.dart';
import 'package:strucreport/model/report_model.dart';

@immutable
abstract class EditorState {}

class EditorCloseState extends EditorState {}

class EditorGeneralInfoState extends EditorState {
  final ReportModel report;

  EditorGeneralInfoState({this.report});
}

class EditorPhotoState extends EditorState {
  final ReportModel report;

  EditorPhotoState({this.report});
}

class EditorExtraState extends EditorState {
  final ReportModel report;

  EditorExtraState({this.report});
}

class EditorReporterState extends EditorState {
  final ReportModel report;

  EditorReporterState({this.report});
}

class EditorPreviewState extends EditorState {
  final ReportModel report;

  EditorPreviewState({this.report});
}