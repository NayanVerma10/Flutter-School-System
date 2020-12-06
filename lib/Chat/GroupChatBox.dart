import 'dart:async';

import 'package:Schools/ChatNecessary/MessageBubble.dart';
import 'package:Schools/plugins/url_launcher/url_launcher.dart';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'CreateGroupUsersList.dart';
import 'ChatBox.dart';
import 'GroupDetails.dart';

class GroupChatBox extends StatefulWidget {
  final DocumentReference GroupRef;
  final String schoolCode, userId;
  final bool isTeacher;
  GroupChatBox(
    this.GroupRef,
    this.schoolCode,
    this.userId,
    this.isTeacher,
  );
  @override
  _GroupChatBoxState createState() => _GroupChatBoxState();
}

class _GroupChatBoxState extends State<GroupChatBox> {
  String groupName, icon, name;
  List<dynamic> members;
  bool isAdmin = false, inProcess1 = true, inProcess2 = true;
  final _firestore = FirebaseFirestore.instance;
  int limitOfMessages = 40;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  CollectionReference cr;
  StreamSubscription<DocumentSnapshot> sub;
  @override
  void initState() {
    super.initState();
    cr = _firestore
        .collection('School')
        .doc(widget.schoolCode)
        .collection('GroupChats')
        .doc(widget.GroupRef.id)
        .collection('ChatMessages');
    FirebaseFirestore.instance
        .collection("School")
        .doc(widget.schoolCode)
        .collection("GroupChats")
        .doc(widget.GroupRef.id)
        .collection("Members")
        .doc(widget.userId + "_" + (widget.isTeacher ? "true" : "false"))
        .snapshots()
        .listen((event) {
      if (event != null && event.data() != null) {
        setState(() {
          name = event.data()['name'];
          isAdmin = event.data()['isAdmin'];
        });
      }
    });
    sub = widget.GroupRef.snapshots().listen((event) {
      if (event.data()['Icon'] != null && event.data()['Icon'] != "")
        icon = event.data()['Icon'];
      groupName = event.data()['Name'];
    });
  }

  Future<void> callback(String sc, String did, String sn, String sid, bool sit,
      String text, String type,
      {String fileURL = ''}) async {
    cr = _firestore
        .collection('School')
        .doc(widget.schoolCode)
        .collection('GroupChats')
        .doc(widget.GroupRef.id)
        .collection('ChatMessages');
    limitOfMessages++;
    messageController.clear();
    String date = DateTime.now().toIso8601String().toString();
    await cr.doc(timeToString()).set({
      'text': text,
      'name': sn,
      'fromId': widget.userId,
      'type': type,
      'isTeacher': widget.isTeacher,
      'url': fileURL,
      'date': date,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 35, // to make it look like whatsapp
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            icon != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                    icon,
                  ))
                : CircleAvatar(
                    child: Icon(
                      Icons.people,
                      color: Colors.grey[500],
                    ),
                    backgroundColor: Colors.white,
                  ),
            SizedBox(
              width: 10,
            ),
            FlatButton(
              child: Text(
                groupName ?? "",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              onPressed: (groupName == null || name == null || isAdmin == null)
                  ? null
                  : () async {
                      sub.pause();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(name: 'GroupDetails'),
                          builder: (context) => GroupDetails(
                            widget.schoolCode,
                            widget.GroupRef,
                            widget.userId,
                            widget.isTeacher,
                            isAdmin,
                            name,
                          ),
                        ),
                      );
                    },
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
              tooltip: isAdmin ? 'Add a member' : 'Only admin can add members',
              icon: Icon(
                Icons.person_add,
                color: Colors.black,
              ),
              onPressed: isAdmin
                  ? () async {
                      members = List<dynamic>();
                      await FirebaseFirestore.instance
                          .collection("School")
                          .doc(widget.schoolCode)
                          .collection("GroupChats")
                          .doc(widget.GroupRef.id)
                          .collection("Members")
                          .get()
                          .then((value) {
                        setState(() {
                          value.docs.forEach((element) {
                            if (element.data()['isTeacher']) {
                              members.add(Teacher.fromMap(element.data()));
                            } else {
                              members.add(Student.fromMap(element.data()));
                            }
                          });
                        });
                      });
                      List<dynamic> newUsers =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CreateGroup(
                                    widget.schoolCode,
                                    widget.userId,
                                    widget.isTeacher,
                                    alreadyAdded: members,
                                  )));
                      if (newUsers != null) {
                        CollectionReference teachersRef = FirebaseFirestore
                            .instance
                            .collection("School")
                            .doc(widget.schoolCode)
                            .collection("Teachers");
                        CollectionReference studentsRef = FirebaseFirestore
                            .instance
                            .collection("School")
                            .doc(widget.schoolCode)
                            .collection("Student");
                        newUsers.forEach((element) async {
                          await widget.GroupRef.collection("Members")
                              .doc(element.id +
                                  "_" +
                                  (element.isTeacher ? "true" : "false"))
                              .set(element.toMap());
                          if (element.isTeacher) {
                            await teachersRef
                                .doc(element.id)
                                .collection("GroupsJoined")
                                .doc(widget.GroupRef.id)
                                .set({});
                          } else {
                            await studentsRef
                                .doc(element.id)
                                .collection("GroupsJoined")
                                .doc(widget.GroupRef.id)
                                .set({});
                          }
                          await widget.GroupRef.collection('ChatMessages')
                              .doc(timeToString())
                              .set({
                            'type': 'notification',
                            'text': '$name added ${element.name}'
                          });
                        });
                      }
                    }
                  : null),
          IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {}), // the 3 dots for more options
        ],
      ),
      /*---------------------------This the Main body of the page -----------------------------------------------*/
      body: (groupName == null || name == null || isAdmin == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              // padding: EdgeInsets.symmetric(horizontal: kIsWeb?MediaQuery.of(context).size.width/6:0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: widget.GroupRef.collection("ChatMessages")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        List<DocumentSnapshot> docs = snapshot.data.docs;
                        print(docs.last.data().toString());
                        List<Widget> messages = docs.map((doc) {
                          switch (doc.data()['type']) {
                            case "notification":
                              return Bubble(
                                margin: BubbleEdges.all(4),
                                color: Colors.black,
                                alignment: Alignment.center,
                                child: Text(
                                  doc.data()['text'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            default:
                              return Message(
                                key: UniqueKey(),
                                from: doc.data()['name'],
                                text: doc.data()['text'],
                                fromId: doc.data()['fromId'],
                                isTeacher: doc.data()['isTeacher'],
                                type: doc.data()['type'],
                                date: doc.data()['date'],
                                fileURL: doc.data()['url'],
                                me: (widget.userId == doc.data()['fromId']) &
                                    (widget.isTeacher ==
                                        doc.data()['isTeacher']),
                                pad: pad,
                              );
                          }
                        }).toList();
                        return ListView.builder(
                          reverse: true,
                          controller: scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) =>
                              messages[messages.length - index - 1],
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.transparent),
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            onSubmitted: (value) =>
                                messageController.text.trim().length > 0
                                    ? callback(
                                        widget.schoolCode,
                                        widget.GroupRef.id,
                                        name,
                                        widget.userId,
                                        widget.isTeacher,
                                        messageController.text,
                                        'text',
                                      )
                                    : null,
                            decoration: InputDecoration(
                              hintText: "Enter a Message...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(70),
                              ),
                            ),
                            controller: messageController,
                          ),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        FloatingActionButton(
                          elevation: 0,
                          tooltip: 'Upload Files',
                          child: Icon(Icons.attach_file),
                          heroTag: null,
                          onPressed: () async {
                            final result = await FilePicker.platform
                                .pickFiles(allowMultiple: true, withData: true);
                            if (result != null) {
                              result.files.forEach((file) async {
                                await UrlUtils.uploadFileToFirebase(
                                    file,
                                    "${widget.schoolCode}/GroupChats/${widget.GroupRef.id}/",
                                    context,
                                    cr,
                                    {
                                      'name': name,
                                      'fromId': widget.userId,
                                      'type': "File",
                                      'isTeacher': widget.isTeacher,
                                      'date': DateTime.now()
                                          .toIso8601String()
                                          .toString(),
                                    },
                                    "url",
                                    "text");
                              });
                            }
                          },
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        SendButton(
                          text: "Send",
                          callback: () {
                            messageController.text.trim().length > 0
                                ? callback(
                                    widget.schoolCode,
                                    widget.GroupRef.id,
                                    name,
                                    widget.userId,
                                    widget.isTeacher,
                                    messageController.text,
                                    'text',
                                  )
                                : null;
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
