import 'package:flutter/material.dart';
import './announcements.dart';
import './classes.dart';
import './profile.dart';
import './schedule.dart';
import './chats.dart';
import '../Icons/iconssss_icons.dart';
import 'package:universal_platform/universal_platform.dart';

void main(schoolCode, teachersId) {
  runApp(MyApp(schoolCode, teachersId));
}

class MyApp extends StatefulWidget {
  String schoolCode, teachersId;
  MyApp(this.schoolCode, this.teachersId);
  @override
  _MyAppState createState() => _MyAppState(schoolCode, teachersId);
}

class _MyAppState extends State<MyApp> {
  String schoolCode, teachersId;
  _MyAppState(this.schoolCode, this.teachersId);
  List<Widget> tabs;

  @override
  void initState(){
    super.initState();
    tabs=[
      Classes(schoolCode,teachersId),
      Schedule(schoolCode,teachersId),
      AnnouncementDetailsPage(),
      Chats(schoolCode,teachersId),
      Profile(schoolCode,teachersId)
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
              "TEACHER NAME",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            iconTheme: new IconThemeData(color: Colors.black),
            backgroundColor: Colors.black,
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
              isScrollable: false,
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
              'Teacher Name',
              style: TextStyle(fontSize: 20),
            ),
          ),
          body: TabBarView(
            children: tabs,
          ),
        ),
      );
    }
    return MaterialApp(
        //change it into scaffold and add back button in appbar
        debugShowCheckedModeBanner: false,
        home: home);
    
  }
}