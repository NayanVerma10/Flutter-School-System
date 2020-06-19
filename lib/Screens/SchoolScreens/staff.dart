import 'package:flutter/material.dart';
import 'teachers.dart';
import 'employee.dart';
class Staff extends StatefulWidget {
  @override
  _StaffState createState() => _StaffState();
}
class _StaffState extends State<Staff> {
 int _currentIndex=0;
 final tabs=[
   Pagin(),
   Pagin1()
 ];
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
            icon: Icon(Icons.person,size: 25,color: Colors.white,),
            title: Text("Teachers ",style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.white,
          ),
            BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Colors.white,),
            title: Text("Employees",style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.white,
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