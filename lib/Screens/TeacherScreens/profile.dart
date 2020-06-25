import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  String schoolCode,teachersId;
  Profile(this.schoolCode,this.teachersId);
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