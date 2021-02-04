import 'package:meta/meta.dart';

@immutable
abstract class ApplicationState {}

class ApplicationInitialState extends ApplicationState {}

class ApplicationLoadingState extends ApplicationState {}

class ApplicationSetupState extends ApplicationState {}