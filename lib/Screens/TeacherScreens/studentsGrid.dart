import 'package:flutter/material.dart';
import './classDetails.dart';
import '../Icons/iconssss_icons.dart';
import './stdProfile.dart';
import '../Icons/iconss_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Icons/iconssss_icons.dart';
import '../Icons/my_flutter_app_icons.dart';
import './setBehavior.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class StudentsGrid extends StatefulWidget {
  String className, schoolCode, teachersId, classNumber, section, subject;
  int v;
  StudentsGrid(this.className, this.schoolCode, this.teachersId,
      this.classNumber, this.section, this.subject);
  @override
  _StudentsGridState createState() => _StudentsGridState(
      className, schoolCode, teachersId, classNumber, section, subject);
}

//String className='X-A';

class _StudentsGridState extends State<StudentsGrid> {
  String className, schoolCode, teachersId, classNumber, section, subject;
  List stdName = [];
  List stdRoll = [];
  int v;

  _StudentsGridState(this.className, this.schoolCode, this.teachersId,
      this.classNumber, this.section, this.subject);
  int count = 0;
  void loadData() {
    Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Student')
        .where('class', isEqualTo: classNumber)
        .where('section', isEqualTo: section)
        .where('subjects', arrayContains: subject)
        .getDocuments()
        .then((value) {
      List<String> temp = [];
      List<String> roll = [];

      if (value.documents.isNotEmpty) {
        value.documents.forEach((element) {
          String std =
              element.data['first name'] + ' ' + element.data['last name'];
          String rollno = element.data['rollno'];
          temp.add(std);
          roll.add(rollno);
        });
        setState(() {
          stdName = temp;
          stdRoll = roll;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  int _value = 0;
  String behavior = 'Current Behavior';
  Icon behavicon = Icon(
    MyFlutterApp.thumbs_up_down,
    color: Colors.grey,
  );
  String behavDesc = 'Description';
//String date=new DateTime.now().toString();
  final DateTime now = DateTime.now();
  final String date = DateFormat('yMMMEd').format(DateTime.now());
  // final String date = formatter.format(now);
  // print(formatted);
  TextEditingController txtcontroller = new TextEditingController();
  List<String> behav = ['', '', ''];

  setBehavior() {
    setState(() {
      if (_value == 1) {
        behavior = 'Good!';
        behavicon = Icon(Iconssss.thumbs_up, color: Colors.green);
      } else {
        behavior = 'Bad!';
        behavicon = Icon(Iconssss.thumbs_down, color: Colors.red);
      }
      behavDesc = '[$date]$behavDesc';
    });
  }

  bool yes = true;
  double _height = 100;
  bool val = true;
  _onExpansionChanged(bool val) {
    setState(() {
      if (val) {
        _height = 300;
      } else {
        _height = 200;
      }

      print(_height);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    double itemHeight = (size.height - kToolbarHeight - 24) / 5;
    final double itemWidth = size.width / 2;

    String rollno;
    int columnCount = 2;

    return Scaffold(
      body: GridView.count(
        crossAxisCount: columnCount,
        childAspectRatio: (itemWidth / itemHeight),
        controller: new ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: List.generate(
          stdName.length,
          (int index) {
            rollno = stdRoll[index];
            return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: columnCount,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: Container(
                        height: 60,
                        child: Card(
                            elevation: 2,
                            child: ListTile(
                              // onExpansionChanged: sizechg,
                              // tilePadding: EdgeInsets.only(left:10,top:6),

                              title: Container(
                                //color: Colors.blue,
                                height: itemHeight,
                                //width:  MediaQuery.of(context).size.width/2,
                                margin: EdgeInsets.only(top: 13, left: 0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // margin: EdgeInsets.only(top:8),
                                        child: Icon(
                                          Iconss.user_graduate,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    stdName[index],
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'Roll Number: $rollno',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      // fontWeight: FontWeight.bold
                                                    ),
                                                  )
                                                ]),
                                            GestureDetector(
                                              child: Container(
                                                  // margin: EdgeInsets.only(right:5),
                                                  child: Icon(
                                                      MyFlutterApp
                                                          .thumbs_up_down,
                                                      size: 20)),
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) {
                                                      return MyDialog(
                                                          stdName[index]);
                                                    });
                                              },
                                            )
                                          ]),
                                    ]),
                                // SizedBox(width: 20,),
                              ),
                            ))),
                  ),
                ));
          },
        ),
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  String stdName;
  MyDialog(this.stdName);

  @override
  _MyDialogState createState() => new _MyDialogState(stdName);
}

class _MyDialogState extends State<MyDialog> {
  String stdName;
  _MyDialogState(this.stdName);

  int _value = 0;
  String behavior = 'Current Behavior';
  Icon behavicon = Icon(
    MyFlutterApp.thumbs_up_down,
    color: Colors.grey,
  );
  String behavDesc = 'Description';
//String date=new DateTime.now().toString();
  final DateTime now = DateTime.now();
  final String date = DateFormat('yMMMEd').format(DateTime.now());
  // final String date = formatter.format(now);
  // print(formatted);
  TextEditingController txtcontroller = new TextEditingController();
  List<String> behav = ['', '', ''];

  setBehavior() {
    setState(() {
      if (_value == 1) {
        behavior = 'Good!';
        behavicon = Icon(Iconssss.thumbs_up, color: Colors.green);
      } else {
        behavior = 'Bad!';
        behavicon = Icon(Iconssss.thumbs_down, color: Colors.red);
      }
      behavDesc = '[$date]$behavDesc';
    });
  }

  double _height = 110;
  bool val = true;
  _onExpansionChanged(bool val) {
    setState(() {
      if (val) {
        _height = 270;
      } else {
        _height = 110;
      }

      print(_height);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 16,
      child: Container(
          height: _height,
          // duration: Duration(),
          margin: EdgeInsets.only(left: 10, top: 20),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(
                    behavior,
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(width: 10),
                  behavicon,
                  SizedBox(width: 50),
                  GestureDetector(
                      child: Container(
                          height: 25,
                          width: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.black,
                          ),
                          alignment: Alignment.center,

                          // margin: EdgeInsets.only(bottom:10,right:10),

                          child: Text(
                            'View Profile',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StdProfile(
                                      stdName: stdName,
                                    )));
                      })
                  // Icon(MyFlutterApp.thumbs_up_down,
                  // color: Colors.grey,
                  // )
                ]),
                Text(
                  behavDesc,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                //  SizedBox(height:10),
                ExpansionTile(
                  onExpansionChanged: _onExpansionChanged,
                  title: Text(
                    'Set Behavior',
                    style: TextStyle(
                      fontSize: 17,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                        Widget>[
                      // color: Colors.cyan,
                      //  height: 100,
                      //  width: MediaQuery.of(context).size.width,
                      //  padding: EdgeInsets.symmetric(),

                      Container(
                        padding: EdgeInsets.symmetric(),
                        // color: Colors.blue,
                        width: 60,
                        child: IconButton(
                          icon: Icon(Iconssss.thumbs_up,
                              size: 30,
                              color: _value == 1 ? Colors.green : Colors.grey),
                          onPressed: () {
                            setState(() {
                              _value = 1;
                              behavior = 'Good';
                              print(behavior);
                              behav[0] = behavior;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(),
                          // color: Colors.blue,
                          width: 60,
                          child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: IconButton(
                                icon: Icon(
                                  Iconssss.thumbs_down,
                                  size: 30,
                                  color: _value == 2 ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _value = 2;
                                    behavior = 'Bad';
                                    print(behavior);
                                    behav[0] = behavior;
                                  });
                                },
                              ))),
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      //width: 250,
                      margin: EdgeInsets.only(right: 20),
                      child: TextField(
                          maxLines: 1,
                          controller: txtcontroller,
                          decoration:
                              InputDecoration(border: OutlineInputBorder())),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: GestureDetector(
                            child: Container(
                                height: 30,
                                width: 50,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.black,
                                ),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                            onTap: () {
                              behavDesc = txtcontroller.text;
                              behav[1] = behavDesc;
                              print(behavior);
                              print(behavDesc);
                              print(date);
                              behav[2] = date;
                              // behav.add(date);
                              print(behav);
                              setBehavior();
                            }))
                  ],
                )
              ])),
    );
  }
}
