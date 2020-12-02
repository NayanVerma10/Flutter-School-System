import 'package:Schools/Chat/GroupChatBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GroupChat extends StatefulWidget {
  final List<DocumentSnapshot> snapshot;
  final String docId, schoolCode;
  final bool isTeacher;

  GroupChat(this.snapshot, this.docId, this.schoolCode, this.isTeacher);
  @override
  _GroupChatState createState() =>
      _GroupChatState(snapshot, docId, schoolCode, isTeacher);
}

class _GroupChatState extends State<GroupChat> {
  List<Widget> list;
  List<DocumentSnapshot> snapshot;
  String docId, schoolCode, name;
  bool isTeacher;
  _GroupChatState(this.snapshot, this.docId, this.schoolCode, this.isTeacher);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    list = List<Widget>();
    List<DocumentSnapshot> groupIds = snapshot;
    groupIds.forEach((element) {
      list.add(StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('School')
              .doc(schoolCode)
              .collection("GroupChats")
              .doc(element.id)
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
                  onTap: element.id != null
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  settings: RouteSettings(name: 'GroupChatBox'),
                                  builder: (context) => GroupChatBox(
                                        FirebaseFirestore.instance
                                            .collection('School')
                                            .doc(schoolCode)
                                            .collection("GroupChats")
                                            .doc(element.id),
                                        schoolCode,
                                        docId,
                                        isTeacher,
                                      )));
                        }
                      : null,
                  leading: snapshotData.data()["Icon"] != null
                      ? CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            snapshotData.data()['Icon'],
                            //"https://firebasestorage.googleapis.com/v0/b/aatmanirbhar-51cd2.appspot.com/o/6789%2FGroupChats%2F9DOoEgj2wpV7RkvspoHT%2Ficon%2Fimages.jpeg?alt=media&token=773d9609-d57c-41c5-b119-648581211590"
                          ))
                      : CircleAvatar(
                          radius: 28,
                          child: Icon(
                            Icons.people,
                            color: Colors.grey[500],
                          ),
                          backgroundColor: Colors.white,
                        ),
                  title: Text(
                    snapshotData.data()['Name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("School")
                          .doc(schoolCode)
                          .collection("GroupChats")
                          .doc(element.id)
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
                        List<DocumentSnapshot> docs = snap.data.docs ?? [];
                        if (docs.last.data()['type'] != 'notification') {
                          String dateOfMessage =
                              docs.last.data()['date'].toString().split('T')[0];
                          String timeOfMessage = docs.last
                              .data()['date']
                              .toString()
                              .split('T')[1]
                              .split('.')[0]
                              .substring(0, 5);
                          String string = 'Testing';

                          if (dateOfMessage ==
                              DateTime.now()
                                  .toIso8601String()
                                  .toString()
                                  .split('T')[0])
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
                      stream: FirebaseFirestore.instance
                          .collection("School")
                          .doc(schoolCode)
                          .collection("GroupChats")
                          .doc(element.id)
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
                        List<DocumentSnapshot> docs = snap.data.docs ?? [];
                        if (docs.last.data()['type'].toString().compareTo('notification')!=0)
                          return RichText(
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <InlineSpan>[
                                TextSpan(
                                    text: docs.last.data()['fromId'] == docId
                                        ? 'You : '
                                        : docs.last.data()['name']+" : ",
                                    style: TextStyle(
                                        color: Colors.blue[
                                            900])), //This is for if the message is form us
                                kIsWeb
                                    ? TextSpan(
                                        text: docs.last.data()['type'] == 'File'
                                            ? 'File : '
                                            : ' ',
                                      )
                                    : WidgetSpan(
                                        style: TextStyle(fontSize: 16),
                                        child: docs.last.data()['type'] == 'File'
                                            ? Icon(Icons.attach_file, size: 16)
                                            : Text(' '),
                                      ), //This is if the message is a file
                                TextSpan(
                                    text: docs.last.data()['text'].toString()), //This is the text
                              ]));
                        else
                          return Text(
                            docs.last.data()['text'],
                            style: TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
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
