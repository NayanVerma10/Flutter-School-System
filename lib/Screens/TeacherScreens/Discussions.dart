import 'dart:async';
import 'dart:ui';

import 'package:Schools/plugins/url_launcher/url_launcher.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as flm;

import '../../ChatNecessary/UploadFile.dart';
import '../../ChatNecessary/MessageBubble.dart';

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

  CollectionReference cr;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback(String type, String text, {String fileURL = ''}) async {
    limitOfMessages++;
    messageController.clear();
    await cr.add({
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
    return;
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _getToken() {
    _firebaseMessaging.getToken().then((token) {
      print('Token : ' + token);
      return token;
    }).then((token) {
      FirebaseFirestore.instance
          .collection('School')
          .doc(schoolCode)
          .collection('Teachers')
          .doc(teachersId)
          .set({
        'deviceToken': token,
      }, SetOptions(merge: true));
    });
  }

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("message " + message.toString());
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("message " + message.toString());
      },
      onResume: (Map<String, dynamic> message) async {
        print("message " + message.toString());
      },
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
    _getToken();
    _configureFirebaseListeners();
    _firebaseMessaging
        .subscribeToTopic(
            schoolCode + '_' + classNumber + '_' + section + '_' + subject)
        .then((value) => print("Yesss"));
    setState(() {
      FirebaseFirestore.instance
          .collection('School')
          .doc(schoolCode)
          .collection('Teachers')
          .doc(teachersId)
          .get()
          .then((value) => teachersName =
              value.data()['first name'] + ' ' + value.data()['last name'])
          .then((value) {
        user = User(teachersName, className, schoolCode, teachersId,
            classNumber, section, subject, true);
      });
    });
    try {
      AwesomeNotifications().createdStream.listen((event) async {
        if (event.payload['senderId'].toString().compareTo(teachersId) == 0 &&
            event.payload['isTeacher']) {
          await AwesomeNotifications().cancel(event.id);
          // AndroidFlutterLocalNotificationsPlugin().cancel(event.id).then((value) => print("done"));
        }
      });
    } catch (e) {
      print(e);
    }
    try {
      AwesomeNotifications().actionStream.listen((event) async {
        print(event.toMap());
        if (event.payload['type']
                    .toString()
                    .compareTo('DiscussionChatMessage') ==
                0 &&
            event.buttonKeyInput != null &&
            event.buttonKeyInput.length > 0) {
          await _firestore.collection(event.payload['collectionId']).add({
            'text': event.buttonKeyInput,
            'from': user.userName,
            'fromId': teachersId,
            'type': 'text',
            'isTeacher': true,
            'fileURL': '',
            'date': DateTime.now().toIso8601String().toString(),
          });

          limitOfMessages++;
        }
      });
    } catch (e) {
      print(e);
    }
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
                              from: doc.data()['from'],
                              text: doc.data()['text'],
                              fromId: doc.data()['fromId'],
                              isTeacher: doc.data()['isTeacher'],
                              type: doc.data()['type'],
                              date: doc.data()['date'],
                              fileURL: doc.data()['fileURL'],
                              me: teachersId == doc.data()['fromId'],
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
                                context,
                                cr,
                                {
                                  'from': user.userName,
                                  'fromId': user.userId,
                                  'type': 'File',
                                  'isTeacher': user.isTeacher,
                                  'date': DateTime.now()
                                      .toIso8601String()
                                      .toString(),
                                },
                                'fileURL',
                                'text');
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
