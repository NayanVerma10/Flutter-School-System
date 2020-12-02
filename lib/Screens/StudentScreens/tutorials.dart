import 'package:Schools/Screens/TeacherScreens/attendance.dart';
import 'package:Schools/Screens/TeacherScreens/tutorial_responses.dart';
import 'package:Schools/Screens/TeacherScreens/tutorials.dart';
import 'package:Schools/plugins/url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentTutorial extends StatefulWidget {
  final String schoolCode, classNumber, section, subject, rollno, name, id;
  final bool optional; // true if teacher is redirected here
  StudentTutorial(this.schoolCode, this.classNumber, this.section, this.subject,
      {this.optional = false, this.rollno, this.name, this.id});

  @override
  _StudentTutorialState createState() =>
      _StudentTutorialState(schoolCode, classNumber, section, subject,
          optional: optional, rollno: rollno, name: name, id: id);
}

class _StudentTutorialState extends State<StudentTutorial> {
  final String schoolCode, classNumber, section, subject, rollno, name, id;
  final bool optional;
  _StudentTutorialState(
      this.schoolCode, this.classNumber, this.section, this.subject,
      {this.optional, this.rollno, this.name, this.id});
  @override
  Widget build(BuildContext context) {
    print("$rollno#$name#$id");
    return Scaffold(
      appBar: AppBar(title: Text('Tutorials')),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('School')
              .doc(schoolCode)
              .collection('Classes')
              .doc(classNumber + '_' + section + '_' + subject)
              .collection('Tutorials')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<DocumentSnapshot> docs = snapshot.data.docs;
            print(docs.length);
            if (docs.isNotEmpty) {
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    title: Text(
                      docs[index].data()['name'],
                      style: TextStyle(fontSize: 15),
                    ),
                    subtitle: Text(
                      stringToTime(docs[index].id).join(', '),
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 40,
                          child: IconButton(
                            splashRadius: 60,
                            splashColor: Colors.black45,
                            iconSize: 25,
                            icon: Icon(
                              Icons.file_download,
                              color: Colors.black87,
                            ),
                            onPressed: () async {
                              await UrlUtils.download(docs[index]['url'],
                                  docs[index]['name'], context);
                            },
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Text(
                          docs[index]['size'] + 'KB',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (optional) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentsResponses(
                                    docs[index]
                                        .reference
                                        .collection('Responses'))));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UploadResponses(
                                    schoolCode,
                                    classNumber,
                                    section,
                                    subject,
                                    name,
                                    id,
                                    rollno,
                                    docs[index].reference)));
                      }
                    },
                  ));
                },
              );
            }
            return Center(
              child: Text('Nothing to show here!'),
            );
          }),
    );
  }
}

class UploadResponses extends StatefulWidget {
  final String schoolCode, classNumber, section, subject, rollno, name, id;
  final DocumentReference docRef;
  UploadResponses(this.schoolCode, this.classNumber, this.section, this.subject,
      this.name, this.id, this.rollno, this.docRef);

  @override
  _UploadResponsesState createState() => _UploadResponsesState(
      schoolCode, classNumber, section, subject, name, id, rollno, docRef);
}

class _UploadResponsesState extends State<UploadResponses> {
  final String schoolCode, classNumber, section, subject, rollno, name, id;
  final DocumentReference docRef;
  _UploadResponsesState(this.schoolCode, this.classNumber, this.section,
      this.subject, this.name, this.id, this.rollno, this.docRef);
  @override
  Widget build(BuildContext context) {
    print('$rollno#$name#$id');
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Responses"),
        actions: [
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TutorialUpload(
                            schoolCode,
                            classNumber,
                            section,
                            subject,
                            false,
                            rollno: rollno,
                            name: name,
                            id: id,
                            docname: docRef.id,
                          )));
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: docRef
            .collection('Responses')
            .doc('$rollno#$name#$id')
            .collection("Files")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> docs = snapshot.data.docs;
          if (docs == null || docs.length == 0) {
            return Center(
              child: Text("No file uploaded yet."),
            );
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              return Card(
                child: ListTile(
                  title: Text(
                    docs[i].data()['name'],
                    style: TextStyle(fontSize: 15),
                  ),
                  subtitle: Text(
                    stringToTime(docs[i].id).join(', '),
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: Column(
                    children: [
                      SizedBox(
                          height: 30,
                          width: 40,
                          child: IconButton(
                            splashRadius: 60,
                            splashColor: Colors.black45,
                            iconSize: 25,
                            icon: Icon(
                              Icons.file_download,
                              color: Colors.black87,
                            ),
                            onPressed: () async {
                          await UrlUtils.download(docs[i].data()['url'],
                              docs[i].data()['name'], context);
                        },
                          ),
                        ),
                      Text(
                        docs[i].data()['size'].toString() + 'KB',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
