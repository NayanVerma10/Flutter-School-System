import 'package:Schools/Chat/GroupChatBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import './ChatList.dart';
import './ChatBox.dart';
import 'CreateGroupUsersList.dart';
import 'RecentGroupChats.dart';

int state = 0;

class MainChat extends StatefulWidget {
  final String schoolCode, docId;
  final bool isTeacher;
  MainChat(this.schoolCode, this.docId, this.isTeacher);

  @override
  _MainChatState createState() => _MainChatState(schoolCode, docId, isTeacher);
}

class _MainChatState extends State<MainChat> {
  final String schoolCode, docId;
  final bool isTeacher;
  _MainChatState(this.schoolCode, this.docId, this.isTeacher);
  Stream stream1, stream2;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _getToken() {
    _firebaseMessaging.getToken().then((token) {
      print('Token : ' + token);
      return token;
    }).then((token) {
      Firestore.instance
          .collection('School')
          .document(schoolCode)
          .collection(isTeacher ? 'Teachers' : 'Student')
          .document(docId)
          .setData({
        'deviceToken': token,
      }, merge: true);
    });
  }

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print(message);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getToken();
    _configureFirebaseListeners();
    stream1 = Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection(isTeacher ? 'Teachers' : 'Student')
        .document(docId)
        .collection('recentChats')
        .orderBy('date', descending: true)
        .snapshots();
    stream2 = Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection("Student")
        .document(docId)
        .collection("GroupsJoined")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    if (state == 0) {
      return Scaffold(
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: stream1,
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              List<DocumentSnapshot> docs = snapshot.data.documents;
              List<Widget> recentChats = docs.map((doc) {
                String dateOfMessage =
                    doc.data['date'].toString().split('T')[0];
                String timeOfMessage = doc.data['date']
                    .toString()
                    .split('T')[1]
                    .split('.')[0]
                    .substring(0, 5);
                String string = 'Testing';

                if (dateOfMessage ==
                    DateTime.now().toIso8601String().toString().split('T')[0])
                  string = timeOfMessage;
                else if (dateOfMessage ==
                    DateTime.now()
                        .subtract(Duration(days: 1))
                        .toIso8601String()
                        .toString()
                        .split('T')[0])
                  string = 'Yesterday';
                else
                  string = dateOfMessage;
                return Column(
                  children: [
                    ListTile(
                      leading: doc.data['url'] != null
                          ? CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 28,
                              backgroundImage: NetworkImage(doc.data['url']),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black54,
                              radius: 28,
                              child: Text(doc.data['name']
                                      .split('')[0][0]
                                      .toUpperCase() +
                                  doc.data['name']
                                      .split(' ')[1][0]
                                      .toUpperCase()),
                            ),
                      title: Text(
                        doc.data['name'].toString().toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: RichText(
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <InlineSpan>[
                                TextSpan(
                                    text: doc.data['fromId'] == docId
                                        ? 'You : '
                                        : ' ',
                                    style: TextStyle(
                                        color: Colors.blue[
                                            900])), //This is for if the message is form us
                                kIsWeb
                                    ? TextSpan(
                                        text: doc.data['type'] == 'File'
                                            ? 'File : '
                                            : '',
                                      )
                                    : WidgetSpan(
                                        style: TextStyle(fontSize: 16),
                                        child: doc.data['type'] == 'File'
                                            ? Icon(Icons.attach_file, size: 16)
                                            : Text(''),
                                      ), //This is if the message is a file
                                TextSpan(
                                    text: doc.data['text']), //This is the text
                              ])),
                      trailing: Column(
                        children: <Widget>[
                          Text(
                            string,
                            textScaleFactor: 0.8,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            SlideLeftRoute(
                                page: ChatBox(schoolCode, docId, isTeacher,
                                    doc.documentID, doc.data['isTeacher'])));
                      },
                    ),
                    Divider(
                      indent: 85,
                      color: Colors.black,
                      endIndent: 15,
                      thickness: 0.1,
                    ),
                  ],
                );
              }).toList();

              return ListView(
                children: <Widget>[
                  ...recentChats,
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.chat),
            onPressed: () async {
              dynamic results;
              results = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatList(schoolCode)));
              print(results);
              Navigator.push(
                  context,
                  SlideLeftRoute(
                      page: ChatBox(schoolCode, docId, isTeacher, results[0],
                          results[1])));
            }),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("Personal")),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), title: Text("Groups"))
          ],
          selectedItemColor: Colors.amber[800],
          currentIndex: state,
          onTap: (int tapped) {
            if (state != tapped) {
              setState(() {
                state = tapped;
              });
            }
          },
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: stream2,
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GroupChat(snapshot, docId, schoolCode, isTeacher);
              }),
        ),
        floatingActionButton: FloatingActionButton(
            tooltip: "Create a group",
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              dynamic results;
              results = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateGroup(schoolCode, docId, isTeacher)));
              //print(results.toString());
              if (results != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupChatBox(
                            results[0], results[1], results[2], results[3],)));
              }
            }),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("Personal")),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), title: Text("Groups"))
          ],
          selectedItemColor: Colors.amber[800],
          currentIndex: state,
          onTap: (int tapped) {
            if (state != tapped) {
              setState(() {
                state = tapped;
              });
            }
          },
        ),
      );
    }
  }
}

class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;
  SlideLeftRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
