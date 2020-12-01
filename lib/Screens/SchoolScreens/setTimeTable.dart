import 'package:Schools/plugins/url_launcher/url_launcher.dart';
import 'package:Schools/widgets/AlertDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:toast/toast.dart';

class SetLectureTimings extends StatefulWidget {
  DocumentReference docRef;
  SetLectureTimings(this.docRef);

  @override
  _SetLectureTimingsState createState() => _SetLectureTimingsState(docRef);
}

class _SetLectureTimingsState extends State<SetLectureTimings> {
  DocumentReference docRef;
  TextEditingController stc, etc;
  List<List<TimeOfDay>> startTime;
  List<bool> breaks;
  List<String> days;
  bool isB = true;
  _SetLectureTimingsState(this.docRef);
  @override
  void initState() {
    super.initState();
    stc = TextEditingController(text: "");
    etc = TextEditingController(text: "");
    startTime = List<List<TimeOfDay>>();
    breaks = List<bool>();
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

  @override
  Widget build(BuildContext context) {
    int b = 0, l = 0;
    return Scaffold(
        appBar: AppBar(
          title: Text("Set Timings"),
          actions: [
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                Excel excel = Excel.createExcel();
                Sheet sheet = excel.sheets['Sheet1'];
                for (int i = 0; i < startTime.length; i++) {
                  sheet
                          .cell(CellIndex.indexByColumnRow(
                              columnIndex: i + 1, rowIndex: 0))
                          .value =
                      startTime[i][0].format(context) +
                          ' - ' +
                          startTime[i][1].format(context);
                }
                for (int i = 0; i < days.length; i++) {
                  sheet
                      .cell(CellIndex.indexByColumnRow(
                          columnIndex: 0, rowIndex: i + 1))
                      .value = days[i];
                  for (int j = 0; j < breaks.length; j++) {
                    if (breaks[j]) {
                      sheet
                          .cell(CellIndex.indexByColumnRow(
                              columnIndex: j + 1, rowIndex: i + 1))
                          .value = "BREAK";
                    }
                  }
                }

                // UrlUtils.uploadFileToFirebase(
                //     , docRef.path, context, null, null, null, null,
                //     dr2: docRef, m2: {}, urlKey2: "url", nameKey2: "name");
                List<Map<String, String>> map = List<Map<String, String>>();
                int j = 0;
                startTime.forEach((element) {
                  map.add({
                    'start time': element[0].format(context),
                    'end time': element[1].format(context),
                    'break': breaks[j] ? 'BREAK' : ''
                  });
                  j++;
                });
                showLoaderDialog(context, "Saving Data....");
                await docRef.set({'schedule': map}).catchError((e) {
                  Toast.show('Error occured. Please try again.', context);
                }).whenComplete(() {Toast.show("Saved successfully.", context, duration: 3);} );
                
                excel.encode().then((value) async {
                  await UrlUtils.downloadGradesExcel(
                      value, 'TimeTable', context);
                });
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: startTime.length > 0
            ? ListView.builder(
                itemCount: startTime.length + 1,
                itemBuilder: (context, i) {
                  if (i < startTime.length) {
                    if (breaks[i]) {
                      b++;
                    } else {
                      l++;
                    }
                    return Card(
                      child: ListTile(
                        title: Text(
                          "${breaks[i] ? "Break" : "Lecture"} ${breaks[i] ? b : l}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Start Time : ${startTime[i][0].format(context)}\tEnd Time : ${startTime[i][1].format(context)}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              startTime.removeAt(i);
                            });
                          },
                        ),
                        onTap: () async {
                          TimeOfDay init1 = startTime[i][0],
                              init2 = startTime[i][1];
                          String st = startTime[i][0].format(context),
                              et = startTime[i][1].format(context);
                          stc.text = startTime[i][0].format(context);
                          etc.text = startTime[i][1].format(context);
                          List<TimeOfDay> temp =
                              await showDialog<List<TimeOfDay>>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
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
                                      icon:
                                          Icon(Icons.done, color: Colors.white),
                                      onPressed: () async {
                                        if (st != null &&
                                            st.compareTo('Select') != 0 &&
                                            et != null &&
                                            et.compareTo('Select') != 0) {
                                          Navigator.pop(
                                              context, [init1, init2]);
                                        } else {
                                          Toast.show(
                                              'Please select required data',
                                              context);
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
                                    RadioButtonGroup(
                                      orientation:
                                          GroupedButtonsOrientation.HORIZONTAL,
                                      labels: ['Lecture', "Break"],
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      itemBuilder: (button, label, i) {
                                        return Expanded(
                                          child: Row(
                                            children: [
                                              button,
                                              label,
                                            ],
                                          ),
                                        );
                                      },
                                      onChange: (str, ind) {
                                        setState(() {
                                          breaks[i] = ind == 0 ? false : true;
                                        });
                                      },
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Start Time',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: TextField(
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                              controller: stc,
                                              readOnly: true,
                                              onTap: () async {
                                                TimeOfDay temp =
                                                    (await showTimePicker(
                                                        initialTime: init1,
                                                        context: context));
                                                // print(temp.format(context));
                                                setState(() {
                                                  if (temp != null) {
                                                    init1 = temp;
                                                    st = temp.format(context);
                                                    stc.text =
                                                        temp.format(context);
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ]),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('End Time',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          width: 100,
                                          child: TextField(
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                            controller: etc,
                                            readOnly: true,
                                            onTap: () async {
                                              TimeOfDay temp =
                                                  (await showTimePicker(
                                                      initialTime: init2,
                                                      context: context));
                                              // print(temp.format(context));
                                              setState(() {
                                                if (temp != null) {
                                                  init2 = temp;
                                                  et = temp.format(context);
                                                  etc.text =
                                                      temp.format(context);
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
                            },
                          );
                          // print(temp[0].toString());
                          // print(temp[1].toString());
                          if (temp != null && temp.length == 2) {
                            setState(() {
                              startTime[i][0] = temp[0];
                              startTime[i][1] = temp[1];
                              for (int i = 0; i < startTime.length; i++) {
                                for (int j = i + 1; j < startTime.length; j++) {
                                  if (comp(startTime[i][0], startTime[j][0],
                                          context) ==
                                      0) {
                                    List<TimeOfDay> te = startTime[i];
                                    startTime[i] = startTime[j];
                                    startTime[j] = te;
                                  }
                                }
                              }
                            });
                          }
                        },
                      ),
                    );
                  } else {
                    return Align(
                      alignment: Alignment.center,
                      child: RaisedButton(
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 20, right: 20),
                        child: Text(
                            'Download excel sheet for uploading Time Table'),
                        onPressed: () async {
                          Excel excel = Excel.createExcel();
                          Sheet sheet = excel.sheets['Sheet1'];
                          for (int i = 0; i < startTime.length; i++) {
                            sheet
                                    .cell(CellIndex.indexByColumnRow(
                                        columnIndex: i + 1, rowIndex: 0))
                                    .value =
                                startTime[i][0].format(context) +
                                    ' - ' +
                                    startTime[i][1].format(context);
                          }
                          for (int i = 0; i < days.length; i++) {
                            sheet
                                .cell(CellIndex.indexByColumnRow(
                                    columnIndex: 0, rowIndex: i + 1))
                                .value = days[i];
                            for (int j = 0; j < breaks.length; j++) {
                              if (breaks[j]) {
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
                        },
                      ),
                    );
                  }
                },
              )
            : Center(
                child: Text("Tap the + button and add a lecture/break."),
              ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              TimeOfDay init1 = TimeOfDay.now(), init2 = TimeOfDay.now();
              String st = "Select", et = "Select";
              stc.text = "Select";
              etc.text = "Select";
              isB = false;
              List<TimeOfDay> temp = await showDialog<List<TimeOfDay>>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
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
                              Toast.show(
                                  'Please select required data', context);
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
                        RadioButtonGroup(
                          orientation: GroupedButtonsOrientation.HORIZONTAL,
                          labels: ['Lecture', "Break"],
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          itemBuilder: (button, label, i) {
                            return Expanded(
                              child: Row(
                                children: [
                                  button,
                                  label,
                                ],
                              ),
                            );
                          },
                          onChange: (str, ind) {
                            setState(() {
                              isB = ind == 0 ? false : true;
                            });
                          },
                        ),
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
                                    // print(temp.format(context));
                                    setState(() {
                                      if (temp != null) {
                                        init1 = temp;
                                        st = temp.format(context);
                                        stc.text = temp.format(context);
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
                                  // print(temp.format(context));

                                  setState(() {
                                    if (temp != null) {
                                      init2 = temp;
                                      et = temp.format(context);
                                      etc.text = temp.format(context);
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
                },
              );
              if (temp != null) {
                setState(() {
                  startTime.add(temp);
                  breaks.add(isB);
                  for (int i = 0; i < startTime.length; i++) {
                    for (int j = i + 1; j < startTime.length; j++) {
                      if (comp(startTime[i][0], startTime[j][0], context) ==
                          0) {
                        List<TimeOfDay> te = startTime[i];
                        startTime[i] = startTime[j];
                        startTime[j] = te;
                      }
                    }
                  }
                });
              }
            }));
  }
}

int comp(TimeOfDay a, TimeOfDay b, BuildContext context) {
  // true if a<b, true == 1
  print(a.format(context));
  print(b.format(context));
  String s1 = a.format(context), s2 = b.format(context);
  print(s1.substring(0, 2));
  if (s1.substring(0, 2).compareTo('12') == 0) {
    s1 = s1.replaceRange(0, 2, '00');
  }
  if (s2.substring(0, 2).compareTo('12') == 0) {
    s2 = s2.replaceRange(0, 2, '00');
  }
  return compare(s1, s2);
  // print(s1.split(' ')[1].compareTo(s2.split(' ')[1]));
  // if (s1.split(' ')[1].compareTo(s2.split(' ')[1]) < 0) {
  //   return 1;
  // } else if (s1.split(' ')[1].compareTo(s2.split(' ')[1]) == 0) {
  //   if (int.parse(s1.split(' ')[0].split(':')[0]) <
  //       int.parse(s2.split(' ')[0].split(':')[0])) {
  //     return 1;
  //   } else if (int.parse(s1.split(' ')[0].split(':')[0]) ==
  //       int.parse(s2.split(' ')[0].split(':')[0])) {
  //     if ((int.parse(s1.split(' ')[0].split(':')[1]) <
  //         int.parse(s2.split(' ')[0].split(':')[1]))) {
  //       return 1;
  //     } else {
  //       return 0;
  //     }
  //   } else {
  //     return 0;
  //   }
  // } else {
  //   return 0;
  // }
}

int compare(String s1, String s2) {
  // true if a<b, true == 1
  if (s1.split(' ')[1].compareTo(s2.split(' ')[1]) < 0) {
    return 1;
  } else if (s1.split(' ')[1].compareTo(s2.split(' ')[1]) == 0) {
    if (int.parse(s1.split(' ')[0].split(':')[0]) <
        int.parse(s2.split(' ')[0].split(':')[0])) {
      return 1;
    } else if (int.parse(s1.split(' ')[0].split(':')[0]) ==
        int.parse(s2.split(' ')[0].split(':')[0])) {
      if ((int.parse(s1.split(' ')[0].split(':')[1]) <
          int.parse(s2.split(' ')[0].split(':')[1]))) {
        return 1;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  } else {
    return 0;
  }
}
