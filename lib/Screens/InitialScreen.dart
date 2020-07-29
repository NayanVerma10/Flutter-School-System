import 'dart:ui';

import 'package:flutter/material.dart';

import 'SchoolLogin.dart';
import 'TeachersLogin.dart';
import 'StudentLogin.dart';
import './Icons/iconss_icons.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          child: Image.asset('assets/images/LOGO.jpeg'),
        ),
        leadingWidth: 40,
        titleSpacing: 10,
        title: Text('aatmanirbhar institutions'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Spacer(),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton.icon(
                color: Colors.black,
                textColor: Colors.white,
                padding: EdgeInsets.all(50),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentLogin(),
                      ));
                },
                icon: Icon(Iconss.user_graduate),
                label: Text('Student'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton.icon(
                color: Colors.black,
                textColor: Colors.white,
                padding: EdgeInsets.all(50),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TeachersLogin()));
                },
                icon: Icon(Iconss.user_tie),
                label: Text('Teacher'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton.icon(
                color: Colors.black,
                textColor: Colors.white,
                padding: EdgeInsets.all(50),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SchoolLogin()));
                },
                icon: Icon(Icons.school),
                label: Text('School'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
