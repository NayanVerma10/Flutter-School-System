import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Schools/Screens/TeacherScreens/attendance.dart';

class AttendDetails extends StatefulWidget {
  String rollNo, name, id;
  bool mode = true; // false if teacher is redirected here
  String path;
  AttendDetails(this.path, this.rollNo, this.name, this.id, [this.mode=true]);

  @override
  _AttendDetailsState createState() =>
      _AttendDetailsState(path, rollNo, name, id,mode);
}

class _AttendDetailsState extends State<AttendDetails> {
  String rollNo, name, id;
  bool mode = true; // false if teacher is redirected here
  String path;
  _AttendDetailsState(this.path, this.rollNo, this.name, this.id, [this.mode=true]
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(mode?'Attendance Details':name),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection(path).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<DocumentSnapshot> docs = snapshot.data.docs;
              return ListView.builder(
                itemCount: docs.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return ListTile(
                      title: Text(
                        'Class Details',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  } else if (docs[i - 1].data()[rollNo + '#' + name + '#' + id] !=
                      null)
                    return Card(
                      child: ListTile(
                        title: Text(stringToTime(docs[i - 1].id)[0]),
                        subtitle: Text(stringToTime(docs[i - 1].id)[1]),
                        trailing: Text(
                          docs[i - 1].data()[rollNo + '#' + name + '#' + id]
                              ? 'Present'
                              : 'Absent',
                          style: TextStyle(
                              color: docs[i - 1]
                                      .data()[rollNo + '#' + name + '#' + id]
                                  ? Colors.green[500]
                                  : Colors.red[500],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  else
                    return SizedBox();
                },
              );
            }));
  }
}
