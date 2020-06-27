import 'package:flutter/material.dart';
import './assignment.dart';
import './attendance.dart';
import './behavior.dart';
import '../Icons/iconssss_icons.dart';
import '../Icons/my_flutter_app_icons.dart';
import './students.dart';
import './tutorials.dart';
import '../Icons/iconsss_icons.dart';
import './Discussions.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class ClassDetails extends StatefulWidget {
  final String className, schoolCode, teachersId, classNumber, section, subject;
  ClassDetails(
      {Key key,
      this.className,
      this.schoolCode,
      this.teachersId,
      this.classNumber,
      this.section,
      this.subject})
      : super(key: key);
  @override
  _ClassDetailsState createState() => _ClassDetailsState(
      className, schoolCode, teachersId, classNumber, section, subject);
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

class _ClassDetailsState extends State<ClassDetails> 
{
  final String className, schoolCode, teachersId, classNumber, section, subject;
  _ClassDetailsState(this.className, this.schoolCode, this.teachersId,
  this.classNumber, this.section, this.subject);
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var tabs = [
      Students(),
      Tutorials(),
      Assignments(),
      Behavior(
          className, schoolCode, teachersId, classNumber, section, subject),
      Attendance(className, schoolCode, teachersId, classNumber, section, subject)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          className,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        iconTheme: new IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: tabs[_currentIndex],
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Discussions(
                      className: className,
                      schoolCode: schoolCode,
                      teachersId: teachersId,
                      classNumber: classNumber,
                      section: section,
                      subject: subject)));
        },
      ),
      bottomNavigationBar: StyleProvider(
  style: Style(),
  child: ConvexAppBar(
    initialActiveIndex: 0,
    height: 45,
    top: -30,
    curveSize: 100,
    style: TabStyle.titled,
    items: [
      TabItem(title: "Students",icon:  Icon(Iconsss.book_reader,size: 17,)),
      TabItem(title: "Tutorials",icon:  Icon(Iconsss.book)),
      TabItem(title: "Assignments",icon:  Icon(Icons.assignment)),
      TabItem(title: "Behavior",icon:  Icon(MyFlutterApp.thumbs_up_down)),      
      TabItem(title: "Attendance",icon:  Container(              
                padding: EdgeInsets.all(0),
                height: 20,
                width: 30,
                child: Icon(Iconssss.user_check,
              size: 17,
              )
              ),)

      
    ],
    backgroundColor: Colors.black,    
    onTap: (index){
             setState(() {            
               _currentIndex=index;
              
             });
          },
  )
  )

      
    );
  }
}
// BottomNavigationBar(
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
//               icon:  Icon(Iconsss.book_reader,
//               size: 17,
//               ),                      
//               title: Text('Students',              
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,                
//               ),),
//             //backgroundColor: Colors.grey
//             ),
//             BottomNavigationBarItem(
//               backgroundColor: Colors.black,
//               icon: Icon(Iconsss.book),
//               title: Text('Tutorials',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold
//               ),),
//             //backgroundColor: Colors.grey
//             ),
//              BottomNavigationBarItem(  
//                backgroundColor: Colors.black,            
//               icon: Icon(Icons.assignment),
//               title: Text('Assignments',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,               
//               ),),
//             //backgroundColor: Colors.grey
//             ),
//             BottomNavigationBarItem(
//               backgroundColor: Colors.black,
//               icon: Icon(MyFlutterApp.thumbs_up_down),
//               title: Text('Behavior',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold
//               ),),
//            // backgroundColor: Colors.grey
//             ),
//              BottomNavigationBarItem(
//                backgroundColor: Colors.black,
              // icon: Container(              
              //   padding: EdgeInsets.all(0),
              //   height: 20,
              //   width: 30,
              //   child: Icon(Iconssss.user_check,
              // size: 17,
              // )
              // ),
//               title: Text('Attendance',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold
//               ),),
//             //backgroundColor: Colors.grey
//             ),
//           ],
//           onTap: (index){
//              setState(() {              
//                _currentIndex=index;               
//              });
//           },
//         ),
