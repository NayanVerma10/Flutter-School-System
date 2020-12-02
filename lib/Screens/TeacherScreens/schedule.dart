import 'package:Schools/Screens/SchoolScreens/setTimeTable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeachersTimeTable extends StatefulWidget {
  final Color color;
  final bool edit;
  final String schoolCode, teachersId;
  TeachersTimeTable(this.schoolCode, this.teachersId,
      {this.color, this.edit = false});

  _TeachersTimeTableState createState() =>
      _TeachersTimeTableState(schoolCode, teachersId);
}

class _TeachersTimeTableState extends State<TeachersTimeTable> {
  bool edit = false;
  final String schoolCode, teachersId;
  _TeachersTimeTableState(this.schoolCode, this.teachersId);
  Map<String, List<Widget>> list;
  List<String> days;
  List<BottomNavigationBarItem> items;
  List<DateTime> finalList;
  Map<String, Map<String, String>> finalListToClass;
  bool loading = true;
  String index;

  @override
  void initState() {
    super.initState();
    index = 'Monday';
    list = Map<String, List<Widget>>();
    days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    days.forEach((element) {
      list[element] = List<Widget>();
    });
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      loading = true;
    });
    Map<String, List<Widget>> tempList = Map<String, List<Widget>>();
    Map<String, List<String>> tempy1 = Map<String, List<String>>();
    final CollectionReference cr = FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection('Time Table');
    await FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection('Teachers')
        .doc(teachersId)
        .get()
        .then((teacherDoc) {
      if (teacherDoc != null) {
        if (teacherDoc.data()['classes'] != null) {
          List<dynamic> classes = teacherDoc.data()['classes'];
          // print(classes.toString());
          cr.get().then((schedule) {
            if (schedule != null) {
              tempList = Map<String, List<Widget>>();
              tempy1 = Map<String, List<String>>();
              finalList = List<DateTime>();
              finalListToClass = Map<String, Map<String, String>>();

              days.forEach((element) {
                list[element] = List<Widget>();
                tempList[element] = List<Widget>();
                tempy1[element] = List<String>();
              });

              List<DocumentSnapshot> schedules = schedule.docs;
              classes.cast<Map<String, dynamic>>().forEach((classs) {
                var classSchedule = schedules.firstWhere((element) =>
                    element.id.compareTo(classs['Class'].toString() +
                        '-' +
                        classs['Section'].toString()) ==
                    0);

                classSchedule.data().forEach((day, tt) {
                  List<dynamic> schoolTT = tt;

                  schoolTT
                      .cast<Map<String, dynamic>>()
                      .where(
                        (ele) =>
                            ele['subject'].toString().toLowerCase().compareTo(
                                classs['Subject'].toString().toLowerCase()) ==
                            0,
                      )
                      .forEach((element) {
                    Map<String, dynamic> classSubjectSchedule = element;
                    print(classSubjectSchedule.toString());
                    if (classSubjectSchedule.isNotEmpty) {
                      // List<String> time = classSubjectSchedule['start time']
                      //     .toString()
                      //     .split(':');
                      // int hour = int.parse(time[0]);
                      // if (time[1].split(' ')[1].compareTo('PM') == 0) {
                      //   if (time[0].compareTo('12') != 0) {
                      //     hour += 12;
                      //   }
                      // }
                      // finalList.add(DateTime(
                      //     1, 1, 1, hour, int.parse(time[1].split(' ')[0])));
                      // finalListToClass[classSubjectSchedule['start time']] = {
                      //   'start time': classSubjectSchedule['start time'],
                      //   'end time': classSubjectSchedule['end time'],
                      //   'subject': classSubjectSchedule['subject'],
                      //   'class': classs['Class'],
                      //   'section': classs['Section']
                      // };
                      tempList[day].add(buildListTile(
                          classSubjectSchedule['start time'],
                          classSubjectSchedule['end time'],
                          classSubjectSchedule['subject'],
                          tempList[day].length,
                          classs['Class'],
                          classs['Section']));
                      tempy1[day].add(classSubjectSchedule['start time']);
                    }
                  });
                });
                tempy1.forEach((key, value) {
                  for (int i = 0; i < value.length; i++) {
                    for (int j = 0; j < value.length; j++) {
                      if (compare(value[i], value[j]) == 0) {
                        String te = value[i];
                        value[i] = value[j];
                        value[j] = te;
                        Card tem = tempList[key][i];
                        tempList[key][i] = tempList[key][j];
                        tempList[key][j] = tem;
                      }
                    }
                  }
                });

                setState(() {
                  list = tempList;
                  loading = false;
                });
              });
            }
          });
        }
      }
      setState(() {
        list = tempList;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    edit = widget.edit;
    items = List<BottomNavigationBarItem>();
    days.forEach((element) {
      items.add(BottomNavigationBarItem(
          icon: Text(
            element,
            style: TextStyle(
                fontWeight: index.compareTo(element) == 0
                    ? FontWeight.bold
                    : FontWeight.normal),
          ),
          title: Text('')));
    });
    return Scaffold(
        backgroundColor: widget.color ?? Colors.white,
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await loadData();
                },
                child: list[index] != null && list[index].isNotEmpty
                    ? ListView(children: list[index])
                    : Stack(
                        children: <Widget>[
                          Center(
                            child: Text('Nothing to show here!',
                                style: TextStyle(fontSize: 20)),
                          ),
                          ListView(),
                        ],
                      ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: days.indexOf(index),
          items: items,
          onTap: (i) {
            setState(() {
              index = days[i];
            });
          },
        ));
  }

  Card buildListTile(String st, String et, String subject, int index,
      String classNum, String section) {
    return Card(
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          ListTile(
            title: Text(
              '$classNum-$section\t$subject'.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            height: 2,
            indent: 20,
            endIndent: 20,
          ),
          Padding(
              padding: EdgeInsets.only(
                  left: !edit ? 25 : 15, top: 5, right: !edit ? 25 : 15),
              child: Text(
                "$st  to  $et",
                style: TextStyle(fontWeight: FontWeight.bold
                    // fontFamily: 'Ninto',
                    ),
              )),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}

// Card buildListTile(String st, String et, String subject, int index, String classNum, String section) {
//     return Card(
//       elevation: 5,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: <Widget>[
//           ListTile(
//             title: !edit
//                 ? Text(
//                     '$classNum-$section\t$subject'.toUpperCase(),
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   )
//                 : TextField(
//                     maxLines: 1,
//                     expands: false,
//                     controller: TextEditingController(text: subject),
//                     enableInteractiveSelection: true,
//                     keyboardType: TextInputType.text,
//                     autocorrect: true,
//                     textInputAction: TextInputAction.done,
//                     decoration: InputDecoration(
//                       labelText: 'Lecture ${index + 1}',
//                       labelStyle: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//             onLongPress: () {
//               edit = !edit;
//               setState(() {});
//             },
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 SizedBox(
//                   height: 6,
//                 ),
//                 !edit
//                     ? Text(
//                         "Standard ${index + 1}A",
//                         style: TextStyle(fontWeight: FontWeight.w500),
//                       )
//                     : TextField(
//                         maxLines: 1,
//                         expands: false,
//                         controller: TextEditingController(text: 'Standard'),
//                         enableInteractiveSelection: true,
//                         keyboardType: TextInputType.text,
//                         autocorrect: true,
//                         textInputAction: TextInputAction.done,
//                         decoration: InputDecoration(
//                           labelText: 'Standard + Div',
//                           labelStyle: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//               ],
//             ),
//           ),
//           Divider(
//             height: 2,
//             indent: 20,
//             endIndent: 20,
//           ),
//           Padding(
//             padding: EdgeInsets.only(
//                 left: !edit ? 25 : 15, top: 5, right: !edit ? 25 : 15),
//             child: !edit
//                 ? Text(
//                     "$st  to  $et",
//                     style: TextStyle(fontWeight: FontWeight.bold
//                         // fontFamily: 'Ninto',
//                         ),
//                   )
//                 : Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: TextField(
//                           maxLines: 1,
//                           expands: false,
//                           controller:
//                               TextEditingController(text: '$index:00 A.M'),
//                           enableInteractiveSelection: true,
//                           keyboardType: TextInputType.datetime,
//                           autocorrect: true,
//                           textInputAction: TextInputAction.done,
//                           decoration: InputDecoration(
//                             labelText: 'Start time',
//                             labelStyle: TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Text(
//                         " to ",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                       Expanded(
//                         child: TextField(
//                           maxLines: 1,
//                           expands: false,
//                           controller: TextEditingController(
//                               text: '${index + 1}:30 A.M'),
//                           enableInteractiveSelection: true,
//                           keyboardType: TextInputType.datetime,
//                           autocorrect: true,
//                           textInputAction: TextInputAction.done,
//                           decoration: InputDecoration(
//                             labelText: 'End time',
//                             labelStyle: TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           edit
//               ? FlatButton(
//                   onPressed: () {},
//                   child: Text(
//                     'Save',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }
