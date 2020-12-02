import 'dart:async';
import 'dart:ui';

import 'package:Schools/plugins/url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';

import '../../ChatNecessary/UploadFile.dart';
import '../../ChatNecessary/MessageBubble.dart';

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

double pad = 0;

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
  CollectionReference cr;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback(String type, String text, {String fileURL = ''}) async {
    limitOfMessages++;
    messageController.clear();
    await cr
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
    super.initState();
    cr = _firestore
        .collection('School')
        .doc(schoolCode)
        .collection('Classes')
        .doc(classNumber + '_' + section + '_' + subject)
        .collection('Discussions');
    setState(() {
      FirebaseFirestore.instance
          .collection('School')
          .doc(schoolCode)
          .collection('Student')
          .doc(studentId)
          .get()
          .then((value) => studentName =
              value.data()['first name'] + ' ' + value.data()['last name'])
          .then((value) {
        user = User(studentName, className, schoolCode, studentId, classNumber,
            section, subject, false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      pad = kIsWeb &&
              MediaQuery.of(context).size.width >
                  MediaQuery.of(context).size.height
          ? MediaQuery.of(context).size.width / 2 - 300
          : 0;
    });
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
                  stream: cr
                      .orderBy('date', descending: true)
                      .limit(limitOfMessages)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    List<DocumentSnapshot> docs = snapshot.data.docs;
                    print(limitOfMessages);

                    List<Widget> messages = docs
                        .map((doc) => Message(
                              key: UniqueKey(),
                              from: doc.data()['from'],
                              text: doc.data()['text'],
                              fromId: doc.data()['fromId'],
                              isTeacher: doc.data()['isTeacher'],
                              type: doc.data()['type'],
                              date: doc.data()['date'],
                              fileURL: doc.data()['fileURL'],
                              me: studentId == doc.data()['fromId'],
                              pad: pad,
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
                        final result = await FilePicker.platform
                            .pickFiles(allowMultiple: true, withData: true);
                        if (result != null) {
                          
                          result.files.forEach((file) async {
                                      await UrlUtils.uploadFileToFirebase(
                                    file,
                                    '$schoolCode/$classNumber/$section/$subject/',
                                    context, cr, {
                                    'from': user.userName,
                                    'fromId': user.userId,
                                    'type': "File",
                                    'isTeacher': user.isTeacher,
                                    'date': DateTime.now().toIso8601String().toString()},
                                    'fileURL', 
                                    'text'
                                  );
                                });
                      }
                      }),
                    
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
