import 'package:flutter/material.dart';
import './announcements.dart';
import './classes.dart';
import './profile.dart';
import './schedule.dart';
import './chats.dart';
import '../Icons/iconssss_icons.dart';

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

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    var tabs=[
      Classes(schoolCode,teachersId),
      Schedule(schoolCode,teachersId),
      AnnouncementDetailsPage(),
      Chats(schoolCode,teachersId),
      Profile(schoolCode,teachersId)
  ];
    return MaterialApp(                        //change it into scaffold and add back button in appbar
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        appBar: AppBar(
        title: Text("TEACHER NAME",
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
        bottomNavigationBar:  Builder(builder: (context) =>
        BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.black,
          selectedFontSize: 15, 
          unselectedFontSize: 13,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,          
          type: BottomNavigationBarType.fixed,  //static bar
          iconSize: 20,  //iconsze
          items: [
            BottomNavigationBarItem(             
              backgroundColor: Colors.black,
              icon:  Icon(Icons.book),
                      
              title: Text('Classes',              
              style: TextStyle(
                fontWeight: FontWeight.bold,                
              ),),
            //backgroundColor: Colors.grey
            ),

            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.event_note),
              title: Text('Schedule',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
            //backgroundColor: Colors.grey
            ),
             BottomNavigationBarItem(  
               backgroundColor: Colors.black,            
              icon: Icon(Iconssss.bullhorn),
              title: Text('Bulletin',
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
     )));
  }
}
// Builder(builder: (context) =>
//         BottomNavigationBar(
//           currentIndex: _currentIndex,
//           backgroundColor: Colors.black,
//           selectedFontSize: 15,
//           unselectedFontSize: 13,
//           selectedItemColor: Colors.white,
//           unselectedItemColor: Colors.grey,
//           type: BottomNavigationBarType.fixed,  //static bar
//           iconSize: 20,  //iconsze
//           items: [
//             BottomNavigationBarItem(
//               backgroundColor: Colors.black,
//               icon:  Icon(Icons.book),

//               title: Text('Classes',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),),
//             //backgroundColor: Colors.grey
//             ),

//             BottomNavigationBarItem(
//               backgroundColor: Colors.black,
//               icon: Icon(Icons.event_note),
//               title: Text('Schedule',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold
//               ),),
//             //backgroundColor: Colors.grey
//             ),
//              BottomNavigationBarItem(
//                backgroundColor: Colors.black,
//               icon: Icon(Iconssss.bullhorn),
//               title: Text('Bulletin',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),),
//             //backgroundColor: Colors.grey
//             ),
//             BottomNavigationBarItem(
//               backgroundColor: Colors.black,
//               icon: Icon(Icons.chat),
//               title: Text('Chat',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold
//               ),),
//            // backgroundColor: Colors.grey
//             ),
//              BottomNavigationBarItem(
//                backgroundColor: Colors.black,
//               icon: Icon(Icons.person,
//               size: 23,),
//               title: Text('Profile',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold
//               ),),
//             //backgroundColor: Colors.grey
//             ),
//           ],
//           onTap: (index){
//              setState(() {
//               //  if (index==0){
//               //     Navigator.push(context,
//               //        MaterialPageRoute(builder: (context) => Classes()));
//               //  }else{
//                _currentIndex=index;
//               // }
//              });
//           },
//         ),
//      )
