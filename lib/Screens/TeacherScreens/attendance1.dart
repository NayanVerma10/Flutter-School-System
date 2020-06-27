import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'package:intl/intl.dart';

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

  bool selectedRadioTile, v;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorkey =
      new GlobalKey<RefreshIndicatorState>();
  String dt = (new DateFormat.yMMMMd('en_US').format(new DateTime.now())) +
      ' ' +
      (new DateFormat.Hm().format(new DateTime.now()));

  @override
  void initState() {
    super.initState();
    // loadData();
    //print(users.length);
    //users = User.getUsers();
    //selectedRadio = 0;
    reset();
    v = false;
    selectedRadioTile = false;
  }
  setSelectedUser(bool val) {
    setState(() {
      selectedRadioTile = val;
      v = val;
    });
  }
  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection("School")
        .document(schoolCode)
        .collection('Student')
        .where('class', isEqualTo: classNumber)
        .where('section', isEqualTo: section)
        .where('subjects', arrayContains: subject)
        .getDocuments();
    return qn.documents;
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Summary:"),
      content: Text(dt +
          "\nPresent Students: " +
          selectlist.length.toString() +
          '\n' +
          'Total Students: ' +
          len.toString() +
          '\nPresent Ratio:' +
          ((selectlist.length / len) * 100).toInt().toString() +
          "%"),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void reset() async {
    var snapshots = Firestore.instance
        .collection("School")
        .document(schoolCode)
        .collection('Student')
        .where('class', isEqualTo: classNumber)
        .where('section', isEqualTo: section)
        .where('subjects', arrayContains: subject)
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              element.reference.updateData(<String, dynamic>{
                'id': false,
              });
            }))
        .then((value) {
      setState(() {
        print('reseted all checkboxes');
      });
    });
    selectlist.removeRange(0, selectlist.length);
  }

  Future updateId(String number, bool val) async {
    final CollectionReference brew = Firestore.instance
        .collection("School")
        .document(schoolCode)
        .collection('Student');
    return await brew.document(number).setData({
      'id': val,
    }, merge: true);
  }

//String subject='phy';
  int atl;
  Future getattcount(BuildContext context, String number, String name) {
    String sub = subject + 'attendance';
    DocumentReference documentReference = Firestore.instance
        .collection("School")
        .document(schoolCode)
        .collection('Student')
        .document(number);
    documentReference.get().then((datasnapshot) {
      // print(datasnapshot.data["schoolno"]);
      print(datasnapshot.data[subject + "attendance"]);
      atl = datasnapshot.data[subject + "attendance"];
      return showAlertDialog2(context, atl, name);
    });
  }

  int countAtt(int number) {
    String sub = subject + '_attendance';
    DocumentReference documentReference =
        Firestore.instance.collection("dummy").document("141");
    documentReference.get().then((datasnapshot) {
      // print(datasnapshot.data["schoolno"]);
      return 7;
    });
  }

  Future updateCount(bool val, String number) async {
    String sub = subject + '_attendance';
    //Map<String,dynamic> classteacher={"count":4, "subject":subject,};
    if (val == true) {
      String s = dt;
      return await Firestore.instance
          .collection("School")
          .document(schoolCode)
          .collection('Student')
          .document(number)
          .updateData({
        sub: FieldValue.arrayUnion([s])
      });
    } else {
      String s = dt;
      return await Firestore.instance
          .collection("School")
          .document(schoolCode)
          .collection('Student')
          .document(number)
          .updateData({
        sub: FieldValue.arrayRemove([s])
      });
    }
    //return await brew.document(selectlist[i]).updateData({
  }

  void datapush(String number, bool val) {
    String sub = subject + 'attendance';
    if (val == true) {
      setState(() {
        print("select");
        Firestore.instance
            .collection("School")
            .document(schoolCode)
            .collection('Student')
            .document(number)
            .setData({sub: FieldValue.increment(1)}, merge: true);
      });
    } else {
      setState(() {
        print("select");
        Firestore.instance
            .collection("School")
            .document(schoolCode)
            .collection('Student')
            .document(number)
            .setData({sub: FieldValue.increment(-1)}, merge: true);
      });
    }
  }

  int len;
  List selectlist = List();
  void onCategorySelect(String number, bool val) {
    if (val == true) {
      setState(() {
        selectlist.add(number);
      });
    } else {
      setState(() {
        selectlist.remove(number);
      });
    }
  }

  Future<Null> _refreshLocalGallery() async {
    print('refreshing....');
    setState(() {
      getPosts();
    });
    return null;
  }

  List liststamp = List();
  List getlist(String number) {
    DocumentReference documentReference = Firestore.instance
        .collection("School")
        .document(schoolCode)
        .collection('Student')
        .document(number);
    documentReference.get().then((datasnapshot) {
      String sub = subject + '_attendance';
      setState(() {
        for (int i = 0; i <= 9; i++) {
          print(datasnapshot.data["sub"][i]);
          liststamp.add(datasnapshot.data["sub"][i]);
        }
      });
      // print(datasnapshot.data["schoolno"]);
      print(datasnapshot.data["first name"]);
    });
    return liststamp;
  }

  showAlertDialog2(BuildContext context, int number, String name) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("$name"),
      content: Text("Total class attended: $number "),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.black,
                    onPressed: reset,
                    child: Text("Reset  ".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text(
                      'Submit'.toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black,
                    onPressed: () {
                      //update ho jaye
                      showAlertDialog(context);
                      reset();
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                  //height: 30,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.black)),
                  child: RichText(
                    text: TextSpan(
                      //text: 'Hello ',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Selected:'.toUpperCase(),
                            style: TextStyle(color: Colors.white)),
                        TextSpan(
                            text: ' ' + selectlist.length.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * .60,
//height: 500,
              child: FutureBuilder(
                  future: getPosts(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text(
                          "Please wait...",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      );
                    } else {
                      return RefreshIndicator(
                        key: _refreshIndicatorkey,
                        onRefresh: _refreshLocalGallery,
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 5.0,
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: CheckboxListTile(
                                title: Row(
                                  children: <Widget>[
                                    Text(
                                        snapshot.data[index].data["first name"],
                                        style: TextStyle(
                                          fontSize: 17,
                                        )),
                                  ],
                                ),
                                value: snapshot.data[index].data["id"],
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: Colors.green,
                                onChanged: (value) {
                                  print(
                                      "Current User ${snapshot.data[index].data["first name"]}");
                                  setState(() {
                                    timeDilation = value ? 2.0 : 1.0;
                                    snapshot.data[index].data["id"] = value;
                                    updateId(
                                        snapshot.data[index].documentID, value);
                                    datapush(
                                        snapshot.data[index].documentID, value);
                                    updateCount(
                                        value, snapshot.data[index].documentID);
                                  });
                                  onCategorySelect(
                                      snapshot.data[index].documentID, value);
                                  len = snapshot.data.length;
                                },
                                selected: snapshot.data[index].data["id"],
                                secondary: RaisedButton(
                                  //hoverColor: Colors.white,
                                  color: Colors.black,
                                  onPressed: () {
                                    getattcount(
                                        context,
                                        (snapshot.data[index].documentID),
                                        snapshot
                                            .data[index].data["first name"]);
                                    getlist(snapshot.data[index].documentID);
                                    print('Detailed Info!');
                                  },
                                  child: Text(
                                    'Detailed Info!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  })),
        ],
      ),
    );
  }
}