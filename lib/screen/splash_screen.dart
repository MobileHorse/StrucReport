import 'package:flutter/material.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NeumorphicBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: NeumorphicText(
              "StrucReport",
              textStyle: NeumorphicTextStyle(
                fontSize: 100,
                fontWeight: FontWeight.w900,
              ),
              style: NeumorphicStyle(
                color: Colors.black.withOpacity(0.1),
                shape: NeumorphicShape.flat,
                intensity: 1,
                surfaceIntensity: 1,
                depth: 3,
                lightSource: LightSource.topLeft,
              ),
            )
          ),
        ),
      ),
    );
  }
}
