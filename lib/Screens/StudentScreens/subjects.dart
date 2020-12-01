// import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import '../Icons/iconssss_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './subjectDetails.dart';

class Subjects extends StatefulWidget {
  String schoolCode, studentId;
  Subjects(this.schoolCode, this.studentId);
  @override
  _SubjectsState createState() => _SubjectsState(schoolCode, studentId);
}

class _SubjectsState extends State<Subjects> {
  String schoolCode, studentId, name, rollNo;
  _SubjectsState(this.schoolCode, this.studentId);

  String classNumber, section;
  bool gotData = false;
  List subjects = [];

  loadData() {
    FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection('Student')
        .doc(studentId)
        .get()
        .then((value) {
      setState(() {
        classNumber = value.data()['class'];
        section = value.data()['section'];
        if (value.data()['subjects'] != null)
          subjects = value.data()['subjects'];
        rollNo = value.data()['rollno'];
        name = value.data()['first name'] + ' ' + value.data()['last name'];
        gotData = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (!gotData) return Center(child: CircularProgressIndicator());
    return ListView.builder(
      scrollDirection: Axis.vertical,
      //itemCount: 10,s
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        return Container(
            color: Colors.grey[200],
            height: 90,
            child: Card(
              child: Container(
                  margin: EdgeInsets.only(top: 10),
                  // color: Colors.blue,
                  alignment: Alignment.center,
                  child: ListTile(
                    //Color: Colors.yellow,
                    title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            subjects[index],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            'New Assignment:0',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'New Tutorial:0',
                            style: TextStyle(fontSize: 14),
                          )
                        ]),
                    leading: Container(
                        margin: EdgeInsets.only(top: 5, left: 6),
                        child: Icon(
                          Iconssss.doc_text,
                          color: Colors.black,
                          size: 20,
                        )),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black,
                    ),
                    onTap: () {
                      // BotToast.showSimpleNotification(title: 'Simple', duration: Duration(seconds:5));
                      // BotToast.showNotification( duration: Duration(seconds:5));
                    
                      //                                  <-- onTap
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubjectDetails(
                                      schoolCode: schoolCode,
                                      studentId: studentId,
                                      classNumber: classNumber,
                                      section: section,
                                      subject: subjects[index],
                                      rollNo: rollNo,
                                      name: name,
                                    )));
                      });
                    },
                  )),
            ));
      },
    );
  }
}
