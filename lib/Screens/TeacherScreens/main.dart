import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './announcements.dart';
import './classes.dart';
import './profile.dart';
import './schedule.dart';
import '../../Chat/ChatInitialScreen.dart';
import '../Icons/iconssss_icons.dart';
import 'package:universal_platform/universal_platform.dart';
import '../LogoutTheUser.dart';

void main(schoolCode, teachersId) {
  runApp(MyAppTeacher(schoolCode, teachersId));
}

class MyAppTeacher extends StatefulWidget {
  String schoolCode, teachersId;
  MyAppTeacher(this.schoolCode, this.teachersId);
  @override
  _MyAppTeacherState createState() =>
      _MyAppTeacherState(schoolCode, teachersId);
}

class _MyAppTeacherState extends State<MyAppTeacher> {
  String schoolCode, teachersId, teachersName='';
  _MyAppTeacherState(this.schoolCode, this.teachersId);
  List<Widget> tabs;

  Future<void> loadData(){
    Firestore.instance.collection('School').document(schoolCode).collection('Teachers').document(teachersId).get().then((doc) {
      setState(() {
        teachersName = doc['first name']+' '+doc.data['last name'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
    tabs = [
      Classes(schoolCode, teachersId),
      TeachersTimeTable(),
      AnnouncementDetailsPage(),
      MainChat(schoolCode, teachersId, true),
      Profile1(schoolCode, teachersId)
    ];
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget home;

    if (UniversalPlatform.isAndroid) {
      home = Scaffold(
          appBar: AppBar(
            title: Text(
              teachersName,
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
          bottomNavigationBar: Builder(
            builder: (context) => BottomNavigationBar(
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
                    'Classes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.black,
                  icon: Icon(Icons.event_note),
                  title: Text(
                    'Schedule',
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
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.black,
                  icon: Icon(Icons.chat),
                  title: Text(
                    'Chat',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                ),
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  // }
                });
              },
            ),
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
                Tab(icon: Icon(Icons.book, size: 25), text: 'Classes'),
                Tab(icon: Icon(Icons.event_note, size: 25), text: 'Schedule'),
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
              teachersName,
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
        title: 'Aatmanirbhar Institutions',
        home: home);
  }
}
