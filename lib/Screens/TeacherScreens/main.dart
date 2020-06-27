import 'package:flutter/material.dart';
import './announcements.dart';
import './classes.dart';
import './profile.dart';
import './schedule.dart';
import './chats.dart';
import '../Icons/iconssss_icons.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

void main(schoolCode,teachersId) {
  runApp(MyApp(schoolCode,teachersId));
}
class MyApp extends StatefulWidget {
  String schoolCode,teachersId;
  MyApp(this.schoolCode,this.teachersId);
  @override
  _MyAppState createState() => _MyAppState(schoolCode,teachersId);
}


class _MyAppState extends State<MyApp> {
  String schoolCode,teachersId;
  _MyAppState(this.schoolCode,this.teachersId);

  int _currentIndex=0;
  
  @override
  Widget build(BuildContext context) {

    var tabs=[
      Classes(schoolCode,teachersId),
      Schedule(schoolCode,teachersId),
      Announcements(schoolCode,teachersId),
      Chats(schoolCode,teachersId),
      Profile(schoolCode,teachersId)
  ];
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
 

    return MaterialApp(     //change it into scaffold and add back button in appbar
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.black
        ),
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
        bottomNavigationBar: 
         StyleProvider(
  style: Style(),
  child: ConvexAppBar(
    initialActiveIndex: 0,
    height: 45,
    top: -30,
    curveSize: 100,
    style: TabStyle.titled,
    items: [
      TabItem(title: "Classes",icon:  Icon(Icons.book)),
      TabItem(title: "Schedule",icon:  Icon(Icons.event_note)),
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
