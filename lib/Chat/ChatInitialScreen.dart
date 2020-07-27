import 'package:flutter/material.dart';
import '../ChatNecessary/UploadFile.dart';

import './ChatList.dart';
import './ChatBox.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('TODO')),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.chat),
          onPressed: () async {
            dynamic results;
            results = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatList(schoolCode)));
            print(results);
            Navigator.push(context, SlideLeftRoute(page: ChatBox(schoolCode,docId,isTeacher,results[0],results[1])));
          }),
    );
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
