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

class StudentsList extends StatefulWidget {
  String className, schoolCode, teachersId, classNumber, section, subject;

  StudentsList(this.className, this.schoolCode, this.teachersId,
      this.classNumber, this.section, this.subject);
  @override
  _StudentsListState createState() => _StudentsListState(
      className, schoolCode, teachersId, classNumber, section, subject);
}

//String className='X-A';

class _StudentsListState extends State<StudentsList> {
  String className, schoolCode, teachersId, classNumber, section, subject;
  List stdName = [];
  List stdRoll = [];

  _StudentsListState(this.className, this.schoolCode, this.teachersId,
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

  Widget gridBody(context) {
    return Container(
      child: Text('grid'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Widget gridBody;
    String rollno;

    return Scaffold(
      body:
          // AnimationLimiter(
          // child:
          ListView.builder(
              itemCount: stdName.length,
              itemBuilder: (BuildContext context, int index) {
                rollno = stdRoll[index];
                return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                            child: Card(
                                elevation: 2,
                                child: ExpansionTile(
                                  // childrenPadding: EdgeInsets.all(10),
                                  tilePadding: EdgeInsets.all(10),
                                  leading: Icon(
                                    Iconss.user_graduate,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  trailing: Container(
                                      // margin: EdgeInsets.only(right:5),
                                      child: Icon(MyFlutterApp.thumbs_up_down,
                                          size: 20)),
                                  title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          stdName[index],
                                          style: TextStyle(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Roll Number:$rollno',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            //fontWeight: FontWeight.bold
                                          ),
                                        )
                                      ]),
                                  children: <Widget>[
                                    // ListTile(
                                    //   title: Text(
                                    //     'Behavior',
                                    //     style: TextStyle(
                                    //   fontSize: 18.0,
                                    //   fontWeight: FontWeight.bold
                                    // ),
                                    //   ),
                                    // ),

                                    ListTile(
                                        title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(children: [
                                                  Text(
                                                    behavior,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17.0,
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  behavicon
                                                ]),
                                                GestureDetector(
                                                    child: Container(
                                                        height: 30,
                                                        width: 80,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          color: Colors.black,
                                                        ),
                                                        alignment:
                                                            Alignment.center,

                                                        // margin: EdgeInsets.only(bottom:10,right:10),

                                                        child: Text(
                                                          'View Profile',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      StdProfile(
                                                                        stdName:
                                                                            stdName[index],
                                                                      )));
                                                    })
                                              ]),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            behavDesc,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                                color: Colors.black),
                                          ),
                                        ])),
                                    Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(height: 10),
                                            Text(
                                              'Set behavior',
                                              style: TextStyle(
                                                  fontSize: 17.0,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.bold
                                                  // color: Colors.grey
                                                  ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  // color: Colors.cyan,
                                                  //  height: 100,
                                                  //  width: MediaQuery.of(context).size.width,
                                                  //  padding: EdgeInsets.symmetric(),

                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(),
                                                    // color: Colors.blue,
                                                    width: 60,
                                                    child: IconButton(
                                                      icon: Icon(
                                                          Iconssss.thumbs_up,
                                                          size: 30,
                                                          color: _value == 1
                                                              ? Colors.green
                                                              : Colors.grey),
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
                                                    width: 10,
                                                  ),
                                                  Container(
                                                      padding: EdgeInsets
                                                          .symmetric(),
                                                      // color: Colors.blue,
                                                      width: 60,
                                                      child: Transform(
                                                          alignment:
                                                              Alignment.center,
                                                          transform:
                                                              Matrix4.rotationY(
                                                                  math.pi),
                                                          child: IconButton(
                                                            icon: Icon(
                                                              Iconssss
                                                                  .thumbs_down,
                                                              size: 30,
                                                              color: _value == 2
                                                                  ? Colors.red
                                                                  : Colors.grey,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                _value = 2;
                                                                behavior =
                                                                    'Bad';
                                                                print(behavior);
                                                                behav[0] =
                                                                    behavior;
                                                              });
                                                            },
                                                          ))),
                                                ]),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              //width: 250,
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              child: TextField(
                                                  maxLines: 1,
                                                  controller: txtcontroller,
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder())),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                                child: GestureDetector(
                                                    child: Container(
                                                        height: 30,
                                                        width: 50,
                                                        alignment:
                                                            Alignment.center,
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          color: Colors.black,
                                                        ),
                                                        child: Text(
                                                          'Save',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                    onTap: () {
                                                      behavDesc =
                                                          txtcontroller.text;
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
                                        ))
                                  ],
                                )))));
                // return Card( //                           <-- Card widget
                //   child: ListTile(
                //     title: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children:<Widget>[
                //     Text(stdName[index],
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold
                //     ),
                //     ),
                //     Text(
                //       'Roll Number:$rollno'
                //     )
                //       ]),
                //     leading: Icon(Iconss.user_graduate,
                //     color: Colors.black,
                //     size: 20,
                //     ),
                //     trailing: Icon(Icons.keyboard_arrow_right,
                //     color: Colors.black,
                //     ),
                //     onTap: () { //                                  <-- onTap
                //         setState(() {
                //           Navigator.push(context,
                //             MaterialPageRoute(builder: (context) => StdProfile(stdName: stdName[index])));
                //         });
                //       },
                //   //  leading: Icon(icons[index]),
                //    // title: Text(titles[index]),
                //   ),
                // );
              }),
    );
  }
}
