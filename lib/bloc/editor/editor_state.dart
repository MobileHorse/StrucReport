import 'package:flutter/material.dart';

@immutable
abstract class EditorState {}

class EditorCloseState extends EditorState {}

class EditorGeneralInfoState extends EditorState {
}

class EditorPhotoState extends EditorState {
}

class EditorExtraState extends EditorState {
}

class EditorReporterState extends EditorState {
}

class EditorPreviewState extends EditorState {
}