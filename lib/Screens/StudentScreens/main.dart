import 'package:flutter/material.dart';
import './profile.dart';
import './subjects.dart';
import './chat.dart';
import './announcements.dart';
import './timeTable.dart';
import '../Icons/iconssss_icons.dart';

void main(schoolCode, studentId) {
  runApp(MyApp(schoolCode, studentId));
}

class MyApp extends StatefulWidget {
  String schoolCode, studentId;
  MyApp(this.schoolCode, this.studentId);
  @override
  _MyAppState createState() => _MyAppState(schoolCode, studentId);
}

class _MyAppState extends State<MyApp> {
  String schoolCode, studentId;
  _MyAppState(this.schoolCode, this.studentId);
  List tabs;

  int _currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabs = [
      Subjects(schoolCode, studentId),
      TimeTable(),
      Announcements(),
      Chats(),
      Profile()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //change it into scaffold and add back button in appbar
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.black, accentColor: Colors.black),
        home: Scaffold(
            appBar: AppBar(
              title: Text(
                "STUDENT NAME",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              iconTheme: new IconThemeData(color: Colors.black),
            ),
            body: tabs[_currentIndex],
            
            
    ));
  }
}
