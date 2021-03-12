import 'package:flutter/material.dart';
import 'package:strucreport/library/neumorphic/flutter_neumorphic.dart';

import 'text_content_widget.dart';

class ConfirmDialog extends StatefulWidget {

  final String message, btnYes, btnNo, btnCancel;
  final VoidCallback onYes, onNo, onCancel;

  ConfirmDialog({this.message = "", this.btnCancel = "", this.btnYes = "", this.btnNo = "", this.onYes, this.onNo, this.onCancel});

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(50),
      backgroundColor: NeumorphicTheme.of(context).current.baseColor,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 50,),
          Text(
            widget.message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: NeumorphicTheme.defaultTextColor(context),
            ),
          ),
          SizedBox(height: 80,),
          NeumorphicButton(
            style: NeumorphicStyle(shape: NeumorphicShape.convex),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: TextContentWidget(
                  fontSize: 28,
                  text: widget.btnYes,
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              if (widget.onYes != null) widget.onYes();
            },
          ),
          SizedBox(height: 40,),
          NeumorphicButton(
            style: NeumorphicStyle(shape: NeumorphicShape.convex),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: TextContentWidget(
                  fontSize: 28,
                  text: widget.btnNo,
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              if (widget.onNo != null) widget.onNo();
            },
          ),
          SizedBox(height: 40,),
          NeumorphicButton(
            style: NeumorphicStyle(shape: NeumorphicShape.convex),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: TextContentWidget(
                  fontSize: 28,
                  text: widget.btnCancel,
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              if (widget.onCancel != null) widget.onCancel();
            },
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }
}
