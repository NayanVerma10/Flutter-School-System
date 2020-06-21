import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentProfile extends StatefulWidget {
  String schoolCode;
  String studentId;
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
    Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Student')
        .document(studentId)
        .get()
        .then((value) {
      student = value.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: student['first name']+ ' '+ student['last name'],
      ),
      body: Container(
        
      )
    );
  }
}
