import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strucreport/bloc/bloc.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/screen/editor/extra_info_screen.dart';
import 'package:strucreport/screen/editor/general_info_screen.dart';
import 'package:strucreport/screen/editor/photo_screen.dart';
import 'package:strucreport/screen/editor/preview_screen.dart';
import 'package:strucreport/screen/editor/reportor_screen.dart';
import 'package:strucreport/util/color_utils.dart';

class EditorScreen extends StatefulWidget {
  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  EditorBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = EditorBloc();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditorBloc>.value(
        value: bloc,
        child: WillPopScope(
          onWillPop: () async {
            bloc.add(EditorPrevEvent());
            return false;
          },
          child: BlocListener<EditorBloc, EditorState>(
            listener: (context, state) {
              if (state is EditorCloseState) {
                Navigator.pop(context);
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: NeumorphicBackground(
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      _buildTopBar(context),
                      SizedBox(height: 40),
                      Expanded(child: BlocBuilder<EditorBloc, EditorState>(
                        builder: (context, state) {
                          if (state is EditorGeneralInfoState) {
                            return GeneralInfoScreen();
                          } else if (state is EditorPhotoState) {
                            return PhotoScreen();
                          } else if (state is EditorExtraState) {
                            return ExtraInfoScreen();
                          } else if (state is EditorReporterState) {
                            return ReporterScreen();
                          } else if (state is EditorPreviewState) {
                            return PreviewScreen();
                          } else {
                            return GeneralInfoScreen();
                          }
                        },
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: NeumorphicButton(
              padding: const EdgeInsets.all(18.0),
              onPressed: () {
                bloc.add(EditorPrevEvent());
              },
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              child: Icon(
                Icons.navigate_before,
                color: NeumorphicTheme.defaultTextColor(context),
                size: 36,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: BlocBuilder<EditorBloc, EditorState>(
              builder: (context, state) {
                String title = "";
                if (state is EditorGeneralInfoState) {
                  title = "General Info";
                } else if (state is EditorPhotoState) {
                  title = "Photos";
                } else if (state is EditorExtraState) {
                  title = "Extra Info";
                } else if (state is EditorReporterState) {
                  title = "Reporter";
                } else if (state is EditorPreviewState) {
                  title = "Send";
                } else {
                  title = "General Info";
                }
                return Text(
                  title,
                  style: TextStyle(
                      color: NeumorphicTheme.defaultTextColor(context),
                      fontSize: 28),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 88),
              child: NeumorphicButton(
                padding: const EdgeInsets.all(18.0),
                onPressed: () {
                  if (NeumorphicTheme.of(context).isUsingDark) {
                    NeumorphicTheme.of(context).themeMode = ThemeMode.light;
                  } else {
                    NeumorphicTheme.of(context).themeMode = ThemeMode.dark;
                  }
                },
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.circle(),
                ),
                child: Icon(
                  NeumorphicTheme.of(context).isUsingDark
                      ? Icons.wb_sunny
                      : Icons.nights_stay,
                  color: NeumorphicTheme.defaultTextColor(context),
                  size: 36,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: NeumorphicButton(
              padding: const EdgeInsets.all(18.0),
              onPressed: () {
                Navigator.pop(context);
              },
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              child: Icon(
                Icons.home,
                color: NeumorphicTheme.defaultTextColor(context),
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
