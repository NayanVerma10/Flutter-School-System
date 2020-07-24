import 'package:flutter/material.dart';
import './profile.dart';
import './subjects.dart';
import './chat.dart';
import './announcements.dart';
import './timeTable.dart';
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
  List<Widget> tabs;

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
    Widget home;
    if (UniversalPlatform.isAndroid) {
      home = Scaffold(
          appBar: AppBar(
            title: Text(
              "STUDENT NAME",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            iconTheme: new IconThemeData(color: Colors.black),
            backgroundColor: Colors.black,
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    logoutTheUser();
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
          body: tabs[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            backgroundColor: Colors.black,
            selectedFontSize: 15,
            unselectedFontSize: 13,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
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
      home = DefaultTabController(
        length: 5, // Number of Tabs you want
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
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
              'Student Name',
              style: TextStyle(fontSize: 20),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    logoutTheUser();
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
          body: TabBarView(
            children: tabs,
          ),
        ),
      );
    }
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black, accentColor: Colors.black),
      debugShowCheckedModeBanner: false,
      home: home,
    );
  }
}
