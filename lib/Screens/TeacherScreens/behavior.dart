import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Icons/iconss_icons.dart';
import './setBehavior.dart';

class Student {
  String name, documentId, rollNo;
  Student({this.name, this.documentId, this.rollNo});
}

class Behavior extends StatefulWidget {
  final String className, schoolCode, teachersId, classNumber, section, subject;
  Behavior(this.className, this.schoolCode, this.teachersId, this.classNumber,
      this.section, this.subject);
  @override
  _BehaviorState createState() => _BehaviorState(
      schoolCode, teachersId, classNumber, section, subject, className);
}

//String className='X-A';

class _BehaviorState extends State<Behavior> {
  String schoolCode, teachersId, classNumber, section, subject, className;
  bool hasStudnets = true;
  _BehaviorState(this.schoolCode, this.teachersId, this.classNumber,
      this.section, this.subject, this.className);

  List<Student> studentList = [];

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
      List<Student> temp = [];
      if (value.documents.isNotEmpty) {
        value.documents.forEach((element) {
          Student std = Student(
              name:
                  element.data['first name'] + ' ' + element.data['last name'],
              documentId: element.documentID,
              rollNo: element.data['rollno']);
          temp.add(std);
        });
        setState(() {
          studentList = temp;
        });
      } else {
        setState(() {
          hasStudnets = false;
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

  @override
  Widget build(BuildContext context) {
    if (hasStudnets && studentList.isNotEmpty)
      return Scaffold(
          body: ListView.builder(
        //itemCount: 10,
        itemCount: studentList.length,
        itemBuilder: (context, index) {
          return Card(
            //                           <-- Card widget
            child: ListTile(
                title: Text(
                  studentList[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(studentList[index].rollNo),
                leading: Icon(
                  Iconss.user_graduate,
                  color: Colors.black,
                  size: 20,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black,
                ),
                onTap: () {
                  //                                  <-- onTap
                  setState(() {
                    // Navigator.push(context,
                    //   MaterialPageRoute(builder: (context) => SetBehavior()));
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              elevation: 16,
                              child: SingleChildScrollView(
                                  child: Container(
                                      height: 500.0,
                                      width: 700.0,
                                      child: SetBehavior(
                                          schoolCode,
                                          studentList[index].documentId,
                                          className)
                                      // ])
                                      )));
                        });
                  });
                }

                ),
          );
        },
      ));
    else if (!hasStudnets)
      return Text('');
    else
      return Center(child: CircularProgressIndicator());
  }
}
