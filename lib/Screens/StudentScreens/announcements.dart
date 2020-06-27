import 'package:flutter/material.dart';

class Announcements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Announcements',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600
          )
        ),
        ),
    );
  }
}