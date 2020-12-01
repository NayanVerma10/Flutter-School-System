import 'dart:collection';

import 'package:Schools/Screens/TeacherScreens/edit_attendance.dart';
import 'package:Schools/plugins/url_launcher/url_launcher.dart';
import 'package:excel/excel.dart';
import 'package:toast/toast.dart';

import 'attendance.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String schoolname;
String classTeacher;

class AttendanceRegister extends StatefulWidget {
  final String className, schoolCode, teachersId, classNumber, section, subject;
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
  Set<String> keys;
  @override
  void initState() {
    super.initState();
    docsList = List();
    keys = Set<String>();
    ref = FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection('Classes')
        .doc(classNumber + '_' + section + '_' + subject)
        .collection('Attendance');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Register'),
        actions: [
          Builder(builder: (conte) {
            return FlatButton(
              child: Icon(
                Icons.file_download,
                color: Colors.black,
              ),
              onPressed: () {
                if (docsList.length == 0) {
                  Toast.show('Nothing to download', context);
                }
                try {
                  Excel excel = Excel.createExcel();
                  Sheet sheet = excel['Sheet1'];
                  int i = 1;
                  sheet
                      .cell(CellIndex.indexByColumnRow(
                          rowIndex: 0, columnIndex: 0))
                      .value = 'Roll Number';
                  sheet
                      .cell(CellIndex.indexByColumnRow(
                          rowIndex: 0, columnIndex: 1))
                      .value = 'Name of the Student';
                  int j = 2;
                  docsList.forEach((element) {
                    sheet
                            .cell(CellIndex.indexByColumnRow(
                                rowIndex: 0, columnIndex: j))
                            .value =
                        stringToTime(element.id)[0] +
                            ', ' +
                            stringToTime(element.id)[1];
                    j++;
                  });

                  i = 1;
                  List<String> keysList = keys.toList();
                  keysList.sort();
                  keysList.forEach((element) {
                    sheet
                        .cell(CellIndex.indexByColumnRow(
                            columnIndex: 0, rowIndex: i))
                        .value = keysList.elementAt(i - 1).split('#')[0];
                    sheet
                        .cell(CellIndex.indexByColumnRow(
                            columnIndex: 1, rowIndex: i))
                        .value = keysList.elementAt(i - 1).split('#')[1];
                    i++;
                  });
                  i = 1;
                  keysList.forEach((element) {
                    j = 2;
                    docsList.forEach((ele) {
                      if (ele.data()[element] != null) {
                        CellStyle style = CellStyle(
                            fontColorHex:
                                ele.data()[element] ? '03B147' : '#FF0000',
                            bold: true,
                            fontFamily: getFontFamily(FontFamily.Arial));
                        sheet
                            .cell(CellIndex.indexByColumnRow(
                                columnIndex: j, rowIndex: i))
                            .cellStyle = style;
                        sheet
                            .cell(CellIndex.indexByColumnRow(
                                columnIndex: j, rowIndex: i))
                            .value = ele.data()[element] ? 'P' : 'A';
                      }
                      j++;
                    });
                    i++;
                  });
                  excel.encode().then((value) async {
                    await UrlUtils.downloadGradesExcel(
                        value, 'attendance', conte);
                  });
                } catch (e) {
                  print(e);
                  Toast.show('Some error occured', context);
                }
              },
            );
          }),
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
          List<DocumentSnapshot> docs = snapshot.data.docs;
          docsList = docs;
          docs.forEach((element) {
            element.data().forEach((key, value) {
              keys.add(key);
            });
          });
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
                    .data()
                    .values
                    .where((element) => element)
                    .length;
                int absent = docs.elementAt(i).data().length - present;
                return Card(
                    child: ListTile(
                  title: Text(
                    stringToTime(docs.elementAt(i).id)[0],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    stringToTime(docs.elementAt(i).id)[1],
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
