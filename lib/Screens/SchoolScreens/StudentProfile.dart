import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Schools/Screens/TeacherScreens/attendance.dart';

class StudentProfile extends StatefulWidget {
  final String schoolCode;
  final String studentId;
  StudentProfile({this.schoolCode, this.studentId});
  @override
  _StudentProfileState createState() =>
      _StudentProfileState(schoolCode, studentId);
}

class _StudentProfileState extends State<StudentProfile> {
  String schoolCode;
  String studentId;
  List<String> css;
  _StudentProfileState(this.schoolCode, this.studentId);

  Widget _buildList(BuildContext context, String key, value) {
    if (value.runtimeType == String)
      return ListTile(
        title: Text(key.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, child: Text(value)),
        ),
        onTap: () {
          _showDialog(context, key, value);
        },
      );
    else /*if (value.runtimeType == List) */ {
      return ListTile(
        title: Text(key.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                value.toString(),
                overflow: TextOverflow.ellipsis,
              )),
        ),
      );
    }
  }

  _showDialog(BuildContext context, String key, String value) async {
    String newValue;
    await showDialog<String>(
      context: context,
      child: new _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: key.toUpperCase(),
                      hintText: 'eg. ' + value),
                  onChanged: (value) {
                    newValue = value;
                  },
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('Save'),
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection('School')
                      .doc(schoolCode)
                      .collection('Student')
                      .doc(studentId)
                      .set({key: newValue},SetOptions(merge: true));
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Student'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('School')
              .doc(schoolCode)
              .collection('Student')
              .doc(studentId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            DocumentSnapshot document = snapshot.data;
            Map<String, dynamic> studentData = document.data();
            var keys = studentData.keys.toList();
            css = List<String>();
            studentData['subjects'].forEach((subject) {
              css.add(studentData['class'] +
                  '_' +
                  studentData['section'] +
                  '_' +
                  subject);
            });

            return Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 70,
                    backgroundImage: studentData['url'] != null
                        ? NetworkImage(studentData['url'])
                        : null,
                    backgroundColor: Colors.grey[200],
                    child: studentData['url'] == null
                        ? Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 90,
                          )
                        : null,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemExtent: 80.0,
                      itemCount: keys.length + css.length,
                      itemBuilder: (context, index) {
                        if (index < keys.length)
                          return _buildList(
                              context, keys[index], studentData[keys[index]]);
                        else {
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("School")
                                .doc(schoolCode)
                                .collection('Classes')
                                .doc(css[index - keys.length])
                                .collection('Attendance')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return ListTile(
                                  title: Text(
                                    "Fetching attendance details....",
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                );
                              }
                              List<DocumentSnapshot> docs =
                                  snapshot.data.docs;
                              List<String> temp = List<String>();
                                  docs
                                      .where((element) => (element.data()[
                                        studentData['rollno'] +
                                            '#' +
                                            studentData[
                                                'first name'] +
                                            ' ' +
                                            studentData['last name'] +
                                            '#' +
                                            studentId] ??
                                              false)
                                          ? true
                                          : false)
                                      .forEach((element) {
                                    temp.add(stringToTime(element.id).join(", "));
                                  });
                                  return ListTile(
                                    title: Text(
                                        css[index-keys.length].split('_')[2].toUpperCase() + " ATTENDANCE", style: TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: RichText(
                                      text:TextSpan(
                                        children: [
                                          TextSpan(text:temp.toString()+" = ",style: TextStyle(color: Colors.black38)),
                                          TextSpan(text:temp.length.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                        ]
                                      )
                                    ),
                                  );
                                },
                              );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets / 200,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
