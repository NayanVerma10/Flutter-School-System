import 'package:flutter/material.dart';

class ClassTutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
            fontSize: 28
        ),
        children: <TextSpan>[
          TextSpan(text: 'Class', style: TextStyle(fontWeight: FontWeight.w600
              , color: Colors.black54)),
          TextSpan(text: 'Tutorial', style: TextStyle(fontWeight: FontWeight.w600
              , color: Colors.black87)),
        ],
      ),
    );
  }
}
