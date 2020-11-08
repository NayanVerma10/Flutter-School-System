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
              if (docsList.isEmpty) {
                Toast.show('Nothing to download', context);
              }
              // List<List<List<String>>> str = List<List<List<String>>>();
              // List<List<String>> str1 = List<List<String>>();
              // List<String> months = List<String>();
              // List<Map<String, String>> names = List<Map<String, String>>();
              // Map<String, String> name = Map<String, String>();
              // List<Set<String>> rollno2 = List<Set<String>>();
              // Set<String> rollno1 = Set();
              // String month = docsList[0].documentID.substring(0, 6);
              // months.add(stringToMonth(month.substring(4, 6)) +
              //     ', ${month.substring(0, 4)}');
              // docsList.forEach((element) {
              //   if (month.compareTo(element.documentID.substring(0, 6)) != 0) {
              //     rollno2.add(rollno1);
              //     rollno1 = Set<String>();
              //     names.add(name);
              //     name = Map<String, String>();
              //     month = element.documentID.substring(0, 6);
              //     months.add(stringToMonth(month.substring(4, 6)) +
              //         ', ${month.substring(0, 4)}');
              //   }
              //   element.data.forEach((key, value) {
              //     name[key] = key.split('#')[1];
              //     rollno1.add(key);
              //   });
              // });
              // rollno2.add(rollno1);
              // rollno1 = Set<String>();
              // names.add(name);
              // name = Map<String, String>();
              // int i = 0, count = 0;
              // rollno2.forEach((roll) {
              //   List<String> rollno = roll.toList();
              //   mergeSort(rollno);
              //   String m = docsList[count].documentID.substring(0, 6);
              //   str1 = List<List<String>>();
              //   str1.add(['Roll Numbers', 'Names']);
              //   for (int k = 0; k < nums(docsList[count].documentID); k++) {
              //     str1[0].add((k + 1).toString());
              //   }
              //   rollno.forEach((element) {
              //     List<String> s = List<String>();
              //     s = [element.split('#')[0], names[i][element]];
              //     for (int k = 0; k < nums(docsList[count].documentID); k++) {
              //       s.add('');
              //     }
              //     print(s);
              //     str1.add(s);
              //   });

              //   docsList.sublist(count).forEach((snapshot) {
              //     if (m.compareTo(snapshot.documentID.substring(0, 6)) != 0) {
              //       str.add(str1);
              //       str1 = List<List<String>>();
              //       return;
              //     }
              //     int j = 0;
              //     rollno.forEach((number) {
              //       j++;
              //       if (snapshot.data[number] != null) {
              //         str1[j][day(snapshot.documentID) + 1] =
              //             snapshot.data[number] ? 'P' : 'A';
              //       }
              //     });
              //     count++;
              //   });
              //   i++;
              // });
              // str.add(str1);
              // str1 = List<List<String>>();
              // print(str);
              // UrlUtils.downloadAttendance(str, months, context);
              try {
                Excel excel = Excel.createExcel();
                Sheet sheet = excel['Sheet1'];
                int i = 1;
                print('yes');
                sheet
                    .cell(
                        CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 0))
                    .value = 'Roll Number';
                sheet
                    .cell(
                        CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 1))
                    .value = 'Name of the Student';
                int j = 2;
                docsList.forEach((element) {
                  print(stringToTime(element.documentID)[0]);
                  sheet
                      .cell(CellIndex.indexByColumnRow(
                          rowIndex: 0, columnIndex: j))
                      .value = stringToTime(element.documentID)[0]+', '+stringToTime(element.documentID)[1];
                  j++;
                });

                print('yes');
                i = 1;
                keys.forEach((element) {
                  sheet
                      .cell(CellIndex.indexByColumnRow(
                          columnIndex: 0, rowIndex: i))
                      .value = keys.elementAt(i - 1).split('#')[0];
                  sheet
                      .cell(CellIndex.indexByColumnRow(
                          columnIndex: 1, rowIndex: i))
                      .value = keys.elementAt(i - 1).split('#')[1];
                  i++;
                });
                i = 1;
                keys.forEach((element) {
                  j = 2;
                  docsList.forEach((ele) {
                    print(ele.data[element]);
                    if (ele.data[element] != null) {
                      CellStyle style = CellStyle(
                          fontColorHex:
                              ele.data[element] ? '03B147' : '#FF0000',
                          bold: true,
                          fontFamily: getFontFamily(FontFamily.Arial));
                      sheet
                          .cell(CellIndex.indexByColumnRow(
                              columnIndex: j, rowIndex: i))
                          .cellStyle = style;
                      sheet
                          .cell(CellIndex.indexByColumnRow(
                              columnIndex: j, rowIndex: i))
                          .value = ele.data[element] ? 'P' : 'A';
                    }
                    j++;
                  });
                  i++;
                });
                excel.encode().then((value) async {
                  await UrlUtils.downloadGradesExcel(
                      value, 'attendance', context);
                });
              } catch (e) {
                print(e);
                Toast.show('Some error occured', context);
              }
            },
          ),
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
          docs.forEach((element) {
            element.data.forEach((key, value) {
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
