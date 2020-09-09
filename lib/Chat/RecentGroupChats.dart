import 'dart:typed_data';

import 'package:Schools/Chat/GroupChatBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String docId, schoolCode;
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
              return Text(
                "Please wait fetching group details....",
                style: TextStyle(
                    color: Colors.lightBlue[500], fontStyle: FontStyle.italic),
              );
            } else {
              DocumentSnapshot snapshotData = snap.data;
              return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
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
                  },
                  leading: snapshotData["Icon"] != null
                      ?  CircleAvatar(
                                  radius: 28,
                                  backgroundImage:
                                      MemoryImage(Uint8List.fromList(List<int>.unmodifiable(snapshotData.data['Icon'])))
                                  //NetworkImage( snapshotData.data["Icon"]))
                      )
                      : CircleAvatar(
                          radius: 28,
                          child: Icon(
                            Icons.people,
                            color: Colors.grey[500],
                            size: 40,
                          ),
                          backgroundColor: Colors.white,
                        ),
                  title: Text(
                    snapshotData.data['Name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: StreamBuilder(
                      stream: Firestore.instance
                          .collection("School")
                          .document(schoolCode)
                          .collection("GroupChats")
                          .document(element.documentID)
                          .collection("ChatMessages")
                          .snapshots(),
                      builder: (context, snap) {
                        if (!snap.hasData ||
                            snap.connectionState == ConnectionState.waiting) {
                          return Text(
                            "Please wait fetching messages....",
                            style: TextStyle(
                                color: Colors.lightBlue[500],
                                fontStyle: FontStyle.italic),
                          );
                        }
                        List<DocumentSnapshot> docs = snap.data.documents ?? [];
                        return Text(docs.first['text'] ?? '');
                      }));
            }
          }));
    });
    if (list.length > 0) {
      return ListView(
        children: list,
      );
    } else {
      return Center(
        child: Text("Nothing to show here!"),
      );
    }
  }
}
