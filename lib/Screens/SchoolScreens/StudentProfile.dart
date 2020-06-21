import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentProfile extends StatefulWidget {
  final String schoolCode;
  final String studentId;
  StudentProfile({this.schoolCode, this.studentId});
  @override
  _StudentProfileState createState() =>
      _StudentProfileState(schoolCode, studentId);
}

class _StudentProfileState extends State<StudentProfile> {
  String schoolCode;
  String studentId;
  _StudentProfileState(this.schoolCode, this.studentId);

  Map<String, dynamic> student;

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Student')
        .document(studentId)
        .get()
        .then((value) {student=value.data;}).then((value){print(student);});
        
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' dsa'),
      ),
      body: Container(
        child: Text(student['first name']),
      )
    );
  }
}
