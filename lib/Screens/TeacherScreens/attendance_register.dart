import 'package:Schools/Screens/TeacherScreens/edit_attendance.dart';

import 'attendance.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String schoolname;
String classTeacher;

class AttendanceRegister extends StatefulWidget {
  String className, schoolCode, teachersId, classNumber, section, subject;
  AttendanceRegister(this.className, this.schoolCode, this.teachersId,
      this.classNumber, this.section, this.subject);
  @override
  _AttendanceRegisterState createState() => _AttendanceRegisterState(
      className, schoolCode, teachersId, classNumber, section, subject);
}

class _AttendanceRegisterState extends State<AttendanceRegister> {
  String className, schoolCode, teachersId, classNumber, section, subject;
  _AttendanceRegisterState(this.className, this.schoolCode, this.teachersId,
      this.classNumber, this.section, this.subject);
  CollectionReference ref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref = Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Classes')
        .document(classNumber + '_' + section + '_' + subject)
        .collection('Attendance');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Register'),
      ),
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> docs = snapshot.data.documents;
          if (docs.isEmpty) {
            return Center(
              child: Text('There is no class for this subject.'),
            );
          } else {
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, i) {
                print(stringToTime(docs.elementAt(i).documentID));
                int present = docs
                    .elementAt(i)
                    .data
                    .values
                    .where((element) => true)
                    .length;
                int absent = docs.elementAt(i).data.length - present;
                return Card(
                    child: ListTile(
                  title: Text(
                    stringToTime(docs.elementAt(i).documentID)[0],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    stringToTime(docs.elementAt(i).documentID)[1],
                    style: TextStyle(fontSize: 10),
                  ),
                  trailing: Column(
                    children: [
                      Text(
                        'Present $present',
                        style: TextStyle(
                            color: Colors.green[500],
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Absent $absent',
                        style: TextStyle(
                            color: Colors.red[500],
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditAttendance(
                                ref.path,
                                docs.elementAt(i))));
                  },
                ));
              },
            );
          }
        },
      ),
    );
  }
}
