import 'package:flutter/material.dart';
import 'package:strucreport/screen/screen.dart';

class Routes {

  static const String editor = "/editor";

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case editor:
        return MaterialPageRoute(builder: (context) => EditorScreen());

      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text("Not Found"),
              ),
              body: Center(
                child: Text('No path for ${settings.name}'),
              ),
            ));
    }
  }

  ///Singleton factory
  static final Routes _instance = Routes._internal();
  factory Routes() {
    return _instance;
  }
  Routes._internal();
}