import 'package:Schools/Screens/SchoolScreens/setTimeTable.dart';
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
  List<List<String>> startTime;
  List<String> days;
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
    startTime = List<List<String>>();
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
    FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection('Student')
        .get()
        .then((value) {
      if (value != null) {
        List<DocumentSnapshot> docs = value.docs;
        Map<String, Set<String>> cs1 = Map<String, Set<String>>();
        Map<String, Set<String>> css1 = Map<String, Set<String>>();
        docs.forEach((element) {
          if (cs1[element.data()['class']] == null) {
            cs1[element.data()['class']] = Set<String>();
          }
          cs1[element.data()['class']].add(element.data()['section']);
          if (css1[element.data()['class'] + '_' + element.data()['section']] ==
              null) {
            css1[element.data()['class'] + '_' + element.data()['section']] =
                Set<String>();
          }
          element.data()['subjects'].forEach((subject) {
            css1[element.data()['class'] + '_' + element.data()['section']]
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
                  Card(
                    child: ListTile(
                      title: Text("Set Lecture Timings"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SetLectureTimings(
                                    FirebaseFirestore.instance
                                        .collection('School')
                                        .doc(schoolCode)
                                        .collection('Time Table')
                                        .doc('URL'))));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 20, right: 20),
                        child: Text(
                            'Download excel sheet for uploading Time Table'),
                        onPressed: () async {
                          Excel excel = Excel.createExcel();
                          Sheet sheet = excel.sheets['Sheet1'];
                          DocumentSnapshot doc = await FirebaseFirestore
                              .instance
                              .collection('School')
                              .doc(schoolCode)
                              .collection('Time Table')
                              .doc('URL')
                              .get();
                          print(doc.data().toString());
                          if (doc.data() != null && doc.data().length>0){
                            List<dynamic> lst =
                                doc.data()['schedule'];
                            List<String> breaks = List<String>();
                            lst.forEach((element) {
                              Map<dynamic, dynamic> map =
                                  Map<dynamic, dynamic>.of(element);
                              startTime
                                  .add([map['start time'], map['end time']]);
                              breaks.add(map['break']);
                            });

                            for (int i = 0; i < startTime.length; i++) {
                              sheet
                                      .cell(CellIndex.indexByColumnRow(
                                          columnIndex: i + 1, rowIndex: 0))
                                      .value =
                                  startTime[i][0] + ' - ' + startTime[i][1];
                            }
                            for (int i = 0; i < days.length; i++) {
                              sheet
                                  .cell(CellIndex.indexByColumnRow(
                                      columnIndex: 0, rowIndex: i + 1))
                                  .value = days[i];
                              for (int j = 0; j < breaks.length; j++) {
                                if (breaks[j].length > 0) {
                                  sheet
                                      .cell(CellIndex.indexByColumnRow(
                                          columnIndex: j + 1, rowIndex: i + 1))
                                      .value = "BREAK";
                                }
                              }
                            }
                            excel.encode().then((value) async {
                              await UrlUtils.downloadGradesExcel(
                                  value, 'TimeTable', context);
                            });
                          } else {
                            UrlUtils.download(
                                "https://firebasestorage.googleapis.com/v0/b/aatmanirbhar-51cd2.appspot.com/o/TimeTable.xlsx?alt=media&token=6f3de4ad-a7c7-400d-b956-b8d39a92e772",
                                "TimeTable.xlsx",
                                context);
                          }
                        },
                      ),
                      RaisedButton(
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 20, right: 20),
                        child: Text('Upload Time Table'),
                        onPressed: (isClassSelected && isSectionSelected)
                            ? () async {
                                showLoaderDialog(context, 'Please wait....');
                                try {
                                  FilePickerResult result =
                                      await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowMultiple: false,
                                          allowedExtensions: ['xlsx'],
                                          withData: true);
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

                                  List<String> StartTime = List<String>();
                                  List<String> endTime = List<String>();
                                  print(await excel.getDefaultSheet());
                                  for (String s in sheet.rows[0]) {
                                    print(s);
                                    if (s != null && s.isNotEmpty) {
                                      StartTime.add(s.split(' - ')[0]);
                                      endTime.add(s.split(' - ')[1]);
                                    }
                                  }
                                  Map<String, List<Map<String, String>>>
                                      mainMap =
                                      Map<String, List<Map<String, String>>>();
                                  int j = 0;
                                  for (List<dynamic> s
                                      in sheet.rows.sublist(1)) {
                                    int i = 0;
                                    mainMap[days[j]] =
                                        List<Map<String, String>>();
                                    for (String sub in s.sublist(1)) {
                                      if (sub != null && sub.length != 0)
                                        mainMap[days[j]].add({
                                          'start time': StartTime[i],
                                          'end time': endTime[i],
                                          'subject': sub
                                        });
                                      i++;
                                    }
                                    j++;
                                  }
                                  print(mainMap.toString());
                                  await FirebaseFirestore.instance
                                      .collection('School')
                                      .doc(schoolCode)
                                      .collection('Time Table')
                                      .doc('$selectedClass-$selectedSection')
                                      .set(mainMap)
                                      .whenComplete(() {
                                    Toast.show(
                                        'Uploaded successfully', context);
                                  }).catchError((e) =>
                                          Toast.show(e.toString(), context));
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
                                  Toast.show('Please select class and section',
                                      context);
                                }
                              },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
    );
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
//           stream: FirebaseFirestore.instance
//               .collection('School')
//               .doc(schoolCode)
//               .collection('Student')
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             List<DocumentSnapshot> docs = snapshot.data.docs;
//             Map<String, Set<String>> cs = Map<String, Set<String>>();
//             Map<String, Set<String>> css = Map<String, Set<String>>();
//             docs.forEach((element) {
//               if (cs[element.data()['class']] == null) {
//                 cs[element.data()['class']] = Set<String>();
//               }
//               cs[element.data()['class']].add(element.data()['section']);
//               if (css[element.data()['class'] + '_' + element.data()['section']] ==
//                   null) {
//                 css[element.data()['class'] + '_' + element.data()['section']] =
//                     Set<String>();
//               }
//               element.data()['subjects'].forEach((subject) {
//                 css[element.data()['class'] + '_' + element.data()['section']]
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
//               await doc.reference.update({
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
//           stream: FirebaseFirestore.instance
//               .collection('School')
//               .doc(scode)
//               .collection('Time Table')
//               .doc('$cn-$sn')
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             DocumentSnapshot snap = snapshot.data;
//             if (snap.exists &&
//                 snap.data().length > 0 &&
//                 snap.data()[day] != null &&
//                 snap.data()[day].length > 0) {
//               List<Widget> list = List<Widget>();
//               snap.data()[day].forEach((lecture) {
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
//                             await FirebaseFirestore.instance
//                                 .collection('School')
//                                 .doc(scode)
//                                 .collection('Time Table')
//                                 .doc('$cn-$sn')
//                                 .update({
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
