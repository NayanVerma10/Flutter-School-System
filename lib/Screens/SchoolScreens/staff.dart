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
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).accentColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 25,
            ),
            title: Text(
              "TEACHERS ",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            title: Text(
              "Employees",
            ),
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
