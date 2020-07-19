import 'package:flutter/material.dart';
import 'academics.dart';
import 'classes.dart';
import 'management.dart';
import 'profile.dart';
import 'staff.dart';
import 'addemployee.dart';
import 'addteacher.dart';
import 'addstd.dart';

import '../Icons/iconss_icons.dart';
import '../Icons/iconsss_icons.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:Schools/widgets/add_event.dart';
import 'package:Schools/widgets/add_announcements.dart';

void main(String schoolCode) {
  runApp(MyApp(schoolCode));
}

class MyApp extends StatefulWidget {
  final String schoolCode;

  MyApp(this.schoolCode);

  @override
  _MyAppState createState() => _MyAppState(schoolCode);
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  String schoolCode;
  _MyAppState(this.schoolCode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "add_event": (_) => AddEventPage(),
        "add_announcement": (_) => AddAnnouncementPage(),
      },
      title: 'SCHOOL NAME',
      theme: ThemeData(primaryColor: Colors.black, accentColor: Colors.black),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5, // Number of Tabs you want
        child: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  // Headings of each tab
                  Tab(
                      icon: Icon(Iconsss.book_reader, size: 20),
                      text: 'STUDENTS'),
                  Column(children: <Widget>[
                    Container(
                      height: 20,
                      width: 30,
                      child: Icon(Iconsss.user_cog, size: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('MANAGEMENT'),
                  ]),
                  Column(children: <Widget>[
                    Icon(Iconsss.book, size: 20),
                    SizedBox(
                      height: 10,
                    ),
                    Text('ACADEMICS')
                  ]),
                  Column(children: <Widget>[
                    Icon(Iconss.user_tie, size: 22),
                    SizedBox(height: 9),
                    Text('STAFF')
                  ]),
                  // Tab(icon: Icon(Iconss.user_tie),text: 'STAFF',),
                  // Tab(icon: Icon(Icons.person, size: 30,),text: 'PROFILE',)
                  Column(children: <Widget>[
                    Container(
                      height: 33,
                      child: Icon(Icons.person, size: 33),
                    ),
                    SizedBox(height: 6),
                    Text('PROFILE'),
                    SizedBox(height: 8),
                  ]),
                ],
              ),
              title: Text(
                'SCHOOL NAME',
                style: TextStyle(fontSize: 20),
              ),
            ),
            body: TabBarView(
              children: [
                //What each tab will contain
                Studnets(schoolCode),
                Management(schoolCode),
                Academics(),
                Staff(schoolCode),
                Profile(schoolCode)
              ],
            ),
            floatingActionButton: SpeedDial(
              // both default to 16
              marginRight: 18,
              marginBottom: 20,
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 22.0),
              // this is ignored if animatedIcon is non null
              // child: Icon(Icons.add),

              // If true user is forced to close dial manually
              // by tapping main button and overlay is not rendered.
              closeManually: false,
              curve: Curves.bounceIn,
              overlayColor: Colors.black,
              overlayOpacity: 0,
              onOpen: () => print('OPENING DIAL'),
              onClose: () => print('DIAL CLOSED'),
              tooltip: 'Menu',
              heroTag: 'menu-hero-tag',
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 8.0,
              shape: CircleBorder(),
              children: [
                SpeedDialChild(
                    child: Icon(Icons.person, size: 30, color: Colors.black),
                    backgroundColor: Colors.grey[400],
                    label: 'Add Employee',
                    labelStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEmployee(
                                  schoolCode: schoolCode,
                                )),
                      );
                    }),
                SpeedDialChild(
                    child: Icon(
                      Iconss.user_tie,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.grey[400],
                    label: 'Add Teacher',
                    labelStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTeacher(
                                  schoolCode: schoolCode,
                                )),
                      );
                    }),
                SpeedDialChild(
                  child: Icon(
                    Iconss.user_graduate,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.grey[400],
                  label: 'Add Student',
                  labelStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddStd(
                                schoolCode: schoolCode,
                              )),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
