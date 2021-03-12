import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strucreport/bloc/bloc.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc() : super(EditorGeneralInfoState());

  @override
  Stream<EditorState> mapEventToState(EditorEvent event) async* {
    if (event is EditorGeneralNextEvent) {
      yield* _mapEditorGeneralNextEventToState(event);
    } else if (event is EditorPhotoNextEvent) {
      yield* _mapEditorPhotoNextEventToState(event);
    } else if (event is EditorExtraNextEvent) {
      yield* _mapEditorExtraNextEventToState(event);
    } else if (event is EditorReporterNextEvent) {
      yield* _mapEditorReporterNextEventToState(event);
    } else if (event is EditorPrevEvent) {
      yield* _mapEditorPrevEventToState(event);
    }
  }

  Stream<EditorState> _mapEditorGeneralNextEventToState(
      EditorGeneralNextEvent event) async* {
    yield EditorPhotoState();
  }

  Stream<EditorState> _mapEditorPhotoNextEventToState(
      EditorPhotoNextEvent event) async* {
    yield EditorExtraState();
  }

  Stream<EditorState> _mapEditorExtraNextEventToState(
      EditorExtraNextEvent event) async* {
    yield EditorReporterState();
  }

  Stream<EditorState> _mapEditorReporterNextEventToState(
      EditorReporterNextEvent event) async* {
    yield EditorPreviewState();
  }

  Stream<EditorState> _mapEditorPrevEventToState(EditorPrevEvent event) async* {
    if (state is EditorGeneralInfoState) {
      yield EditorCloseState();
    } else if (state is EditorPhotoState) {
      yield EditorGeneralInfoState();
    } else if (state is EditorExtraState) {
      yield EditorPhotoState();
    } else if (state is EditorReporterState) {
      yield EditorExtraState();
    } else if (state is EditorPreviewState) {
      yield EditorReporterState();
    }
  }
}
