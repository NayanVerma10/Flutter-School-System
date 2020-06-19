import 'package:flutter/material.dart';
import 'addemployee.dart';
import 'addteacher.dart';
import '../Icons/iconss_icons.dart';
// import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'addstd.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


class Classes extends StatelessWidget {
  String schoolCode;

  Classes(this.schoolCode);

  @override
  Widget build(BuildContext context) {
    
      return Scaffold(
       body: SingleChildScrollView(
         child: Container(
           child: Text('')
         ),
          
        ),
        floatingActionButton: SpeedDial(
          // both default to 16
          marginRight: 18,
          marginBottom: 20,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          // this is ignored if animatedIcon is non null
          // child: Icon(Icons.add),
          
          // If true user is forced to close dial manually 
          // by tapping main button and overlay is not rendered.
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'Menu',
          heroTag: 'menu-hero-tag',
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.person, size: 30, color: Colors.black),
              backgroundColor: Colors.grey[400],
              label: 'Add Employee',
              labelStyle: TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
              onTap: () {
                Navigator.push(
                   context,
                 MaterialPageRoute(builder: (context) => AddEmployee(schoolCode: schoolCode,)),
                   );
              }
            ),
            SpeedDialChild(
              child: Icon(Iconss.user_tie,color: Colors.black,),
              backgroundColor: Colors.grey[400],
              label: 'Add Teacher',
              labelStyle: TextStyle(fontSize: 15.0,color: Colors.black, fontWeight: FontWeight.bold),
              onTap: () {
                Navigator.push(
                   context,
                 MaterialPageRoute(builder: (context) => AddTeacher(schoolCode: schoolCode,)),
                   );
              }
            ),
            SpeedDialChild(
              child: Icon(Iconss.user_graduate, color: Colors.black,),
              backgroundColor: Colors.grey[400],
              label: 'Add Student',
              labelStyle: TextStyle(fontSize: 15.0,color: Colors.black, fontWeight: FontWeight.bold),
              onTap: () {
                Navigator.push(
                   context,
                 MaterialPageRoute(builder: (context) => AddStd(schoolCode: schoolCode,)),
                   );
              },
            ),
          ],
        ),
      
    );
  }

}