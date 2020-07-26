import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import './assignment.dart';
import './attendDetails.dart';
import './discussions.dart';

import './tutorials.dart';
import './grades.dart';
import './VideoChat.dart';
import './database.dart';

import 'package:pie_chart/pie_chart.dart';

class SubjectDetails extends StatefulWidget {
  final String schoolCode, studentId, classNumber, section, subject;
  SubjectDetails(
      {Key key,
      this.schoolCode,
      this.studentId,
      this.classNumber,
      this.section,
      this.subject})
      : super(key: key);
  @override
  _SubjectDetailsState createState() => _SubjectDetailsState(
      schoolCode, studentId, classNumber, section, subject);
}

class _SubjectDetailsState extends State<SubjectDetails>
    with SingleTickerProviderStateMixin {
  final String schoolCode, studentId, classNumber, section, subject;
  _SubjectDetailsState(this.schoolCode, this.studentId, this.classNumber,
      this.section, this.subject);

  
  String teacherName = '';
  List<Color> colorlist = [
    Colors.blue[900],
    Colors.red,
  ];

  void videoChat() {
    if (!kIsWeb)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyApp(
                    schoolCode: schoolCode,
                    className: classNumber + ' ' + section + ' ' + subject,
                    classNumber: classNumber,
                    section: section,
                    subject: subject,
                    studentId: studentId,
                  )));
    else
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebJitsiMeet(
                  schoolCode +
                      '-' +
                      classNumber +
                      '-' +
                      section +
                      '-' +
                      subject,
                  classNumber + ' ' + section + ' ' + subject)));
  }

  loadData() {
    Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Teachers')
        .where('classes', arrayContains: {
          'Class': classNumber,
          'Section': section,
          "Subject": subject
        })
        .getDocuments()
        .then((value) {
          value.documents.forEach((element) {
            setState(() {
              teacherName =
                  element.data['first name'] + ' ' + element.data['last name'];
            });
          });
        });
  }

  Map<String, double> dataMap = new Map();
  @override
  void initState() {
    super.initState();
    loadData();
    dataMap.putIfAbsent("Present", () => 6);
    dataMap.putIfAbsent("Absent", () => 3);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          subject,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          FlatButton.icon(
            label: Text('Join Class'),
            icon: Icon(
              Icons.videocam,
              color: Colors.white,
            ),
            onPressed: videoChat,
            textColor: Colors.white,
          ),
        ],
        iconTheme: new IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Discussions(
                        schoolCode: schoolCode,
                        className: classNumber + ' ' + section + ' ' + subject,
                        classNumber: classNumber,
                        section: section,
                        studentId: studentId,
                        subject: subject,
                      )));
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                elevation: 2,
                color: Colors.white,
                child: Row(children: [
                  Padding(
                      padding: EdgeInsets.all(20),
                      child: new Container(
                        // margin: const EdgeInsets.only(
                        //  left: 15.0, top: 30.0, bottom: 10, right: 15),
                        width: 80.0,
                        height: 80.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                image: ExactAssetImage(
                                    'assets/images/tutorials.png'),
                                fit: BoxFit.cover)),
                      )),
                  // Container(
                  //     margin: const EdgeInsets.only(top: 30.0, bottom: 10),
                  //     height: 70,
                  //     child: VerticalDivider(color: Colors.grey)),
                  Flexible(
                      child: Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Container(
                            //  margin: const EdgeInsets.only(top: 15.0),
                            child: ListTile(
                              title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tutorials',
                                      style: TextStyle(
                                          backgroundColor: Colors.grey[300],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text(
                                      'Completed: 0',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      'Pending: 0',
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ]),
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.black,
                              ),
                              onTap: () {
                                //                                  <-- onTap
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TutorialView()));
                                });
                              },
                            ),
                          ))),
                ])),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                elevation: 2,
                color: Colors.white,
                child: Row(children: [
                  Padding(
                      padding: EdgeInsets.all(20),
                      child: new Container(
                        // margin: const EdgeInsets.only(
                        // left: 15.0, top: 30.0, bottom: 10, right: 15),
                        width: 80.0,
                        height: 80.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                image: ExactAssetImage(
                                    'assets/images/assignment.png'),
                                fit: BoxFit.cover)),
                      )),
                  // Container(
                  //     margin: const EdgeInsets.only(top: 30.0, bottom: 10),
                  //     height: 70,
                  //     child: VerticalDivider(color: Colors.grey)),
                  Flexible(
                      child: Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Container(
                            //  margin: const EdgeInsets.only(top: 15.0),
                            child: ListTile(
                              title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Assignments',
                                      style: TextStyle(
                                          backgroundColor: Colors.grey[300],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text(
                                      'Completed: 0',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      'Pending: 0',
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ]),
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.black,
                              ),
                              onTap: () {
                                //                                  <-- onTap
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()));
                                });
                              },
                            ),
                          ))),
                ])),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                elevation: 2,
                color: Colors.white,
                child: Row(children: [
                  Padding(
                      padding: EdgeInsets.all(20),
                      child: new Container(
                        // margin: const EdgeInsets.only(
                        //     left: 15.0, top: 30, bottom: 10, right: 15),
                        width: 80.0,
                        height: 80.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                image: ExactAssetImage(
                                    'assets/images/attendance.jpg'),
                                fit: BoxFit.cover)),
                      )),
                  // Container(
                  //     margin: EdgeInsets.only(top: 20.0, bottom: 10),
                  //     height: 180,
                  //     child: VerticalDivider(color: Colors.grey)),
                  Flexible(
                      child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                            // margin: const EdgeInsets.only(top: 15.0),
                            child: ListTile(
                              title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Attendance',
                                      style: TextStyle(
                                          backgroundColor: Colors.grey[300],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            height: 180,
                                            width: 110,
                                            child: PieChart(
                                              dataMap: dataMap,
                                              chartLegendSpacing: 20.0,
                                              chartRadius: 110,
                                              colorList: colorlist,
                                              legendPosition:
                                                  LegendPosition.bottom,
                                              chartType: ChartType.ring,
                                              chartValueBackgroundColor:
                                                  Colors.grey[200],
                                              chartValueStyle:
                                                  defaultChartValueStyle
                                                      .copyWith(
                                                color: Colors.blueGrey[900]
                                                    .withOpacity(0.9),
                                              ),
                                              showChartValueLabel: true,
                                            ),
                                          ),
                                        ]),
                                  ]),
                              trailing: Container(
                                margin: const EdgeInsets.only(
                                  top: 80,
                                ),
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AttendDetails()));
                                });
                              },
                            ),
                          ))),
                ])),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                elevation: 2,
                color: Colors.white,
                child: Row(children: [
                  Padding(
                      padding: EdgeInsets.all(20),
                      child: new Container(
                        // margin: const EdgeInsets.only(
                        //     left: 15.0, top: 20.0, bottom: 10, right: 15),
                        width: 80.0,
                        height: 80.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                image: ExactAssetImage(
                                    'assets/images/mteacher.png'),
                                fit: BoxFit.cover)),
                      )),
                  // Container(
                  //     margin: const EdgeInsets.only(top: 20.0, bottom: 10),
                  //     height: 70,
                  //     child: VerticalDivider(color: Colors.grey)),
                  Padding(
                      padding: EdgeInsets.only(top: 10, left: 12),
                      child: Container(
                        // margin: const EdgeInsets.only(
                        //   left: 10.0,
                        //   top: 40.0,
                        //   bottom: 10,
                        // ),
                        height: 50,
                        child: Text(
                          'Teacher: $teacherName',
                          style: TextStyle(
                              backgroundColor: Colors.grey[300],
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        //color: Colors.blue,
                        padding: EdgeInsets.all(4),
                      ))
                ])),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                elevation: 2,
                color: Colors.white,
                child: Row(children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(20),
                      child: new Container(
                        // margin: const EdgeInsets.only(
                        //     left: 15.0, top: 30.0, bottom: 10, right: 15),
                        width: 80.0,
                        height: 80.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                image:
                                    ExactAssetImage('assets/images/grades.png'),
                                fit: BoxFit.cover)),
                      )),
                  // Container(
                  //     margin: const EdgeInsets.only(top: 30.0, bottom: 10),
                  //     height: 70,
                  //     child: VerticalDivider(color: Colors.grey)),
                  Flexible(
                      child: Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Container(
                            margin: const EdgeInsets.only(top: 15.0),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Grades',
                                    style: TextStyle(
                                        backgroundColor: Colors.grey[300],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  Text(
                                    'Grades uploaded!',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.black,
                              ),
                              onTap: () {
                                //                                  <-- onTap
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Grades()));
                                });
                              },
                            ),
                          ))),
                ])),
          ],
        ),
      ),
    );
  }
}
