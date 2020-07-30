import 'package:Schools/Screens/SchoolScreens/calendar.dart';
import 'package:Schools/widgets/ColumnReusableCardButton.dart';
import 'package:Schools/widgets/RowReusableCardButton.dart';
import 'package:flutter/material.dart';
import './AddCSVStudents.dart';
import './AddCSVteachers.dart';
import 'announcemments.dart';
import 'calendar.dart';

/*class Management extends StatefulWidget {
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
*/



class Management extends StatefulWidget {
  final String schoolCode;

  Management(this.schoolCode);
  @override
  _ManagementState createState() => _ManagementState(schoolCode);
}


class _ManagementState extends State<Management> {
  String schoolCode;

  _ManagementState(this.schoolCode);
  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(


        extendBody: true,
        body: Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0,top: 10),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: [
                    ColumnReusableCardButton(
                      label: 'Delete Database Collections',
                      height: 70,
                      tileColor: Colors.red[900],
                      icon: Icons.delete_outline,
                      onPressed: () {
                                         },
                    ),

                    Container(
                      height: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          RowReusableCardButton(
                            label: 'Event Calendar',
                            tileColor: Colors.black87,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Calendar(schoolCode)));
                            },
                            icon: Icons.calendar_today,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          RowReusableCardButton(
                            label: 'TimeTable',
                            tileColor: Colors.black87,
                            icon: Icons.av_timer,
                            onPressed: () {
                            },
                          ),
                        ],
                      ),
                    ),
                    ColumnReusableCardButton(
                      label: 'Create Announcements',
                      height: 70,
                      tileColor: Colors.blueGrey,
                      icon: Icons.announcement,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Announcements(schoolCode)));                      },
                    ),
                    ColumnReusableCardButton(
                      label: 'Edit Profile',
                      height: 70,
                      tileColor: Colors.black54,
                      icon: Icons.edit_attributes,
                      onPressed: () {
                       /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profile(schoolCode)));*/
                      },
                    ),
                    Container(
                      height: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          RowReusableCardButton(
                            label: 'Teachers DB',
                            tileColor: Colors.black87,
                            icon:Icons.add_circle_outline,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddCSVTeachers(schoolCode)));
                            }
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          RowReusableCardButton(
                            label: 'Students DB',
                            tileColor: Colors.black87,
                            icon: Icons.add_circle,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddCSVStudents(schoolCode)));
                            },
                          ),
                        ],
                      ),
                    ),
                    ColumnReusableCardButton(
                      label: 'Employee DB',
                      height: 70,
                      tileColor: Colors.black54,
                      icon: Icons.add,
                      onPressed: () {
                        /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profile(schoolCode)));*/
                      },
                    ),


                        ],
                      ),
                    ),

                  ],
                ),
              ),
          ),
        );
  }
}

