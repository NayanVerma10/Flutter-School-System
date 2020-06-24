import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String className,
      schoolCode,
      userId,
      classNumber,
      section,
      subject,
      userName;
  bool isTeacher;
  User(this.userName, this.className, this.schoolCode, this.userId,
      this.classNumber, this.section, this.subject,this.isTeacher);
}

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
  _DiscussionsState(this.className, this.schoolCode, this.teachersId,
      this.classNumber, this.section, this.subject);

  final Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    if (messageController.text.length > 0) {
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
        duration: const Duration(milliseconds: 300),
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
          .collection('Teachers')
          .document(teachersId)
          .get()
          .then((value) => teachersName =
              value.data['first name'] + ' ' + value.data['last name'])
          .then((value) {
        user = User(teachersName, className, schoolCode, teachersId,
            classNumber, section, subject,true);
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
              Navigator.of(context).pop();
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
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> messages = docs
                      .map((doc) => Message(
                            from: doc.data['from'],
                            text: doc.data['text'],
                            fromId: doc.data['fromId'],
                            isTeacher: doc.data['isTeacher'],
                            date: doc.data['date'],
                            me: teachersId == doc.data['fromId'],
                          ))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
                  );
                },
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => callback(),
                      decoration: InputDecoration(
                        hintText: "Enter a Message...",
                        border: const OutlineInputBorder(),
                      ),
                      controller: messageController,
                    ),
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
    return FlatButton(
      color: Colors.orange,
      onPressed: callback,
      child: Text(text),
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

  const Message({Key key, this.from, this.text, this.me,this.isTeacher,this.date,this.fromId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            from,
            style: TextStyle(
              fontSize: 8,
              fontWeight: isTeacher?FontWeight.bold:FontWeight.normal,
            ),
          ),
          Material(
            color: me ? Colors.green[100] : Colors.deepPurple[100],
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.75),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Column(
                crossAxisAlignment: me?CrossAxisAlignment.end:CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    textAlign: me ? TextAlign.right:TextAlign.left,
                  ),
                  Text(date.split('T')[0]+' '+date.split('T')[1].substring(0,5),style: TextStyle(fontSize: 6),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
