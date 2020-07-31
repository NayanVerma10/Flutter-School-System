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
  String schoolCode,teachersId;
  MyAppTeacher(this.schoolCode,this.teachersId);
  @override
  _MyAppTeacherState createState() => _MyAppTeacherState(schoolCode,teachersId);
}

class _MyAppTeacherState extends State<MyAppTeacher> {
  String schoolCode,teachersId;
  _MyAppTeacherState(this.schoolCode,this.teachersId);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.white, accentColor: Colors.black),
        debugShowCheckedModeBanner: false,
        title: 'Aatmanirbhar Institutions',
        home: MyAppTeacherScaffold(schoolCode,teachersId));
  }
}

class MyAppTeacherScaffold extends StatefulWidget {
  String schoolCode, teachersId;
  MyAppTeacherScaffold(this.schoolCode, this.teachersId);
  @override
  _MyAppTeacherScaffoldState createState() =>
      _MyAppTeacherScaffoldState(schoolCode, teachersId);
}

class _MyAppTeacherScaffoldState extends State<MyAppTeacherScaffold> {
  String schoolCode, teachersId, teachersName='';
  _MyAppTeacherScaffoldState(this.schoolCode, this.teachersId);
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
    if (UniversalPlatform.isAndroid) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              teachersName,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
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
          bottomNavigationBar: Builder(
            builder: (context) => BottomNavigationBar(
              currentIndex: _currentIndex,
              selectedItemColor: Theme.of(context).accentColor,
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
      return DefaultTabController(
        length: 5, // Number of Tabs you want
        child: Scaffold(
          appBar: AppBar(
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
