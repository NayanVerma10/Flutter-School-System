import 'package:Schools/Chat/GroupChatBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupChat extends StatefulWidget {
  AsyncSnapshot snapshot;
  String docId, schoolCode;
  bool isTeacher;

  GroupChat(this.snapshot, this.docId, this.schoolCode, this.isTeacher);
  @override
  _GroupChatState createState() =>
      _GroupChatState(snapshot, docId, schoolCode, isTeacher);
}

class _GroupChatState extends State<GroupChat> {
  List<Widget> list;
  AsyncSnapshot snapshot;
  String docId, schoolCode, name;
  bool isTeacher;
  _GroupChatState(this.snapshot, this.docId, this.schoolCode, this.isTeacher);
  @override
  void initState() {
    super.initState();
    list = List();
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> groupIds = snapshot.data.documents;
    groupIds.forEach((element) {
      list.add(StreamBuilder(
          stream: Firestore.instance
              .collection('School')
              .document(schoolCode)
              .collection("GroupChats")
              .document(element.documentID)
              .snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return ListTile(
                  title: Text(
                "Please wait fetching group details....",
                style:
                    TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
              ));
            } else {
              DocumentSnapshot snapshotData = snap.data;

              return ListTile(
                  onTap: element.documentID != null
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  settings: RouteSettings(name: 'GroupChatBox'),
                                  builder: (context) => GroupChatBox(
                                        Firestore.instance
                                            .collection('School')
                                            .document(schoolCode)
                                            .collection("GroupChats")
                                            .document(element.documentID),
                                        schoolCode,
                                        docId,
                                        isTeacher,
                                      )));
                        }
                      : null,
                  leading: snapshotData.data["Icon"] != null
                      ? CircleAvatar(
                          radius: 28,
                          backgroundImage: Image.network(
                                  snapshotData.data['Icon'],
                                  fit: BoxFit.cover)
                              .image,
                        )
                      : CircleAvatar(
                          radius: 28,
                          child: Icon(
                            Icons.people,
                            color: Colors.grey[500],
                          ),
                          backgroundColor: Colors.white,
                        ),
                  title: Text(
                    snapshotData.data['Name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: StreamBuilder(
                      stream: Firestore.instance
                          .collection("School")
                          .document(schoolCode)
                          .collection("GroupChats")
                          .document(element.documentID)
                          .collection("ChatMessages")
                          .snapshots(),
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return Text(
                            "",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                        }
                        List<DocumentSnapshot> docs = snap.data.documents ?? [];
                        if (docs.last.data['type'] != 'notification') {
                          String dateOfMessage =
                              docs.last.data['date'].toString().split('T')[0];
                          String timeOfMessage = docs.last.data['date']
                              .toString()
                              .split('T')[1]
                              .split('.')[0]
                              .substring(0, 5);
                          String string = 'Testing';

                          if (dateOfMessage ==
                              DateTime.now().toIso8601String().toString().split('T')[0])
                            string = timeOfMessage;
                          else if (dateOfMessage ==
                              DateTime.now()
                                  .subtract(Duration(days: 1))
                                  .toIso8601String()
                                  .toString()
                                  .split('T')[0])
                            string = 'Yesterday';
                          else
                  string = dateOfMessage;
                          return Text(
                              string,
                              textScaleFactor: 0.8,
                            );
                        } else {
                          return Text(
                            "",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                        }
                      }),
                  subtitle: StreamBuilder(
                      stream: Firestore.instance
                          .collection("School")
                          .document(schoolCode)
                          .collection("GroupChats")
                          .document(element.documentID)
                          .collection("ChatMessages")
                          .snapshots(),
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return Text(
                            "Please wait fetching messages....",
                            style: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic),
                          );
                        }
                        List<DocumentSnapshot> docs = snap.data.documents ?? [];
                        if (docs.last.data['type'] != 'notification')
                          return Row(children: [
                            Text(
                              ((docs.last.data['fromId'].compareTo(docId) ==
                                              0 &&
                                          docs.last.data['isTeacher'] ==
                                              isTeacher)
                                      ? 'You'
                                      : docs.last.data['name']) +
                                  " : ",
                              style: TextStyle(color: Colors.blue[900]),
                            ),
                            Text(
                              docs.last.data['text'],
                              style: TextStyle(color: Colors.black),
                            )
                          ]);
                        else
                          return Text(
                            docs.last.data['text'],
                            style: TextStyle(color: Colors.black),
                          );
                      }));
            }
          }));
    });
    if (list.length > 0) {
      return ListView.separated(
        itemCount: list.length,
        itemBuilder: (context, index) => list.elementAt(index),
        separatorBuilder: (context, index) => Divider(
          thickness: 1,
          color: Colors.black12,
          indent: 70,
        ),
      );
    } else {
      return Center(
        child: Text(
          "Nothing to show here!",
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }
}
