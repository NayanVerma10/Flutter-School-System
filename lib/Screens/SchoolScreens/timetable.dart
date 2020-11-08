import 'package:Schools/plugins/url_launcher/url_launcher.dart';
import 'package:Schools/widgets/AlertDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class TimeTable extends StatefulWidget {
  String schoolname, schoolCode;
  TimeTable(this.schoolname, this.schoolCode);

  @override
  _TimeTableState createState() => _TimeTableState(schoolname, schoolCode);
}

class _TimeTableState extends State<TimeTable> {
  String schoolname, schoolCode;
  bool isClassSelected = false, isSectionSelected = false, loading = true;
  String selectedClass = "Select Class",
      selectedSection = "Select Section",
      breakTimings;
  Map<String, Set<String>> cs = Map<String, Set<String>>();
  Map<String, Set<String>> css = Map<String, Set<String>>();
  TextEditingController stc, etc;
  _TimeTableState(this.schoolname, this.schoolCode);
  List<String> startTime, endTime, Timings, days;
  List<TimeOfDay> temp1, temp2;
  @override
  void initState() {
    super.initState();
    loadData();
    isClassSelected = false;
    isSectionSelected = false;
    loading = true;
    selectedClass = "Select Class";
    selectedSection = "Select Section";
    cs = Map<String, Set<String>>();
    css = Map<String, Set<String>>();
    stc = TextEditingController(text: 'Select');
    etc = TextEditingController(text: 'Select');
    startTime = List<String>();
    endTime = List<String>();
    Timings = List<String>();
    temp1 = List<TimeOfDay>();
    temp2 = List<TimeOfDay>();
    breakTimings = 'Set break timings';
    for (int i = 0; i < 5; i++) {
      Timings.add('Set Lecture ${i + 1} timings');
      startTime.add('');
      endTime.add('');
      temp1.add(TimeOfDay.now());
      temp2.add(TimeOfDay.now());
    }
    for (int i = 4; i < 9; i++) {
      Timings.add('Set Lecture ${i + 1} timings');
      startTime.add('');
      endTime.add('');
      temp1.add(TimeOfDay.now());
      temp2.add(TimeOfDay.now());
    }
    days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
  }

  void loadData() {
    Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Student')
        .getDocuments()
        .then((value) {
      if (value != null) {
        List<DocumentSnapshot> docs = value.documents;
        Map<String, Set<String>> cs1 = Map<String, Set<String>>();
        Map<String, Set<String>> css1 = Map<String, Set<String>>();
        docs.forEach((element) {
          if (cs1[element.data['class']] == null) {
            cs1[element.data['class']] = Set<String>();
          }
          cs1[element.data['class']].add(element.data['section']);
          if (css1[element.data['class'] + '_' + element.data['section']] ==
              null) {
            css1[element.data['class'] + '_' + element.data['section']] =
                Set<String>();
          }
          element.data['subjects'].forEach((subject) {
            css1[element.data['class'] + '_' + element.data['section']]
                .add(subject);
          });
        });
        setState(() {
          loading = false;
          cs = cs1;
          css = css1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(schoolname),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                      child: ListTile(
                    title: Text(selectedClass),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      String temp = await showDialog<String>(
                          context: context,
                          builder: (context) => Dialog(
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: cs.keys.length,
                                  separatorBuilder: (context, index) => Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Colors.black26,
                                      ),
                                  itemBuilder: (context, i) {
                                    return ListTile(
                                        title: Text(
                                          cs.keys.elementAt(i),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () {
                                          Navigator.pop(
                                              context, cs.keys.elementAt(i));
                                        });
                                  })));
                      if (temp != null) {
                        setState(() {
                          isClassSelected = true;
                          selectedClass = temp;
                          isSectionSelected = false;
                          selectedSection = "Select Section";
                        });
                      } else {
                        setState(() {
                          isClassSelected = false;
                          selectedClass = "Select Class";
                          isSectionSelected = false;
                          selectedSection = "Select Section";
                        });
                      }
                    },
                  )),
                  Card(
                      child: ListTile(
                    title: Text(selectedSection),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: !isClassSelected
                        ? () {
                            Toast.show(
                                "Select a class before selecting section.",
                                context);
                          }
                        : () async {
                            String temp = await showDialog<String>(
                                context: context,
                                builder: (context) => Dialog(
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: cs[selectedClass].length,
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                              height: 1,
                                              thickness: 1,
                                              color: Colors.black26,
                                            ),
                                        itemBuilder: (context, i) {
                                          return ListTile(
                                              title: Text(
                                                cs[selectedClass].elementAt(i),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onTap: () {
                                                Navigator.pop(
                                                    context,
                                                    cs[selectedClass]
                                                        .elementAt(i));
                                              });
                                        })));
                            if (temp != null) {
                              setState(() {
                                isSectionSelected = true;
                                selectedSection = temp;
                              });
                            } else {
                              setState(() {
                                isSectionSelected = false;
                                selectedSection = 'Select Section';
                              });
                            }
                          },
                  )),
                  TimingsWidget(1),
                  TimingsWidget(2),
                  TimingsWidget(3),
                  TimingsWidget(4),
                  BreakTimings(),
                  TimingsWidget(6),
                  TimingsWidget(7),
                  TimingsWidget(8),
                  TimingsWidget(9),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    child:
                        Text('Download excel sheet for uploading Time Table'),
                    onPressed: () async {
                      // startTime = List<String>();
                      // endTime = List<String>();
                      // int beforeBreak = DateTime.utc(
                      //         1, 1, 1, temp[2].hour, temp[2].minute)
                      //     .difference(
                      //         DateTime.utc(1, 1, 1, temp[0].hour, temp[0].minute))
                      //     .inMinutes;
                      // int afterBreak = DateTime.utc(
                      //         1, 1, 1, temp[1].hour, temp[1].minute)
                      //     .difference(
                      //         DateTime.utc(1, 1, 1, temp[3].hour, temp[3].minute))
                      //     .inMinutes;
                      // startTime.add(temp[0].format(context));
                      // for (int i = (beforeBreak / 4).floor();
                      //     i <= beforeBreak;
                      //     i += (beforeBreak / 4).floor()) {
                      //   DateTime last =
                      //       DateTime.utc(1, 1, 1, temp[0].hour, temp[0].minute)
                      //           .add(Duration(minutes: i));
                      //   endTime.add(
                      //       TimeOfDay(hour: last.hour, minute: last.minute)
                      //           .format(context));
                      //   startTime.add(
                      //       TimeOfDay(hour: last.hour, minute: last.minute)
                      //           .format(context));
                      // }
                      // endTime.last = temp[2].format(context);
                      // startTime.last = temp[2].format(context);
                      // endTime.add(temp[3].format(context));
                      // startTime.add(temp[3].format(context));
                      // for (int i = (afterBreak / 4).floor();
                      //     i <= afterBreak;
                      //     i += (afterBreak / 4).floor()) {
                      //   DateTime last =
                      //       DateTime.utc(1, 1, 1, temp[3].hour, temp[3].minute)
                      //           .add(Duration(minutes: i));
                      //   endTime.add(
                      //       TimeOfDay(hour: last.hour, minute: last.minute)
                      //           .format(context));
                      //   startTime.add(
                      //       TimeOfDay(hour: last.hour, minute: last.minute)
                      //           .format(context));
                      // }
                      // endTime.last = temp[1].format(context);
                      Excel excel = Excel.createExcel();
                      Sheet sheet = excel.sheets['Sheet1'];
                      for (int i = 0; i < 9; i++) {
                        sheet
                            .cell(CellIndex.indexByColumnRow(
                                columnIndex: i + 1, rowIndex: 0))
                            .value = startTime[i] + ' - ' + endTime[i];
                      }
                      for (int i = 0; i < days.length; i++) {
                        sheet
                            .cell(CellIndex.indexByColumnRow(
                                columnIndex: 0, rowIndex: i + 1))
                            .value = days[i];
                      }
                      excel.encode().then((value) async {
                        await UrlUtils.downloadGradesExcel(
                            value, '$selectedClass-$selectedSection', context);
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    child: Text('Upload Time Table'),
                    onPressed: (isClassSelected && isSectionSelected)
                        ? () async {
                              showLoaderDialog(context, 'Please wait....');
                            try {
                              FilePickerResult result =
                                  await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowMultiple: false,
                                      allowedExtensions: ['xlsx']);
                              if (result.files[0].extension
                                      .toLowerCase()
                                      .compareTo('xlsx') !=
                                  0) {
                                Toast.show(
                                    'Please upload time table in .xlsx file only',
                                    context);
                                return;
                              }
                              Excel excel =
                                  Excel.decodeBytes(result.files[0].bytes);
                              Sheet sheet =
                                  excel[await excel.getDefaultSheet()];

                              startTime = List<String>();
                              endTime = List<String>();
                              print(await excel.getDefaultSheet());
                              for (String s in sheet.rows[0]) {
                                print(s);
                                if (s != null && s.isNotEmpty) {
                                  startTime.add(s.split(' - ')[0]);
                                  endTime.add(s.split(' - ')[1]);
                                }
                              }
                              Map<String, List<Map<String, String>>> mainMap =
                                  Map<String, List<Map<String, String>>>();
                              int j = 0;
                              for (List<dynamic> s in sheet.rows.sublist(1)) {
                                int i = 0;
                                mainMap[days[j]] = List<Map<String, String>>();
                                for (String sub in s.sublist(1)) {
                                  mainMap[days[j]].add({
                                    'start time': startTime[i],
                                    'end time': endTime[i],
                                    'subject': sub
                                  });
                                  i++;
                                }
                                j++;
                              }
                              print(mainMap.toString());
                              await Firestore.instance
                                  .collection('School')
                                  .document(schoolCode)
                                  .collection('Time Table')
                                  .document('$selectedClass-$selectedSection')
                                  .setData(mainMap)
                                  .whenComplete(() {
                                Toast.show('Uploaded successfully', context);
                              }).catchError(
                                      (e) => Toast.show(e.toString(), context));
                            } catch (e) {
                              Toast.show(
                                  'Some error occured. Please try again.',
                                  context);
                            }
                              Navigator.pop(context);
                          }
                        : () {
                            if (isClassSelected)
                              Toast.show('Please select section', context);
                            else {
                              Toast.show(
                                  'Please select class and section', context);
                            }
                          },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
    );
  }

  Widget TimingsWidget(int i) {
    return Card(
      child: ListTile(
        title: Text(Timings[i - 1]),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () async {
          List<TimeOfDay> temp =
              await setTime(context, temp1[i - 1], temp2[i - 1]);
          print(temp[0].toString());
          print(temp[1].toString());
          if (temp != null && temp.length == 2) {
            setState(() {
              startTime[i - 1] = temp[0].format(context);
              endTime[i - 1] = temp[1].format(context);
              Timings[i - 1] =
                  'Lecture ${i > 4 ? i - 1 : i} Timings : ${temp[0].format(context)} - ${temp[1].format(context)}';
            });
          }
        },
      ),
    );
  }

  Widget BreakTimings() {
    return Card(
      child: ListTile(
        title: Text(breakTimings),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () async {
          List<TimeOfDay> temp = await setTime(context, temp1[4], temp2[4]);
          // print(temp1.toString());
          if (temp != null && temp.length == 2) {
            setState(() {
              startTime[4] = temp[0].format(context);
              endTime[4] = temp[1].format(context);
              breakTimings =
                  'Break Time : ${temp[0].format(context)} - ${temp[1].format(context)}';
            });
          }
        },
      ),
    );
  }

  Future<List<TimeOfDay>> setTime(
      BuildContext context, TimeOfDay init1, TimeOfDay init2) async {
    String st = "Select", et = "Select";
    stc.text = "Select";
    etc.text = "Select";
    return await showDialog<List<TimeOfDay>>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            titlePadding: EdgeInsets.zero,
            title: AppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              leading: IconButton(
                tooltip: 'Back',
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  tooltip: 'Done',
                  icon: Icon(Icons.done, color: Colors.white),
                  onPressed: () async {
                    if (st != null &&
                        st.compareTo('Select') != 0 &&
                        et != null &&
                        et.compareTo('Select') != 0) {
                      Navigator.pop(context, [init1, init2]);
                    } else {
                      Toast.show('Please select required data', context);
                    }
                  },
                )
              ],
              title: Text(
                'Set Timings',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Start Time',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          controller: stc,
                          readOnly: true,
                          onTap: () async {
                            TimeOfDay temp = (await showTimePicker(
                                initialTime: init1, context: context));
                            print(temp.format(context));
                            setState(() {
                              st = temp.format(context);
                              stc.text = temp.format(context);
                              if (temp != null) {
                                init1 = temp;
                              }
                            });
                          },
                        ),
                      ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('End Time',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        controller: etc,
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay temp = (await showTimePicker(
                              initialTime: init2, context: context));
                          print(temp.format(context));
                          setState(() {
                            et = temp.format(context);
                            etc.text = temp.format(context);
                            if (temp != null) {
                              init2 = temp;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

// class TimeTable extends StatelessWidget {
//   String schoolCode, schoolname;
//   TimeTable(this.schoolname, this.schoolCode);
//   @override
//   Widget build(BuildContext context) {
//     scode = schoolCode;
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Select Class'),
//         ),
//         body: StreamBuilder(
//           stream: Firestore.instance
//               .collection('School')
//               .document(schoolCode)
//               .collection('Student')
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             List<DocumentSnapshot> docs = snapshot.data.documents;
//             Map<String, Set<String>> cs = Map<String, Set<String>>();
//             Map<String, Set<String>> css = Map<String, Set<String>>();
//             docs.forEach((element) {
//               if (cs[element.data['class']] == null) {
//                 cs[element.data['class']] = Set<String>();
//               }
//               cs[element.data['class']].add(element.data['section']);
//               if (css[element.data['class'] + '_' + element.data['section']] ==
//                   null) {
//                 css[element.data['class'] + '_' + element.data['section']] =
//                     Set<String>();
//               }
//               element.data['subjects'].forEach((subject) {
//                 css[element.data['class'] + '_' + element.data['section']]
//                     .add(subject);
//               });
//             });
//             return ListView.builder(
//               itemCount: cs.length,
//               itemBuilder: (context, i) {
//                 return Card(
//                     child: ListTile(
//                   title: Text(
//                     cs.keys.elementAt(i),
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => Sections(
//                                 schoolname, cs.keys.elementAt(i), cs, css)));
//                   },
//                 ));
//               },
//             );
//           },
//         ));
//   }
// }

// class Sections extends StatelessWidget {
//   Map<String, Set<String>> cs, css;
//   String classs, schoolname;
//   Sections(this.schoolname, this.classs, this.cs, this.css);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Select Section"),
//         ),
//         body: ListView.builder(
//           itemCount: cs[classs].length,
//           itemBuilder: (context, i) {
//             return Card(
//                 child: ListTile(
//               title: Text(
//                 cs[classs].elementAt(i),
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => DaysList(
//                             classs, cs[classs].elementAt(i), cs, css)));
//               },
//             ));
//           },
//         ));
//   }
// }

// class DaysList extends StatelessWidget {
//   String cn, sn;
//   Map<String, Set<String>> cs, css;
//   DaysList(this.cn, this.sn, this.cs, this.css);
//   @override
//   Widget build(BuildContext context) {
//     List<String> days = [
//       'Monday',
//       'Tuesday',
//       'Wednesday',
//       'Thursday',
//       'Friday',
//       'Saturday',
//       'Sunday'
//     ];
//     return Scaffold(
//         appBar: AppBar(
//             title: Text(
//           '$cn-$sn',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         )),
//         body: ListView.builder(
//           itemCount: 6,
//           itemBuilder: (context, i) {
//             return Card(
//               child: ListTile(
//                 title: Text(
//                   days[i],
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               Schedule(cn, sn, days[i], cs, css)));
//                 },
//               ),
//             );
//           },
//         ));
//   }
// }

// class Schedule extends StatefulWidget {
//   String cn, sn, day;
//   Map<String, Set<String>> cs, css;
//   Schedule(this.cn, this.sn, this.day, this.cs, this.css);

//   @override
//   _ScheduleState createState() => _ScheduleState(cn, sn, day, cs, css);
// }

// class _ScheduleState extends State<Schedule> {
//   TextEditingController stc, etc, stn, ssn;
//   String cn, sn, day, st, et;
//   Map<String, Set<String>> cs, css;
//   _ScheduleState(this.cn, this.sn, this.day, this.cs, this.css);
//   @override
//   void initState() {
//     stc = TextEditingController(text: 'Select');
//     etc = TextEditingController(text: 'Select');
//     stn = TextEditingController(text: 'Select');
//     ssn = TextEditingController(text: 'Select');
//   }

//   Future<void> deleteLecture(DocumentSnapshot doc, dynamic lecture) async {
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'Delete this lecture?',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         content: Text(
//           'Are you sure want to delete this lecture?',
//           style: TextStyle(fontSize: 18),
//         ),
//         actions: [
//           FlatButton(
//             splashColor: Colors.black12,
//             child: Text(
//               'Delete',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20),
//             ),
//             onPressed: () async {
//               showLoaderDialog(context, 'Please wait....');
//               await doc.reference.updateData({
//                 day: FieldValue.arrayRemove([lecture])
//               }).whenComplete(() {
//                 Toast.show('Deleted successfully', context);
//                 Navigator.pop(context);
//               }).catchError((e) {
//                 Toast.show('Some error occured while deleting', context);
//                 Navigator.pop(context);
//               });
//               Navigator.pop(context);
//             },
//           ),
//           FlatButton(
//               splashColor: Colors.black12,
//               child: Text('Cancel',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20)),
//               onPressed: () {
//                 Navigator.pop(context);
//               }),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$cn-$sn $day'),
//       ),
//       body: StreamBuilder<Object>(
//           stream: Firestore.instance
//               .collection('School')
//               .document(scode)
//               .collection('Time Table')
//               .document('$cn-$sn')
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             DocumentSnapshot snap = snapshot.data;
//             if (snap.exists &&
//                 snap.data.length > 0 &&
//                 snap.data[day] != null &&
//                 snap.data[day].length > 0) {
//               List<Widget> list = List<Widget>();
//               snap.data[day].forEach((lecture) {
//                 list.add(Card(
//                   child: ListTile(
//                     title: Text(
//                       '\nStart Time : ${lecture['start time']}\n\nEnd Time : ${lecture['end time']}\n\nSubject : ${lecture['subject']}\n\nTeacher : ${lecture['teacher']}\n',
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     onLongPress: () async {
//                       await deleteLecture(snap, lecture);
//                     },
//                   ),
//                 ));
//               });
//               return ListView(
//                 children: list,
//               );
//             }
//             return Center(
//               child: Text(
//                 'Nothing to show here!',
//                 style: TextStyle(fontSize: 20),
//               ),
//             );
//           }),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.edit),
//         onPressed: () {
//           showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   titlePadding: EdgeInsets.zero,
//                   title: AppBar(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             topRight: Radius.circular(20))),
//                     leading: IconButton(
//                       tooltip: 'Back',
//                       icon: Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     actions: [
//                       IconButton(
//                         tooltip: 'Done',
//                         icon: Icon(Icons.done, color: Colors.white),
//                         onPressed: () async {
//                           if (stn.text != null &&
//                               stn.text.compareTo('Select') != 0 &&
//                               st != null &&
//                               st.compareTo('Select') != 0 &&
//                               et != null &&
//                               et.compareTo('Select') != 0 &&
//                               ssn.text != null &&
//                               ssn.text.compareTo('Select') != 0) {
//                             showLoaderDialog(context, 'Please wait....');
//                             await Firestore.instance
//                                 .collection('School')
//                                 .document(scode)
//                                 .collection('Time Table')
//                                 .document('$cn-$sn')
//                                 .updateData({
//                               day: FieldValue.arrayUnion(
//                                 [
//                                   {
//                                     'start time': st,
//                                     'end time': et,
//                                     'teacher': stn.text,
//                                     'subject': ssn.text
//                                   },
//                                 ],
//                               )
//                             }).whenComplete(() {
//                               Toast.show('Uploaded successfully', context);
//                               Navigator.pop(context);
//                             }).catchError(
//                                     (e) => Toast.show(e.toString(), context));
//                             Navigator.pop(context);
//                           } else {
//                             Toast.show('Please select required data', context);
//                           }
//                         },
//                       )
//                     ],
//                     title: Text(
//                       '$cn-$sn $day',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     backgroundColor: Colors.black,
//                   ),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Start Time',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(
//                               width: 100,
//                               child: TextField(
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                                 textAlign: TextAlign.center,
//                                 controller: stc,
//                                 readOnly: true,
//                                 onTap: () async {
//                                   String temp = (await showTimePicker(
//                                           initialTime: TimeOfDay.now(),
//                                           context: context))
//                                       .format(context);
//                                   setState(() {
//                                     st = temp;
//                                     stc.text = temp;
//                                   });
//                                 },
//                               ),
//                             ),
//                           ]),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('End Time',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           SizedBox(
//                             width: 100,
//                             child: TextField(
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                               textAlign: TextAlign.center,
//                               controller: etc,
//                               readOnly: true,
//                               onTap: () async {
//                                 String temp = (await showTimePicker(
//                                         initialTime: TimeOfDay.now(),
//                                         context: context))
//                                     .format(context);
//                                 setState(() {
//                                   et = temp;
//                                   etc.text = temp;
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Teacher',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             width: 100,
//                             child: TextField(
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                               textAlign: TextAlign.center,
//                               controller: stn,
//                               readOnly: true,
//                               onTap: () async {
//                                 List<String> teachers;
//                                 String teacher = (await showDialog<String>(
//                                     context: context,
//                                     builder: (context) => Dialog(
//                                         child: ListView.separated(
//                                             shrinkWrap: true,
//                                             itemCount: teachers.length,
//                                             separatorBuilder:
//                                                 (context, index) => Divider(
//                                                       height: 1,
//                                                       thickness: 1,
//                                                       color: Colors.black26,
//                                                     ),
//                                             itemBuilder: (context, i) {
//                                               return ListTile(
//                                                   title: Text(
//                                                     teachers[i],
//                                                     style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                   onTap: () {
//                                                     Navigator.pop(
//                                                         context, teachers[i]);
//                                                   });
//                                             }))));
//                                 setState(() {
//                                   stn.text = teacher;
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Subject',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             width: 100,
//                             child: TextField(
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                               textAlign: TextAlign.center,
//                               controller: ssn,
//                               readOnly: true,
//                               onTap: () async {
//                                 List<String> subjects =
//                                     css[cn + '_' + sn].toList();
//                                 String subject = await showDialog<String>(
//                                     context: context,
//                                     builder: (context) => Dialog(
//                                         child: ListView.separated(
//                                             shrinkWrap: true,
//                                             itemCount: subjects.length,
//                                             separatorBuilder:
//                                                 (context, index) => Divider(
//                                                       height: 1,
//                                                       thickness: 1,
//                                                       color: Colors.black26,
//                                                     ),
//                                             itemBuilder: (context, i) {
//                                               return ListTile(
//                                                   title: Text(
//                                                     subjects[i],
//                                                     style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                   onTap: () {
//                                                     Navigator.pop(
//                                                         context, subjects[i]);
//                                                   });
//                                             })));
//                                 setState(() {
//                                   ssn.text = subject;
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 );
//               });
//         },
//       ),
//     );
//   }
// }
