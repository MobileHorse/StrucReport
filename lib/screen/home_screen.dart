import 'package:flutter/material.dart';
import 'package:strucreport/config/routes.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _letter(String letter) {
    return Text(letter,
        style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w800,
            fontFamily: 'Roboto',
            fontSize: 80));
  }

  Widget _firstBox() {
    return Neumorphic(
      margin: EdgeInsets.symmetric(horizontal: 4),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
      ),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: -1,
          oppositeShadowLightSource: true,
          color: Colors.white.withOpacity(0.3)
        ),
        padding: EdgeInsets.all(2),
        child: SizedBox(
          width: 40,
          height: 60,
        ),
      ),
    );
  }

  Widget _secondBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 4),
      child: Transform.rotate(
        angle: 0.79,
        child: Neumorphic(
          style: NeumorphicStyle(
            lightSource: LightSource.topLeft,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
          ),
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: -1,
              oppositeShadowLightSource: true,
              lightSource: LightSource.topLeft,
                color: Colors.white.withOpacity(0.3)
            ),
            child: SizedBox(
              width: 50,
              height: 50,
            ),
          ),
        ),
      ),
    );
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
              SizedBox(height: 80),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _letter("S"),
                  _letter("t"),
                  _letter("r"),
                  _firstBox(),
                  _letter("c"),
                  _letter("R"),
                  _letter("e"),
                  _letter("p"),
                  _secondBox(),
                  _letter("r"),
                  _letter("t"),
                ],
              ),
              SizedBox(height: 120,),
              NeumorphicButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.editor);
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
