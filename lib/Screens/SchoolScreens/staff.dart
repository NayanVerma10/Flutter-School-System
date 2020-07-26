import 'package:flutter/material.dart';
import 'teachers.dart';
import 'employee.dart';

class Staff extends StatefulWidget {
  final String schoolCode;
  Staff(this.schoolCode);
  @override
  _StaffState createState() => _StaffState(schoolCode);
}

class _StaffState extends State<Staff> {
  String schoolCode;
  _StaffState(this.schoolCode);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    dynamic tabs = [Pagin(schoolCode), Pagin1(schoolCode)];

    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 25,
              color: Colors.white,
            ),
            title: Text(
              "TEACHERS ",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            title: Text(
              "Employees",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
