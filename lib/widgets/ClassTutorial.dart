import 'package:flutter/material.dart';

class ClassTutorial extends StatelessWidget {
  String title1 = 'Class', title2 = 'Tutorial';
  Color c1 = Colors.black54, c2 = Colors.black87;
  FontWeight weight = FontWeight.w600;
  double size = 28.0;
  ClassTutorial(
      {this.title1, this.c1, this.title2, this.c2, this.size, this.weight});
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: size),
        children: <TextSpan>[
          TextSpan(
              text: title1,
              style: TextStyle(fontWeight: FontWeight.w600, color: c1)),
          TextSpan(
              text: title2,
              style: TextStyle(fontWeight: FontWeight.w600, color: c2)),
        ],
      ),
    );
  }
}
