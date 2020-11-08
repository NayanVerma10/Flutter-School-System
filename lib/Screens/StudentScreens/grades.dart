import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Grades extends StatelessWidget {
  String schoolCode, studentId, classNumber, section, subject, rollNo;
  Grades(this.schoolCode, this.studentId, this.classNumber, this.section, this.rollNo, this.subject);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$classNumber $section $subject'),),
        body: StreamBuilder(
      stream: Firestore.instance
          .collection('School')
          .document(schoolCode)
          .collection('Classes')
          .document('${classNumber}_${section}_$subject')
          .collection('Grades')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<DocumentSnapshot> docs = snapshot.data.documents;
        if (docs.isEmpty) {
          return Center(
            child: Text('Nothing to show here!'),
          );
        }
        List<Widget> list = List<Widget>();
        docs.forEach((element) {
          if (element.data[rollNo] != null)
            list.add(Card(
                child: ListTile(
              title: Text(element.documentID.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold),),
              trailing: Text(element.data[rollNo].toString(), style: TextStyle(fontWeight: FontWeight.bold),),
            )));
        });
        if (list.isNotEmpty) {
          return ListView(
            children: list,
          );
        }else {
          return Center(
            child: Text('Nothing to show here!'),
          );
        }
      },
    ));
  }
}

