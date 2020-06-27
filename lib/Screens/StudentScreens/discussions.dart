import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

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

  Future<void> callback() async {
    if (messageController.text.length > 0) {
        limitOfMessages++;
      await _firestore
          .collection('School')
          .document(schoolCode)
          .collection('Classes')
          .document(classNumber + '_' + section + '_' + subject)
          .collection('Discussions')
          .add({
        'text': messageController.text,
        'from': user.userName,
        'fromId': user.userId,
        'isTeacher': user.isTeacher,
        'date': DateTime.now().toIso8601String().toString(),
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 200),
      );
    }
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
        user = User(studentName, className, schoolCode, studentId,
            classNumber, section, subject, false);
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
                            from: doc.data['from'],
                            text: doc.data['text'],
                            fromId: doc.data['fromId'],
                            isTeacher: doc.data['isTeacher'],
                            date: doc.data['date'],
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
                      onSubmitted: (value) => callback(),
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
                    width: 2,
                  ),
                  SendButton(
                    text: "Send",
                    callback: callback,
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

  final bool me;

  const Message(
      {Key key,
      this.from,
      this.text,
      this.me,
      this.isTeacher,
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
                  Text(
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
}
