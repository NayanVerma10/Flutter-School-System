import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('School')
            .document(schoolCode)
            .collection(isTeacher ? 'Teachers' : 'Student')
            .document(docId)
            .collection('recentChats')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          List<DocumentSnapshot> docs = snapshot.data.documents;
          List<Widget> recentChats = docs.map((doc) {
            String dateOfMessage=doc.data['date'].toString().split('T')[0];
            String timeOfMessage=doc.data['date'].toString().split('T')[1].split('.')[0].substring(0,5);
            String string='Testing';
            
            if(dateOfMessage==DateTime.now().toIso8601String().toString().split('T')[0])
              string=timeOfMessage;
            else if(dateOfMessage== DateTime.now().subtract(Duration(days: 1)).toIso8601String().toString().split('T')[0])
              string='Yesterday';
            else
              string=dateOfMessage;
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
                              doc.data['name'].split(' ')[1][0].toUpperCase()),
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
                            text: doc.data['fromId'] == docId ? 'You : ' : '',
                            style: TextStyle(
                                color: Colors.blue[
                                    900])), //This is for if the message is form us
                        WidgetSpan(
                          child: Icon(
                              doc.data['type'] == 'File'
                                  ? Icons.attach_file
                                  : Icons.text_fields,
                              size: 16),
                        ), //This is if the message is a file
                        TextSpan(  
                            text:
                                ' : \t' + doc.data['text']), //This is the text
                      ])),
                  trailing: Column(
                    children: <Widget>[
                      Text(string,textScaleFactor: 0.8,),
                    ],
                  ),
                  onTap: (){
                    Navigator.push(context, SlideLeftRoute(
                    page: ChatBox(
                        schoolCode, docId, isTeacher, doc.documentID,doc.data['isTeacher'] )));


                  },
                ),
                Divider(
                  indent: 80,
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
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.chat),
          onPressed: () async {
            dynamic results;
            results = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatList(schoolCode)));
            print(results);
            Navigator.push(
                context,
                SlideLeftRoute(
                    page: ChatBox(
                        schoolCode, docId, isTeacher, results[0], results[1])));
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
