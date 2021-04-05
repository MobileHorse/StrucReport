import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:strucreport/config/routes.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';
import 'package:strucreport/util/preference_helper.dart';
import 'package:strucreport/util/toasts.dart';
import 'package:strucreport/widget/confirm_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  checkPermission() async {
    bool checkResult =
    await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
    if (!checkResult) {
      var status = await SimplePermissions.requestPermission(
          Permission.WriteExternalStorage);
      if (status == PermissionStatus.authorized) {
      } else {
        ToastUtils.showErrorToast(context, "You must enable permission");
        SystemNavigator.pop();
      }
    } else {
    }
  }

  Widget _letter(String letter) {
    return Text(letter,
        style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w800,
            fontFamily: 'Roboto',
            fontSize: 80));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NeumorphicBackground(
          child: Column(
            children: [
              SizedBox(height: 24),
              _buildTopBar(context),
              SizedBox(height: 40),
              Image.asset('assets/images/logo.png', width: 160,),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _letter("S"),
                  _letter("t"),
                  _letter("r"),
                  _letter("u"),
                  _letter("c"),
                  _letter("t"),
                  _letter("C"),
                  _letter("h"),
                  _letter("e"),
                  _letter("c"),
                  _letter("k"),
                  _letter("l"),
                  _letter("i"),
                  _letter("s"),
                  _letter("t"),
                ],
              ),
              SizedBox(height: 100,),
              NeumorphicButton(
                onPressed: () {
                  if (PreferenceHelper.getKeys() == null || PreferenceHelper.getKeys().isEmpty) {
                    Navigator.pushNamed(context, Routes.editor);
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return ConfirmDialog(
                          message: "Do you want to continue from drafts?",
                          btnYes: "Yes, continue draft",
                          btnNo: "No, start new",
                          btnCancel: "Cancel",
                          onYes: () {
                            Navigator.pushNamed(context, Routes.editor);
                          },
                          onNo: () async {
                            await PreferenceHelper.clear();
                            Navigator.pushNamed(context, Routes.editor);
                          },
                          onCancel: () {

                          },
                        );
                      },
                    );
                  }
                },
                style: NeumorphicStyle(
                  surfaceIntensity: 0.15,
                  boxShape: NeumorphicBoxShape.circle(),
                  shape: NeumorphicShape.concave,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Icon(
                      Icons.add,
                      color: NeumorphicTheme.of(context).isUsingDark ? Colors.white : Colors.black,
                      size: 64,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
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
                NeumorphicTheme.of(context).isUsingDark ? Icons.wb_sunny : Icons.nights_stay,
                color: NeumorphicTheme.of(context).isUsingDark ? Colors.white : Colors.black,
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
