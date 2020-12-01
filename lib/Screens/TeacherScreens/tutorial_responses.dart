import 'package:Schools/Screens/TeacherScreens/attendance.dart';
import 'package:Schools/plugins/url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentsResponses extends StatefulWidget {
  CollectionReference cr;
  StudentsResponses(
    this.cr,
  );

  @override
  _StudentsResponsesState createState() => _StudentsResponsesState(cr);
}

class _StudentsResponsesState extends State<StudentsResponses> {
  CollectionReference cr;

  _StudentsResponsesState(this.cr);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Students Responses"),
        ),
        body: StreamBuilder(
          stream: cr.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<DocumentSnapshot> snaps = snapshot.data.docs;
            if (snaps.length == 0) {
              return Center(
                child: Text('No response yet.'),
              );
            }
            return ListView.builder(
              itemCount: snaps.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    title: Text(snaps[i].id.split('#')[1]),
                    subtitle: Text(snaps[i].id.split('#')[0]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DownloadResponses(snaps[i])));
                    },
                  ),
                );
              },
            );
          },
        ));
  }
}

class DownloadResponses extends StatefulWidget {
  DocumentSnapshot sr;
  DownloadResponses(this.sr);

  @override
  _DownloadResponsesState createState() => _DownloadResponsesState(sr);
}

class _DownloadResponsesState extends State<DownloadResponses> {
  DocumentSnapshot sr;
  _DownloadResponsesState(this.sr);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sr.id.split('#')[1]),),
      body: StreamBuilder(
        stream: sr.reference.collection('Files').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> docs = snapshot.data.docs;
          List<Widget> list = List<Widget>();
          docs.forEach((element) {
            list.add(Card(
                child: ListTile(
              title: Text(
                element['name'],
                style: TextStyle(fontSize: 15),
              ),
              subtitle: Text(
                stringToTime(element.id).join(', '),
                style: TextStyle(fontSize: 12),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                    child: IconButton(
                      iconSize: 20,
                      icon: Icon(
                        Icons.file_download,
                      ),
                      onPressed: () async {
                        await UrlUtils.download(
                            element['url'], element['name'], context);
                      },
                    ),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Text(
                    element['size'].toString() + 'KB',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            )));
          });
          return ListView(
            children: list,
          );
        },
      ),
    );
  }
}
