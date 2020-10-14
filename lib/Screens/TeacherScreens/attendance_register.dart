import 'package:Schools/Screens/TeacherScreens/edit_attendance.dart';
import 'package:Schools/plugins/url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:toast/toast.dart';

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
  List<DocumentSnapshot> docsList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    docsList = List();
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
        actions: [
          FlatButton(
            child: Icon(
              Icons.file_download,
              color: Colors.black,
            ),
            onPressed: () {
              // showLoaderDialog(context, 'Please wait....');
              List<List<List<String>>> str = List<List<List<String>>>();
              List<List<String>> str1 = List<List<String>>();
              List<String> months = List<String>();
              //str.add(s);
              List<Map<String, String>> names = List<Map<String, String>>();
              Map<String, String> name = Map<String, String>();
              List<Set<String>> rollno2 = List<Set<String>>();
              Set<String> rollno1 = Set();
              String month = docsList[0].documentID.substring(0, 6);
              months.add(stringToMonth(month.substring(4, 6)) +
                  ', ${month.substring(0, 4)}');
              docsList.forEach((element) {
                if (month.compareTo(element.documentID.substring(0, 6)) != 0) {
                  //UrlUtils.downloadAttendance(str);
                  rollno2.add(rollno1);
                  rollno1 = Set<String>();
                  names.add(name);
                  name = Map<String, String>();
                  month = element.documentID.substring(0, 6);
                  months.add(stringToMonth(month.substring(4, 6)) +
                      ', ${month.substring(0, 4)}');
                }
                element.data.forEach((key, value) {
                  name[key] = key.split('#')[1];
                  rollno1.add(key);
                });
              });
              rollno2.add(rollno1);
              rollno1 = Set<String>();
              names.add(name);
              name = Map<String, String>();
              int i = 0, count = 0;
              rollno2.forEach((roll) {
                List<String> rollno = roll.toList();
                mergeSort(rollno);
                String m = docsList[count].documentID.substring(0, 6);
                str1 = List<List<String>>();
                str1.add(['Roll Numbers', 'Names']);
                for (int k = 0; k < nums(docsList[count].documentID); k++) {
                  str1[0].add((k + 1).toString());
                }
                rollno.forEach((element) {
                  List<String> s = List<String>();
                  s = [element.split('#')[0], names[i][element]];
                  for (int k = 0; k < nums(docsList[count].documentID); k++) {
                    s.add('');
                  }
                  print(s);
                  str1.add(s);
                });

                docsList.sublist(count).forEach((snapshot) {
                  if (m.compareTo(snapshot.documentID.substring(0, 6)) != 0) {
                    str.add(str1);
                    str1 = List<List<String>>();
                    return;
                  }
                  int j = 0;
                  rollno.forEach((number) {
                    j++;
                    if (snapshot.data[number] != null) {
                      str1[j][day(snapshot.documentID) + 1] =
                          snapshot.data[number] ? 'P' : 'A';
                    }
                  });
                  count++;
                });
                i++;
              });
              str.add(str1);
              str1 = List<List<String>>();
              print(str);
              UrlUtils.downloadAttendance(str, months, context);
            },
          )
        ],
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
          docsList = docs;
          if (docs.isEmpty) {
            return Center(
              child: Text('There is no class for this subject.'),
            );
          } else {
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, i) {
                int present = docs
                    .elementAt(i)
                    .data
                    .values
                    .where((element) => element)
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
                            builder: (context) =>
                                EditAttendance(ref.path, docs.elementAt(i))));
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
