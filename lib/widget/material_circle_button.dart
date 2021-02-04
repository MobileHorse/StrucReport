import 'package:flutter/material.dart';

class MaterialCircleButton extends StatelessWidget {

  final VoidCallback onTap;
  final Widget icon;
  final double padding;

  MaterialCircleButton({@required this.onTap, @required this.icon, this.padding = 8});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: icon,
        ),
      ),
    );
  }
}
