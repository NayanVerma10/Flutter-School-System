import 'package:flutter/material.dart';
import './profile.dart';
import './subjects.dart';
import './chat.dart';
import './announcements.dart';
import './timeTable.dart';
import '../Icons/iconssss_icons.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

void main(schoolCode,studentId) {
  runApp(MyApp(schoolCode,studentId));
}

class MyApp extends StatefulWidget {
  String schoolCode,studentId;
  MyApp(this.schoolCode,this.studentId);
  @override
  _MyAppState createState() => _MyAppState(schoolCode,studentId);
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 20;

  @override
  double get activeIconMargin => 12;

  @override
  double get iconSize => 10;

  @override
  TextStyle textStyle(Color color) {
    return TextStyle(fontSize: 15, color: color);
  }
}

class _MyAppState extends State<MyApp> {
  String schoolCode,studentId;
  _MyAppState(this.schoolCode,this.studentId);
  List tabs;

  int _currentIndex=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabs=[
      Subjects(schoolCode,studentId),
      TimeTable(),
      Announcements(),
      Chats(),
      Profile()
  ];
  
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(     //change it into scaffold and add back button in appbar
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        appBar: AppBar(
        title: Text("STUDENT NAME",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        ), 
        iconTheme: new IconThemeData(color: Colors.black), 
        backgroundColor: Colors.black,
        ),
        body: tabs[_currentIndex],
        bottomNavigationBar:  StyleProvider(
  style: Style(),
  child: ConvexAppBar(
    initialActiveIndex: 0,
    height: 45,
    top: -30,
    curveSize: 100,
    style: TabStyle.titled,
    items: [
      TabItem(title: "Subjects",icon:  Icon(Icons.book)),
      TabItem(title: "Time Table",icon:  Icon(Icons.event_note)),
      TabItem(title: "Bulletin",icon:  Icon(Iconssss.bullhorn)),
      TabItem(title: "Chats",icon:  Icon(Icons.chat)),      
      TabItem(title: "Profile",icon:  Icon(Icons.person,size: 30,)),

      
    ],
    backgroundColor: Colors.black,    
    onTap: (index){
             setState(() {            
               _currentIndex=index;
              
             });
          },
  )
  )
     ) );
  }
}
