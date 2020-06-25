import 'package:flutter/material.dart';

class Schedule extends StatelessWidget {
  String schoolCode,teachersId;
  Schedule(this.schoolCode,this.teachersId);
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