import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:strucreport/screen/screen.dart';

import 'bloc/app_bloc.dart';
import 'bloc/bloc.dart';
import 'config/routes.dart';
import 'library/neumorphic/flutter_neumorphic.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  final routes = Routes();

  @override
  void initState() {
    super.initState();
    AppBloc.applicationBloc.add(ApplicationStartupEvent());
  }

  @override
  void dispose() {
    AppBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return MultiBlocProvider(
        providers: AppBloc.blocProviders,
        child: NeumorphicApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: routes.generateRoute,
          themeMode: ThemeMode.light,
          theme: NeumorphicThemeData(
            defaultTextColor: Color(0xFF3E3E3E),
            baseColor: Color(0xffDDDDDD),
            intensity: 0.5,
            lightSource: LightSource.topLeft,
            depth: 10,
          ),
          darkTheme: neumorphicDefaultDarkTheme.copyWith(
              defaultTextColor: Colors.white70),
          home: BlocBuilder<ApplicationBloc, ApplicationState>(
            builder: (context, app) {
              if (app is ApplicationSetupState) {
                return HomeScreen();
              }
              return SplashScreen();
            },
          ),
        ));
  }
}
