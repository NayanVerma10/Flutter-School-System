import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../ChatNecessary/URLLauncher.dart';
import '../ChatNecessary/UploadFile.dart';
import '../ChatNecessary/MessageBubble.dart';
import 'ChatPersonProfile.dart';

class ChatBox extends StatefulWidget {
  String schoolCode, sender_docId, reciever_docId;
  bool sender_isTeacher, reciever_isTeacher;
  ChatBox(this.schoolCode, this.sender_docId, this.sender_isTeacher,
      this.reciever_docId, this.reciever_isTeacher);

  @override
  _ChatBoxState createState() => _ChatBoxState(schoolCode, sender_docId,
      sender_isTeacher, reciever_docId, reciever_isTeacher);
}

double pad = 0;

class _ChatBoxState extends State<ChatBox> {
  String schoolCode, sender_docId, reciever_docId;
  bool sender_isTeacher, reciever_isTeacher;
  _ChatBoxState(this.schoolCode, this.sender_docId, this.sender_isTeacher,
      this.reciever_docId, this.reciever_isTeacher);

  static Map<String, dynamic> reciever = {'first name': ' ', 'last name': ' '};
  static Map<String, dynamic> sender = {'first name': ' ', 'last name': ' '};
  bool loading = true;
  final _firestore = Firestore.instance;
  int limitOfMessages = 40;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback(String type, String text, {String fileURL = ''}) async {
    limitOfMessages++;
    messageController.clear();
    String date = DateTime.now().toIso8601String().toString();
    await _firestore
        .collection('School')
        .document(schoolCode)
        .collection('Chats')
        .document(reciever_docId + '_' + sender_docId)
        .collection('Chat')
        .add({
      'text': text,
      'from': (sender['first name'] ?? '') + ' ' + (sender['last name']),
      'fromId': sender_docId,
      'type': type,
      'isTeacher': sender_isTeacher,
      'fileURL': fileURL,
      'date': date,
    });
    await _firestore
        .collection('School')
        .document(schoolCode)
        .collection('Chats')
        .document(sender_docId + '_' + reciever_docId)
        .collection('Chat')
        .add({
      'text': text,
      'from': (sender['first name'] ?? '') + ' ' + (sender['last name']),
      'fromId': sender_docId,
      'type': type,
      'isTeacher': sender_isTeacher,
      'fileURL': fileURL,
      'date': date,
    });
    await _firestore
        .collection('School')
        .document(schoolCode)
        .collection(reciever_isTeacher ? 'Teachers' : 'Student')
        .document(reciever_docId)
        .collection('recentChats')
        .document(sender_docId)
        .setData(
      {
        'type': type,
        'text': text,
        'name': (sender['first name'] ?? '') + ' ' + (sender['last name']),
        'fromId': sender_docId,
        'date': date,
        'isTeacher': sender_isTeacher,
        'url': sender['url'],
      },
    );
    await _firestore
        .collection('School')
        .document(schoolCode)
        .collection(sender_isTeacher ? 'Teachers' : 'Student')
        .document(sender_docId)
        .collection('recentChats')
        .document(reciever_docId)
        .setData(
      {
        'type': type,
        'text': text,
        'name': (reciever['first name'] ?? '') + ' ' + (reciever['last name']),
        'fromId': sender_docId,
        'date': date,
        'isTeacher': reciever_isTeacher,
        'url': reciever['url'],
      },
    );
  }

  Future<void> loadData() async {
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection(reciever_isTeacher ? 'Teachers' : 'Student')
        .document(reciever_docId)
        .get()
        .then((value) {
      setState(() {
        reciever = value.data;
      });
    });
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection(sender_isTeacher ? 'Teachers' : 'Student')
        .document(sender_docId)
        .get()
        .then((value) {
      setState(() {
        sender = value.data;
      });
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        setState(() {
          limitOfMessages += 40;
          print(limitOfMessages);
        });
      }
    });
    loadData();
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

    // if (loading)
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 30,
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            reciever['url'] != null
                ? CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    backgroundImage: Image.network(reciever['url']).image,
                  )
                : CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black54,
                    child: Text(reciever['first name'][0].toUpperCase() +
                        reciever['last name'][0].toUpperCase()),
                  ),
            SizedBox(
              width: 10,
            ),
            FlatButton(
              splashColor: Colors.black12,
              child: Text((reciever['first name'] ?? '') +
                  ' ' +
                  (reciever['last name']), style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:(context)=>ChatPersonProfile(
                    schoolCode, reciever_docId, reciever_isTeacher)));
              },
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.call),
              onPressed: () {
                URLLauncher('tel:' + reciever['mobile']);
              }),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
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
                stream: _firestore
                    .collection('School')
                    .document(schoolCode)
                    .collection('Chats')
                    .document(reciever_docId + '_' + sender_docId)
                    .collection('Chat')
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
                            me: sender_docId == doc.data['fromId'],
                            pad: pad,
                          ))
                      .toList();
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
                                    '$schoolCode Chats/$sender_docId/', file);
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

    /*-----------------------------------------------*This is the END of MAIN part -----------------------------------*/
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
