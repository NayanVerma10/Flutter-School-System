import 'package:flutter/material.dart';

class Announcements extends StatelessWidget {
  String schoolcode,teachersId;
  Announcements(this.schoolcode,this.teachersId);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Behavior',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600
          )
        ),
        ),
    );
  }
}