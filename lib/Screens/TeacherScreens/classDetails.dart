import 'package:flutter/material.dart';
import './assignment.dart';
import './attendance.dart';
import './behavior.dart';
import '../Icons/iconssss_icons.dart';
import '../Icons/my_flutter_app_icons.dart';
import './students.dart';
import './tutorials.dart';
//import 'iconss_icons.dart';
import '../Icons/iconsss_icons.dart';

class ClassDetails extends StatefulWidget {
  final String className;
  ClassDetails({Key key, this.className}) : super(key: key);
  @override
  _ClassDetailsState createState() => _ClassDetailsState(className);
}
  
class _ClassDetailsState extends State<ClassDetails> {
  final String className;
_ClassDetailsState(this.className);

  int _currentIndex=0;
 
  @override
  Widget build(BuildContext context) {
    var tabs=[
     Students(),
     Tutorials(),
     Assignments(),
     Behavior(),
     Attendance()     
  ];
  
    return Scaffold(
      appBar:AppBar(
        title: Text(className,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        ), 
        iconTheme: new IconThemeData(color: Colors.white), 
        backgroundColor: Colors.black,          
             ),
      body: tabs[_currentIndex],
       floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat,
        color: Colors.white,
        ),
        backgroundColor: Colors.black,
        onPressed:null
//          (){
//            Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => Discussions()));
//         },
      ),
        bottomNavigationBar:BottomNavigationBar(
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
              icon:  Icon(Iconsss.book_reader,
              size: 17,
              ),                      
              title: Text('Students',              
              style: TextStyle(
                fontWeight: FontWeight.bold,                
              ),),
            //backgroundColor: Colors.grey
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Iconsss.book),
              title: Text('Tutorials',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
            //backgroundColor: Colors.grey
            ),
             BottomNavigationBarItem(  
               backgroundColor: Colors.black,            
              icon: Icon(Icons.assignment),
              title: Text('Assignments',
              style: TextStyle(
                fontWeight: FontWeight.bold,               
              ),),
            //backgroundColor: Colors.grey
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(MyFlutterApp.thumbs_up_down),
              title: Text('Behavior',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
           // backgroundColor: Colors.grey
            ),
             BottomNavigationBarItem(
               backgroundColor: Colors.black,
              icon: Container(              
                padding: EdgeInsets.all(0),
                height: 20,
                width: 30,
                child: Icon(Iconssss.user_check,
              size: 17,
              )
              ),
              title: Text('Attendance',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
            //backgroundColor: Colors.grey
            ),
          ],
          onTap: (index){
             setState(() {              
               _currentIndex=index;               
             });
          },
        ),
      
    );
  }
}
