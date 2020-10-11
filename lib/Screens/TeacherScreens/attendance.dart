import 'package:Schools/Screens/TeacherScreens/attendance_register.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';

String schoolname;
String classTeacher;

class Attendance extends StatefulWidget {
  String className, schoolCode, teachersId, classNumber, section, subject;
  Attendance(this.className, this.schoolCode, this.teachersId, this.classNumber,
      this.section, this.subject);
  @override
  _AttendanceState createState() => _AttendanceState(
      className, schoolCode, teachersId, classNumber, section, subject);
}

class _AttendanceState extends State<Attendance> {
  String className, schoolCode, teachersId, classNumber, section, subject;
  _AttendanceState(this.className, this.schoolCode, this.teachersId,
      this.classNumber, this.section, this.subject);
  bool inProcess = true;
  Map<String, bool> map = Map<String, bool>();
  Map<String, int> details = Map<String, int>();
  int count = 0;
  @override
  void initState() {
    LoadData();
  }

  void LoadData() {
    Map<String, bool> tempMap = Map<String, bool>();
    Map<String, int> tempMap1 = Map<String, int>();
    Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Student')
        .where('class', isEqualTo: classNumber)
        .where('section', isEqualTo: section)
        .where('subjects', arrayContains: subject)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        String item = element['rollno'] +
            '#' +
            element['first name'] +
            ' ' +
            element['last name'] +
            '#' +
            element.documentID;
        tempMap[item] = false;
        tempMap1[item] = 0;
      });
      Firestore.instance
          .collection('School')
          .document(schoolCode)
          .collection('Classes')
          .document(classNumber + '_' + section + '_' + subject)
          .collection('Attendance')
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          element.data.forEach((key, value) {
            if (tempMap.containsKey(key)) {
              tempMap1[key] += (value ? 1 : 0);
            }
          });
        });
        setState(() {
        map = tempMap;
        details = tempMap1;
        inProcess = false;
      });
      });
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return inProcess
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: map.keys.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 10,
                    children: [
                      RaisedButton(
                        child: Text(
                          count == map.length ? 'Unselect All' : 'Select All',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          bool val = (!(count == map.length));
                          setState(() {
                            map.forEach((key, value) {
                              setState(() {
                                map[key] = val;
                              });
                            });
                            count = val ? map.length : 0;
                          });
                        },
                        color: Colors.black,
                      ),
                      RaisedButton(
                          child: Text('Submit',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            showLoaderDialog(context, 'Please Wait....');
                            await Firestore.instance
                                .collection('School')
                                .document(schoolCode)
                                .collection('Classes')
                                .document(
                                    classNumber + '_' + section + '_' + subject)
                                .collection('Attendance')
                                .document(timeToString())
                                .setData(map)
                                .catchError((error) {
                              Toast.show('error', context);
                            });
                            Navigator.of(context).pop();
                          },
                          color: Colors.black),
                      RaisedButton(
                          child: Text('Cancel',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.black),
                      RaisedButton(
                          disabledColor: Colors.black,
                          child: Text('Selected : $count',
                              style: TextStyle(color: Colors.white)),
                          onPressed: null,
                          color: Colors.black),
                      RaisedButton(
                          child: Text('Attendance Register',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AttendanceRegister(
                                        className,
                                        schoolCode,
                                        teachersId,
                                        classNumber,
                                        section,
                                        subject)));
                          },
                          color: Colors.black),
                    ],
                  ),
                );
              }
              return Card(
                  child: ListTile(
                leading: Checkbox(
                  value: map[map.keys.elementAt(i - 1)],
                  onChanged: (value) {
                    setState(() {
                      map[map.keys.elementAt(i - 1)] = value;
                      count += value ? 1 : -1;
                    });
                  },
                ),
                title: Text(map.keys.elementAt(i - 1).split('#')[1]),
                subtitle: Text(map.keys.elementAt(i - 1).split('#')[0]),
                trailing: IconButton(
                  icon: Icon(
                    Icons.info,
                    color: Colors.grey,
                  ),
                  onPressed: null,
                  tooltip: details[map.keys.elementAt(i - 1)].toString(),
                ),
                onTap: () {
                  setState(() {
                    count += map[map.keys.elementAt(i - 1)] ? -1 : 1;
                    map[map.keys.elementAt(i - 1)] =
                        (!map[map.keys.elementAt(i - 1)]);
                  });
                },
              ));
            },
          );
  }
}

String timeToString() {
  return DateTime.now().toString().replaceAll(RegExp(r'\.|:|-| '), "");
}

List<String> stringToTime(String createdAt) {
  print('yes');
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  String year = createdAt.substring(0, 4);
  String month = months[int.parse(createdAt.substring(4, 6)) - 1];
  String date = createdAt.substring(6, 8);
  String hours = createdAt.substring(8, 10);
  String min = createdAt.substring(10, 12);
  String mode = 'AM';
  if (int.parse(hours) > 12) {
    hours = (int.parse(hours) - 12).toString();
    mode = 'PM';
  }
  if (int.parse(hours) == 12) {
    mode = 'PM';
  }
  if (int.parse(hours) == 0) {
    hours = '12';
  }
  return ["$month $date, $year", "$hours:$min $mode"];
}

showLoaderDialog(BuildContext context, String text) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text(text)),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
