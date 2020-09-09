import 'dart:typed_data';

import 'package:Schools/ChatNecessary/MessageBubble.dart';
import 'package:Schools/ChatNecessary/UploadFile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  String groupName;
  String name1, name2;
  bool loading = true, isAdmin;
  final _firestore = Firestore.instance;
  int limitOfMessages = 40;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  Uint8List bytes;
  @override
  void initState() {
    super.initState();
    widget.GroupRef.get().then((value) {
      setState(() {
        bytes = Uint8List.fromList(List<int>.unmodifiable(value.data["Icon"]));
        groupName = value.data["Name"];
      });
    });
    Firestore.instance
        .collection("School")
        .document(widget.schoolCode)
        .collection(widget.isTeacher ? "Teachers" : "Student")
        .document(widget.userId)
        .get()
        .then((value) {
      name1 = value.data["first name"];
      name2 = value.data["last name"];
    });
    Firestore.instance
        .collection("School")
        .document(widget.schoolCode)
        .collection("GroupChats")
        .document(widget.GroupRef.documentID)
        .collection("Members")
        .document(widget.userId + "_" + (widget.isTeacher ? "true" : "false"))
        .get()
        .then((value) => setState(() {
              isAdmin = value.data['isAdmin'];
            }));
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
      'from': (name1 ?? '') + ' ' + name2,
      'fromId': widget.userId,
      'type': type,
      'isTeacher': widget.isTeacher,
      'fileURL': fileURL,
      'date': date,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(padding: EdgeInsets.only(left: 35)),
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            bytes != null
                ? CircleAvatar(
                    backgroundImage: Image.memory(bytes).image,
                  )
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
            TextButton(
              child: Text(
                groupName ?? "",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GroupDetails(widget.GroupRef, isAdmin)));
              },
            ),
          ],
        ),
        actions: <Widget>[
          // IconButton(
          //     icon: Icon(Icons.call),
          //     onPressed: () {
          //       URLLauncher('tel:' + reciever['mobile']);
          //     }),
          IconButton(
              icon: Icon(
                Icons.person_add,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateGroup(widget.schoolCode,
                            widget.userId, widget.isTeacher)));
              }),
        ],
      ),
      /*---------------------------This the Main body of the page -----------------------------------------------*/
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: pad),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: widget.GroupRef.collection("ChatMessages").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  List<DocumentSnapshot> docs = snapshot.data.documents;
                  //print(limitOfMessages);
                  List<Widget> messages = List();
                  if (docs.length > 0) {
                    docs.map((doc) {
                      messages.add(Message(
                        key: UniqueKey(),
                        from: doc.data['from'],
                        text: doc.data['text'],
                        fromId: doc.data['fromId'],
                        isTeacher: doc.data['isTeacher'],
                        type: doc.data['type'],
                        date: doc.data['date'],
                        fileURL: doc.data['fileURL'],
                        me: widget.userId == doc.data['fromId'],
                        pad: pad,
                      ));
                    });
                  }
                  return ListView(
                    reverse: true,
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
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
                      await attachment()
                          .then((files) => files.forEach((file) async {
                                List<String> fileData = await uploadToFirebase(
                                    '${widget.schoolCode}/GroupChats/${widget.GroupRef.documentID}/',
                                    file);
                                await callback('File', fileData[1],
                                    fileURL: fileData[0]);
                              }));
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
