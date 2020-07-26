import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'package:universal_html/html.dart' show IFrameElement;

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';

import '../../ChatNecessary/UploadFile.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../ChatNecessary/URLLauncher.dart';

class User {
  String className, schoolCode, userId, classNumber, section, subject, userName;
  bool isTeacher;
  User(this.userName, this.className, this.schoolCode, this.userId,
      this.classNumber, this.section, this.subject, this.isTeacher);
}

class Discussions extends StatefulWidget {
  final String className, schoolCode, studentId, classNumber, section, subject;
  Discussions(
      {Key key,
      this.className,
      this.schoolCode,
      this.studentId,
      this.classNumber,
      this.section,
      this.subject})
      : super(key: key);
  @override
  _DiscussionsState createState() => _DiscussionsState(
      className, schoolCode, studentId, classNumber, section, subject);
}

class _DiscussionsState extends State<Discussions> {
  String className,
      schoolCode,
      studentId,
      classNumber,
      section,
      subject,
      studentName;
  User user;
  int limitOfMessages = 200;
  _DiscussionsState(this.className, this.schoolCode, this.studentId,
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
    setState(() {
      Firestore.instance
          .collection('School')
          .document(schoolCode)
          .collection('Student')
          .document(studentId)
          .get()
          .then((value) => studentName =
              value.data['first name'] + ' ' + value.data['last name'])
          .then((value) {
        user = User(studentName, className, schoolCode, studentId, classNumber,
            section, subject, false);
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
                            key: UniqueKey(),
                            from: doc.data['from'],
                            text: doc.data['text'],
                            fromId: doc.data['fromId'],
                            isTeacher: doc.data['isTeacher'],
                            type: doc.data['type'],
                            date: doc.data['date'],
                            fileURL: doc.data['fileURL'],
                            me: studentId == doc.data['fromId'],
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
                      List<File> files = await attachment();
                      files.forEach((file) async {
                        List<String> fileData = await uploadToFirebase(
                            '$schoolCode/$classNumber/$section/$subject/',
                            file);
                        await callback('File', fileData[1],
                            fileURL: fileData[0]);
                      });
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

// attachment() async{
//     Map<String,String> paths;
//     List<File> files;
//     files = await FilePicker.getMultiFile();
//   }

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
                maxWidth: MediaQuery.of(context).size.width * 0.7,
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

  Future<bool> downloadFile(String url, BuildContext context) async {
    Dio dio = Dio();
    try {
      var dirs = await getExternalStorageDirectories();
      var dir = dirs[0];
      print(dir.path);
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      await dio.download(url, "/storage/emulated/0/MySchools/$text",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
      });
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('$text downloaded')));
      print("Download completed");
    } catch (e) {
      print(e);
    }
    return true;
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
                        await downloadFile(fileURL, context);
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
                          await downloadFile(fileURL, context);
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
