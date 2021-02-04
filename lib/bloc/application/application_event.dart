import 'package:meta/meta.dart';

@immutable
abstract class ApplicationEvent {}

class ApplicationStartupEvent extends ApplicationEvent {}