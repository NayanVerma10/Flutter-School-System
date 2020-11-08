import 'package:Schools/Screens/TeacherScreens/attendance.dart';
import 'package:Schools/Screens/TeacherScreens/tutorials.dart';
import 'package:Schools/plugins/url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentTutorial extends StatefulWidget {
  final String schoolCode, classNumber, section, subject;
  StudentTutorial(
      this.schoolCode, this.classNumber, this.section, this.subject);

  @override
  _StudentTutorialState createState() =>
      _StudentTutorialState(schoolCode, classNumber, section, subject);
}

class _StudentTutorialState extends State<StudentTutorial> {
  final String schoolCode, classNumber, section, subject;
  _StudentTutorialState(
      this.schoolCode, this.classNumber, this.section, this.subject);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tutorials')),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('School')
              .document(schoolCode)
              .collection('Classes')
              .document(classNumber + '_' + section + '_' + subject)
              .collection('Tutorials')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<DocumentSnapshot> docs = snapshot.data.documents;
            if (docs.isNotEmpty) {
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    title: Text(docs[index].data['name']),
                    subtitle:
                        Text(stringToTime(docs[index].documentID).join(', ')),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                          child: IconButton(
                            iconSize: 24,
                            icon: Icon(
                              Icons.file_download,
                            ),
                            onPressed: () async {
                              await UrlUtils.download(docs[index]['url'],
                                  docs[index]['name'], context);
                            },
                          ),
                        ),
                        Text(docs[index]['size'] + 'KB'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>TutorialUpload(schoolCode, classNumber, section, subject))
                      );
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
