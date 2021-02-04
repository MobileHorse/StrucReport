import 'package:flutter/material.dart';
import 'package:strucreport/model/report_model.dart';

@immutable
abstract class EditorEvent {}

class EditorGeneralNextEvent extends EditorEvent {
  final ReportModel report;

  EditorGeneralNextEvent({this.report});
}

class EditorPhotoNextEvent extends EditorEvent {
  final ReportModel report;

  EditorPhotoNextEvent({this.report});
}

class EditorExtraNextEvent extends EditorEvent {
  final ReportModel report;

  EditorExtraNextEvent({this.report});
}

class EditorReporterNextEvent extends EditorEvent {
  final ReportModel report;

  EditorReporterNextEvent({this.report});
}

class EditorPrevEvent extends EditorEvent {
  final ReportModel report;

  EditorPrevEvent({this.report});
}