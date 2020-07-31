import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './profile.dart';
import './subjects.dart';
import '../../Chat/ChatInitialScreen.dart';
import './announcements.dart';
import './StudentsTimeTable.dart';
import '../Icons/iconssss_icons.dart';
import 'package:universal_platform/universal_platform.dart';
import '../LogoutTheUser.dart';

void main(schoolCode, studentId) {
  runApp(MyAppStudent(schoolCode, studentId));
}

class MyAppStudent extends StatefulWidget {
  String schoolCode, studentId;
  MyAppStudent(this.schoolCode, this.studentId);
  @override
  _MyAppStudentState createState() => _MyAppStudentState(schoolCode, studentId);
}

class _MyAppStudentState extends State<MyAppStudent> {
  String schoolCode, studentId;
  _MyAppStudentState(this.schoolCode, this.studentId);

  @override
  Widget build(BuildContext context) {
    Widget home;
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white, accentColor: Colors.black),
      debugShowCheckedModeBanner: false,
      title: 'Aatmanirbhar Institutions',
      home: MyAppStudentScaffold(schoolCode,studentId),
    );
  }
}

class MyAppStudentScaffold extends StatefulWidget {
  String schoolCode, studentId;

  MyAppStudentScaffold(this.schoolCode, this.studentId);

  @override
  _MyAppStudentScaffoldState createState() =>
      _MyAppStudentScaffoldState(schoolCode, studentId);
}

class _MyAppStudentScaffoldState extends State<MyAppStudentScaffold> {
  String schoolCode, studentId;
  _MyAppStudentScaffoldState(this.schoolCode, this.studentId);

  List<Widget> tabs;
  String studentName = '';

  Future<void> loadData() {
    Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Student')
        .document(studentId)
        .get()
        .then((doc) {
      setState(() {
        studentName = doc.data['first name'] + ' ' + doc.data['last name'];
      });
    });
  }

  int _currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    tabs = [
      Subjects(schoolCode, studentId),
      StudentsTimeTable(),
      Announcements(),
      MainChat(schoolCode, studentId, false),
      Profile1(schoolCode, studentId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isAndroid) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              studentName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    logoutTheUser();
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  )),
            ],
          ),
          body: tabs[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: Theme.of(context).accentColor,
            type: BottomNavigationBarType.fixed, //static bar
            iconSize: 20, //iconsze
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.book),

                title: Text(
                  'Subjects',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //backgroundColor: Colors.grey
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.event_note),
                title: Text(
                  'Time Table',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                //backgroundColor: Colors.grey
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Iconssss.bullhorn),
                title: Text(
                  'Bulletin',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //backgroundColor: Colors.grey
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.chat),
                title: Text(
                  'Chat',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // backgroundColor: Colors.grey
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(
                  Icons.person,
                  size: 23,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                //backgroundColor: Colors.grey
              ),
            ],
            onTap: (index) {
              setState(() {
                //  if (index==0){
                //     Navigator.push(context,
                //        MaterialPageRoute(builder: (context) => Classes()));
                //  }else{
                _currentIndex = index;
                // }
              });
            },
          ));
    } else if (UniversalPlatform.isWeb) {
      return DefaultTabController(
        length: 5, // Number of Tabs you want
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                // Headings of each tab
                Tab(icon: Icon(Icons.book, size: 25), text: 'Subjects'),
                Tab(icon: Icon(Icons.event_note, size: 25), text: 'Time Table'),
                Tab(icon: Icon(Iconssss.bullhorn, size: 25), text: 'Bulletin'),
                Tab(
                  icon: Icon(
                    Icons.chat,
                    size: 22,
                  ),
                  text: 'Chats',
                ),
                Tab(
                  icon: Icon(
                    Icons.person,
                    size: 30,
                  ),
                  text: 'Profile',
                )
              ],
            ),
            title: Text(
              studentName,
              style: TextStyle(fontSize: 20),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    logoutTheUser();
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  )),
            ],
          ),
          body: TabBarView(
            children: tabs,
          ),
        ),
      );
    }
  }
}
