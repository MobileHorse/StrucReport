import 'package:flutter/material.dart';

@immutable
abstract class EditorEvent {}

class EditorGeneralNextEvent extends EditorEvent {
}

class EditorPhotoNextEvent extends EditorEvent {
}

class EditorExtraNextEvent extends EditorEvent {
}

class EditorPrevEvent extends EditorEvent {
}