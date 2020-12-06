import 'package:Schools/Chat/GroupChatBox.dart';
import 'package:Schools/Screens/StudentScreens/main.dart';
import 'package:Schools/Screens/TeacherScreens/main.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
      FirebaseFirestore.instance
          .collection('School')
          .doc(schoolCode)
          .collection(isTeacher ? 'Teachers' : 'Student')
          .doc(docId)
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
    

    _getToken();
    _configureFirebaseListeners();
    stream1 = FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection(isTeacher ? 'Teachers' : 'Student')
        .doc(docId)
        .collection('recentChats')
        .orderBy('date', descending: true)
        .snapshots();
    stream2 = FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection(isTeacher ? 'Teachers' : 'Student')
        .doc(docId)
        .collection("GroupsJoined")
        .snapshots();
    try {
      AwesomeNotifications().createdStream.listen((event) async {
        if (event.payload['senderId'].toString().compareTo(docId) == 0 &&
            event.payload['isTeacher'] == isTeacher) {
          await AwesomeNotifications().cancel(event.id);
          AndroidFlutterLocalNotificationsPlugin().cancel(event.id).then((value) => print("done"));
        }
      });
    } catch (e) {
      print(e);
    }

    try {
      AwesomeNotifications().actionStream.listen((event) async {
        print(event.toMap());
        if (event.payload['type'].toString().compareTo('GroupChatMessage') ==
                0 &&
            event.buttonKeyPressed != null &&
            event.buttonKeyPressed.compareTo("REPLY") == 0) {
          print(event.toString());
          DocumentSnapshot snap = await FirebaseFirestore.instance
              .collection('School')
              .doc(schoolCode)
              .collection(isTeacher ? "Teachers" : "Student")
              .doc(docId)
              .get();
          await FirebaseFirestore.instance
              .collection(event.payload['collectionId'].toString())
              .doc(timeToString())
              .set({
            'text': event.buttonKeyInput,
            'name': snap.data()['first name'] + snap.data()['last name'],
            'fromId': docId,
            'type': "text",
            'isTeacher': isTeacher,
            'url': '',
            'date': DateTime.now().toIso8601String().toString(),
          });
        } else if (event.payload['type']
                    .toString()
                    .compareTo('PersonalChatMessage') ==
                0 &&
            event.buttonKeyPressed.compareTo("REPLY") == 0) {
          await ChatBox(
                  schoolCode,
                  docId,
                  isTeacher,
                  event.payload['receiverId'],
                  event.payload['receiverIsTeacher'])
              .callback(
                  event.buttonKeyInput,
                  schoolCode,
                  event.payload['senderId'],
                  isTeacher,
                  event.payload['receiverId'],
                  event.payload['isTeacher'],
                  event.payload['senderName'],
                  event.payload['receiverName'],
                  event.payload['senderUrl'],
                  event.payload['receiverUrl']);
        }
      });
    } catch (e) {
      print(e);
    }
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
              List<DocumentSnapshot> docs = snapshot.data.docs;
              List<Widget> recentChats = docs.map((doc) {
                print(doc.data());
                String dateOfMessage =
                    doc.data()['date'].toString().split('T')[0];
                String timeOfMessage = doc
                    .data()['date']
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
                      leading: doc.data()['url'] != null
                          ? CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 28,
                              backgroundImage: NetworkImage(doc.data()['url']),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black54,
                              radius: 28,
                              child: Text(doc
                                      .data()['name']
                                      .split('')[0][0]
                                      .toUpperCase() +
                                  doc
                                      .data()['name']
                                      .split(' ')[1][0]
                                      .toUpperCase()),
                            ),
                      title: Text(
                        doc.data()['name'].toString().toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: RichText(
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <InlineSpan>[
                                TextSpan(
                                    text: doc.data()['fromId'] == docId
                                        ? 'You : '
                                        : ' ',
                                    style: TextStyle(
                                        color: Colors.blue[
                                            900])), //This is for if the message is form us
                                kIsWeb
                                    ? TextSpan(
                                        text: doc.data()['type'] == 'File'
                                            ? 'File : '
                                            : '',
                                      )
                                    : WidgetSpan(
                                        style: TextStyle(fontSize: 16),
                                        child: doc.data()['type'] == 'File'
                                            ? Icon(Icons.attach_file, size: 16)
                                            : Text(''),
                                      ), //This is if the message is a file
                                TextSpan(
                                    text:
                                        doc.data()['text']), //This is the text
                              ])),
                      trailing: Text(
                        string,
                        textScaleFactor: 0.8,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            SlideLeftRoute(
                                page: ChatBox(schoolCode, docId, isTeacher,
                                    doc.id, doc.data()['isTeacher'])));
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
                icon: Icon(state == 0 ? Icons.person : Icons.person_outline),
                title: Text(
                  "Personal",
                  style: TextStyle(
                      fontWeight:
                          state == 0 ? FontWeight.bold : FontWeight.normal),
                )),
            BottomNavigationBarItem(
                icon: Icon(state == 1 ? Icons.people : Icons.people_outline),
                title: Text(
                  "Groups",
                  style: TextStyle(
                      fontWeight:
                          state == 1 ? FontWeight.bold : FontWeight.normal),
                ))
          ],
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
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
          child: RefreshIndicator(
            onRefresh: () async {
              await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => widget.isTeacher
                          ? MyAppTeacher(widget.schoolCode, widget.docId)
                          : MyAppStudent(widget.schoolCode, widget.docId)));
            },
            child: StreamBuilder(
                stream: stream2,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  snapshot.data.docs.forEach((d) async {
                    await _firebaseMessaging.subscribeToTopic(d.id);
                  });
                  return GroupChat(
                      snapshot.data.docs, docId, schoolCode, isTeacher);
                }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            tooltip: "Create a group",
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              List<dynamic> results = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateGroup(schoolCode, docId, isTeacher)));

              if (results != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: 'GroupChatBox'),
                        builder: (context) => GroupChatBox(
                            results[0], results[1], results[2], results[3])));
              }
            }),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(state == 0 ? Icons.person : Icons.person_outline),
                title: Text(
                  "Personal",
                  style: TextStyle(
                      fontWeight:
                          state == 0 ? FontWeight.bold : FontWeight.normal),
                )),
            BottomNavigationBarItem(
                icon: Icon(state == 1 ? Icons.people : Icons.people_outline),
                title: Text(
                  "Groups",
                  style: TextStyle(
                      fontWeight:
                          state == 1 ? FontWeight.bold : FontWeight.normal),
                ))
          ],
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
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
