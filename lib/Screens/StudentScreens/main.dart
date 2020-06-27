import 'package:flutter/material.dart';
import './profile.dart';
import './subjects.dart';
import './chat.dart';
import './announcements.dart';
import './timeTable.dart';
import '../Icons/iconssss_icons.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

void main(schoolCode,studentId) {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex=0;
  final tabs=[
      Subjects(),
      TimeTable(),
      Announcements(),
      Chats(),
      Profile()
  ];
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
        bottomNavigationBar: Builder(builder: (context) =>
        BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.black,
          selectedFontSize: 15, 
          unselectedFontSize: 13,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,          
          type: BottomNavigationBarType.shifting,  //static bar
          iconSize: 20,  //iconsze
          items: [
            BottomNavigationBarItem(             
              backgroundColor: Colors.black,
              icon:  Icon(Icons.book),
                      
              title: Text('Subjects',              
              style: TextStyle(
                fontWeight: FontWeight.bold,                
              ),),
            //backgroundColor: Colors.grey
            ),

            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.event_note),
              title: Text('Time Table',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
            //backgroundColor: Colors.grey
            ),
             BottomNavigationBarItem(  
               backgroundColor: Colors.black,            
              icon: Icon(Iconssss.bullhorn),
              title: Text('Announcements',
              style: TextStyle(
                fontWeight: FontWeight.bold,               
              ),),
            //backgroundColor: Colors.grey
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.chat),
              title: Text('Chat',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
           // backgroundColor: Colors.grey
            ),
             BottomNavigationBarItem(
               backgroundColor: Colors.black,
              icon: Icon(Icons.person,
              size: 23,),
              title: Text('Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
            //backgroundColor: Colors.grey
            ),
          ],
          onTap: (index){
             setState(() {
              //  if (index==0){
              //     Navigator.push(context,
              //        MaterialPageRoute(builder: (context) => Classes())); 
              //  }else{
               _currentIndex=index;
              // }
             });
          },
        ),
     )) );
  }
}

