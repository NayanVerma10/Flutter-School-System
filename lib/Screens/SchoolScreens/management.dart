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
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 30.0),
      child: new Column(
        children: <Widget>[
          Padding(padding: const EdgeInsets.all(20)),
          ButtonTheme(
            minWidth: 350.0,
            height: 80.0,
            buttonColor: Colors.black,
            hoverColor: Colors.blueGrey[200],
            child: new RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)),
              padding: EdgeInsets.all(30),
              child: new Text("Announcements ",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Announcements(schoolCode)));
              },
            ),
          ),
          Padding(padding: const EdgeInsets.all(20)),

          ButtonTheme(
            minWidth: 350.0,
            height: 80.0,
            buttonColor: Colors.black,
            hoverColor: Colors.blueGrey[200],
            child: new RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)),
              padding: EdgeInsets.all(30),
              child: new Text("Events Calendar",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Calendar(schoolCode)));
              },
            ),
          ),
          Padding(padding: const EdgeInsets.all(20)),

          ButtonTheme(
            minWidth: 350.0,
            height: 80.0,
            buttonColor: Colors.black,
            hoverColor: Colors.red[800],
            child: new RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)),
              padding: EdgeInsets.all(30),
              child: new Text(" Delete Collections ",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
              color: Colors.blueAccent[600],
              onPressed: () {},
            ),
          )
          //  )
        ],
      ),
    );
  }
}
