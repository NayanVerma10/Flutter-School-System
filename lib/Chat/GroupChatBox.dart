import 'dart:io';

import 'package:Schools/ChatNecessary/MessageBubble.dart';
import 'package:Schools/ChatNecessary/UploadFile.dart';
import 'package:Schools/Screens/StudentScreens/main.dart';
import 'package:Schools/Screens/TeacherScreens/main.dart';
import 'package:Schools/plugins/url_launcher.dart';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'ChatList.dart';
import 'CreateGroupUsersList.dart';
import 'ChatBox.dart';
import 'GroupDetails.dart';

class GroupChatBox extends StatefulWidget {
  DocumentReference GroupRef;
  String schoolCode, userId;
  bool isTeacher;
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
  List<User> members;
  bool isAdmin = false, inProcess1 = true, inProcess2 = true;
  final _firestore = Firestore.instance;
  int limitOfMessages = 40;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.instance
        .collection("School")
        .document(widget.schoolCode)
        .collection("GroupChats")
        .document(widget.GroupRef.documentID)
        .collection("Members")
        .document(widget.userId + "_" + (widget.isTeacher ? "true" : "false"))
        .snapshots()
        .listen((event) {
      if (event != null && event.data != null) {
        setState(() {
          name = event.data['name'];
          isAdmin = event.data['isAdmin'];
        });
      }
    });
    widget.GroupRef.snapshots().listen((event) {
      setState(() {
        icon = event.data['Icon'];
        groupName = event.data['Name'];
      });
    });
  }

  Future<void> callback(String type, String text, {String fileURL = ''}) async {
    limitOfMessages++;
    messageController.clear();
    String date = DateTime.now().toIso8601String().toString();
    await _firestore
        .collection('School')
        .document(widget.schoolCode)
        .collection('GroupChats')
        .document(widget.GroupRef.documentID)
        .collection('ChatMessages')
        .document(timeToString())
        .setData({
      'text': text,
      'name': name,
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
                    backgroundImage: Image.network(
                    icon,
                    fit: BoxFit.cover,
                  ).image)
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
                  : () {
                      Navigator.push(
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
                      members = List<User>();
                      await Firestore.instance
                          .collection("School")
                          .document(widget.schoolCode)
                          .collection("GroupChats")
                          .document(widget.GroupRef.documentID)
                          .collection("Members")
                          .getDocuments()
                          .then((value) {
                        setState(() {
                          value.documents.forEach((element) {
                            members.add(User.fromMap(element.data));
                          });
                        });
                      });
                      List<User> newUsers =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CreateGroup(
                                    widget.schoolCode,
                                    widget.userId,
                                    widget.isTeacher,
                                    alreadyAdded: members,
                                  )));
                      if (newUsers != null) {
                        CollectionReference teachersRef = Firestore.instance
                            .collection("School")
                            .document(widget.schoolCode)
                            .collection("Teachers");
                        CollectionReference studentsRef = Firestore.instance
                            .collection("School")
                            .document(widget.schoolCode)
                            .collection("Student");
                        newUsers.forEach((element) async {
                          await widget.GroupRef.collection("Members")
                              .document(element.id +
                                  "_" +
                                  (element.isTeacher ? "true" : "false"))
                              .setData(element.toMap());
                          if (element.isTeacher) {
                            await teachersRef
                                .document(element.id)
                                .collection("GroupsJoined")
                                .document(widget.GroupRef.documentID)
                                .setData({});
                          } else {
                            await studentsRef
                                .document(element.id)
                                .collection("GroupsJoined")
                                .document(widget.GroupRef.documentID)
                                .setData({});
                          }
                          await widget.GroupRef.collection('ChatMessages')
                              .document(timeToString())
                              .setData({
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
              padding: EdgeInsets.symmetric(horizontal: pad),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: widget.GroupRef.collection("ChatMessages")
                          .limit(limitOfMessages)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        List<DocumentSnapshot> docs = snapshot.data.documents;
                        List<Widget> messages = docs.map((doc) {
                          if (doc.data['type']
                                  .toString()
                                  .compareTo('notification') ==
                              0) {
                            return Bubble(
                              margin: BubbleEdges.all(4),
                              color: Colors.black,
                              alignment: Alignment.center,
                              child: Text(
                                doc.data['text'],
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                          return Message(
                            key: UniqueKey(),
                            from: doc.data['name'],
                            text: doc.data['text'],
                            fromId: doc.data['fromId'],
                            isTeacher: doc.data['isTeacher'],
                            type: doc.data['type'],
                            date: doc.data['date'],
                            fileURL: doc.data['url'],
                            me: (widget.userId == doc.data['fromId']) &
                                (widget.isTeacher == doc.data['isTeacher']),
                            pad: pad,
                          );
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
                                    ? callback('text', messageController.text)
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
                          tooltip: 'Start Meeting',
                          child: Icon(Icons.attach_file),
                          heroTag: null,
                          onPressed: () async {
                            final result = await FilePicker.platform
                                .pickFiles(allowMultiple: true);
                            if (result != null) {
                              List<PlatformFile> pFiles = result.files;
                              if (kIsWeb) {
                                UrlUtils.UploadFiles(
                                  result,
                                  widget.GroupRef.collection('ChatMessages'),
                                  "${widget.schoolCode}/GroupChats/${widget.GroupRef.documentID}/",
                                  name: name,
                                  isTeacher: widget.isTeacher,
                                  fromId: widget.userId,
                                );
                              } else {
                                pFiles.forEach((element) async {
                                  List<String> fileData = await uploadToFirebase(
                                      "${widget.schoolCode}/GroupChats/${widget.GroupRef.documentID}/",
                                      File(element.path));
                                  await callback('File', fileData[1],
                                      fileURL: fileData[0]);
                                });
                              }
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
                                ? callback('Text', messageController.text)
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
