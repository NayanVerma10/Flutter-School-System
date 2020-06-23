import 'package:Schools/Screens/SchoolScreens/calendar.dart';
import 'package:flutter/material.dart';

import 'announcemments.dart';
import 'calendar.dart';

class Management extends StatefulWidget {
  final String schoolCode;

  Management(this.schoolCode);
  @override
  _ManagementState createState() => _ManagementState(schoolCode);
}

class _ManagementState extends State<Management> {
  _ManagementState(String schoolCode);

  @override
  Widget build(BuildContext context) {
    String schoolCode;
    return Container(
      margin: const EdgeInsets.only(top: 30.0),
      child: new Column(
        children: <Widget>[
                   Padding(
    padding: const EdgeInsets.all(20),
    child: new RaisedButton(
            padding: EdgeInsets.all(30),
            child: new Text(
              "Announcements ",
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.8),
            ),
            color: Colors.blueAccent[600],
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Announcements(schoolCode)));
            },
          ),
          ),
           Padding(
    padding: const EdgeInsets.all(20),
    child:new RaisedButton(
            padding: EdgeInsets.all(30),
            child: new Text(
              "Events Calendar",
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.8),
            ),
            color: Colors.blueAccent[600],
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Calendar(schoolCode)));
            },
          ),
           ),
 
           Padding(
    padding: const EdgeInsets.all(20),
    child:new RaisedButton(
            padding: EdgeInsets.all(30),
            child: new Text(
              "Delete Collection",
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.8),
            ),
            color: Colors.blueAccent[600],
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Calendar(schoolCode)));
            },
          ),
           )
        ],
      ),
    );
  }
}
