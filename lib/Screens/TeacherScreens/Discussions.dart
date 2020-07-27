import 'dart:async';
import 'dart:ui';

import 'package:bubble/bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';

import '../../ChatNecessary/UploadFile.dart';
import '../../ChatNecessary/URLLauncher.dart';
import '../../ChatNecessary/DownloadFile.dart';

class User {
  String className, schoolCode, userId, classNumber, section, subject, userName;
  bool isTeacher;
  User(this.userName, this.className, this.schoolCode, this.userId,
      this.classNumber, this.section, this.subject, this.isTeacher);
}

double pad = 0;

class Discussions extends StatefulWidget {
  String className, schoolCode, teachersId, classNumber, section, subject;
  Discussions(
      {Key key,
      this.className,
      this.schoolCode,
      this.teachersId,
      this.classNumber,
      this.section,
      this.subject})
      : super(key: key);
  @override
  _DiscussionsState createState() => _DiscussionsState(
      className, schoolCode, teachersId, classNumber, section, subject);
}

class _DiscussionsState extends State<Discussions> {
  String className,
      schoolCode,
      teachersId,
      classNumber,
      section,
      subject,
      teachersName;
  User user;
  int limitOfMessages = 200;
  _DiscussionsState(this.className, this.schoolCode, this.teachersId,
      this.classNumber, this.section, this.subject);

  final Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback(String type, String text, {String fileURL = ''}) async {
    limitOfMessages++;
    messageController.clear();
    await _firestore
        .collection('School')
        .document(schoolCode)
        .collection('Classes')
        .document(classNumber + '_' + section + '_' + subject)
        .collection('Discussions')
        .add({
      'text': text,
      'from': user.userName,
      'fromId': user.userId,
      'type': type,
      'isTeacher': user.isTeacher,
      'fileURL': fileURL,
      'date': DateTime.now().toIso8601String().toString(),
    });
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pad = kIsWeb &&
            MediaQuery.of(context).size.width >
                MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width / 2 - 300
        : 0;
    setState(() {
      Firestore.instance
          .collection('School')
          .document(schoolCode)
          .collection('Teachers')
          .document(teachersId)
          .get()
          .then((value) => teachersName =
              value.data['first name'] + ' ' + value.data['last name'])
          .then((value) {
        user = User(teachersName, className, schoolCode, teachersId,
            classNumber, section, subject, true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(className + ' Discussions'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: pad),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('School')
                      .document(schoolCode)
                      .collection('Classes')
                      .document(classNumber + '_' + section + '_' + subject)
                      .collection('Discussions')
                      .orderBy('date', descending: true)
                      .limit(limitOfMessages)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    List<DocumentSnapshot> docs = snapshot.data.documents;
                    print(limitOfMessages);

                    List<Widget> messages = docs
                        .map((doc) => Message(
                              from: doc.data['from'],
                              text: doc.data['text'],
                              fromId: doc.data['fromId'],
                              isTeacher: doc.data['isTeacher'],
                              type: doc.data['type'],
                              date: doc.data['date'],
                              fileURL: doc.data['fileURL'],
                              me: teachersId == doc.data['fromId'],
                            ))
                        .toList();
                    List<Widget> reversedMessages = messages.reversed
                        .toList(); // This is Important because the data is captured in decending order
                    Timer(
                        Duration(milliseconds: 200),
                        () => scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 200),
                            ));
                    return ListView(
                      controller: scrollController,
                      children: <Widget>[
                        ...reversedMessages,
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
                                      '$schoolCode/$classNumber/$section/$subject/',
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
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      tooltip: text,
      child: Icon(Icons.send),
      onPressed: callback,
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;
  final String fromId;
  final String date;
  final bool isTeacher;
  final String fileURL;
  final String type;
  final bool me;

  const Message(
      {Key key,
      this.from,
      this.type,
      this.text,
      this.me,
      this.isTeacher,
      this.fileURL,
      this.date,
      this.fromId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            from,
            style: TextStyle(
              fontSize: 8,
              fontWeight: isTeacher ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Bubble(
            color: me ? Colors.green[100] : Colors.deepPurple[100],
            nip: me ? BubbleNip.rightTop : BubbleNip.leftTop,
            nipWidth: 12,
            elevation: 2,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: (MediaQuery.of(context).size.width - (2 * pad)) * 0.7,
              ),
              padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
              child: Column(
                crossAxisAlignment:
                    me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  type == 'File'
                      ? fileWidget(context)
                      : Text(
                          text,
                        ),
                  Text(
                    date.split('T')[0] +
                        ' ' +
                        date.split('T')[1].substring(0, 5),
                    style: TextStyle(fontSize: 6),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  fileWidget(BuildContext context) {
    String fileExtention = text.split('.').last;
    List<String> imageExtensions = [
      'jpg',
      'jpeg',
      'jpe',
      'jif',
      'jfif',
      'jfi',
      'png',
      'gif',
      'webp',
      'tiff',
      'tif '
    ];

    return Column(
      children: [
        imageExtensions.contains(fileExtention)
            ? Column(
                children: [
                  Image.network(
                    fileURL,
                    key: UniqueKey(),
                    scale: 0.2,
                  ),
                  ListTile(
                    onTap: () {
                      URLLauncher(fileURL);
                    },
                    title: Text(
                      text,
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.file_download),
                      onPressed: () async {
                        await downloadFile(fileURL, text, context);
                      },
                    ),
                  )
                ],
              )
            : ListTile(
                onTap: () {
                  URLLauncher(fileURL);
                },
                title: Text(
                  text,
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Offstage(
                      offstage: false,
                      child: IconButton(
                        icon: const Icon(Icons.file_download),
                        onPressed: () async {
                          await downloadFile(fileURL, text, context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
