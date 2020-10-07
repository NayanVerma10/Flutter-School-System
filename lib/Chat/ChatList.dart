import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String mobile;
  String classNumber;
  String section;
  bool isTeacher;
  String imgURL;
  String gender;

  User({
    this.id,
    this.name,
    this.mobile,
    this.classNumber,
    this.section,
    this.isTeacher,
    this.imgURL,
    this.gender,
  });

  @override
  User.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.mobile = map['mobile'];
    this.classNumber = map['classNumber'];
    this.section = map['section'];
    this.isTeacher = map['isTeacher'];
    this.imgURL = map['imgURL'];
    this.gender = map['gender'];
  }
  // bool operator ==(b) {
  //   return Comparator(this, b);
  // }

  // bool Comparator(User a, User b) {
  //   Map<String, dynamic> map1 = a.toMap(), map2 = b.toMap();
  //   for (String s in map1.keys) {
  //     if (map1[s] != map2[s]) {
  //       return false;
  //     }
  //   }
  //   return true;
  // }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class ChatList extends StatefulWidget {
  String schoolCode;
  ChatList(this.schoolCode);
  @override
  _ChatListState createState() => _ChatListState(schoolCode);
}

class _ChatListState extends State<ChatList> {
  String schoolCode;
  _ChatListState(this.schoolCode);

  Debouncer _debouncer = new Debouncer(milliseconds: 500);
  List<User> users = List();
  List<User> filteredUsers = List();
  bool loading = true;

  void loadData() async {
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Student')
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              users.add(User(
                mobile: (element.data['mobile'] ?? ''),
                id: element.documentID,
                name: (element.data['first name'] ?? '') +
                    ' ' +
                    (element.data['last name'] ?? ''),
                classNumber: element.data['class'] ?? '',
                section: element.data['section'] ?? '',
                isTeacher: false,
                imgURL: element.data['url'],
              ));
            }));

    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Teachers')
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              users.add(User(
                mobile: element.data['mobile'] ?? '',
                id: element.documentID,
                name: (element.data['first name'] ?? '') +
                    ' ' +
                    (element.data['last name'] ?? ''),
                classNumber: element.data['classteacher'] != null
                    ? element.data['classteacher']['class']
                    : '',
                section: element.data['classteacher'] != null
                    ? element.data['classteacher']['section']
                    : '',
                isTeacher: true,
                imgURL: element.data['url'],
              ));
            }));
    setState(() {
      filteredUsers = users;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
                    hintText: 'Filter by name or mobile',
                  ),
                  onChanged: (string) {
                    _debouncer.run(() {
                      setState(() {
                        filteredUsers = users
                            .where((u) => (u.name
                                    .toLowerCase()
                                    .contains(string.toLowerCase()) ||
                                u.mobile
                                    .toLowerCase()
                                    .contains(string.toLowerCase()) ||
                                u.id
                                    .toLowerCase()
                                    .contains(string.toLowerCase()) ||
                                u.classNumber
                                    .toLowerCase()
                                    .contains(string.toLowerCase()) ||
                                u.section
                                    .toLowerCase()
                                    .contains(string.toLowerCase())))
                            .toList();
                      });
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: filteredUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 0),
                        elevation: 0,
                        child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: ListTile(
                              leading: filteredUsers[index].imgURL != null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: NetworkImage(
                                          filteredUsers[index].imgURL),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      foregroundColor: Colors.black54,
                                      child: Text(filteredUsers[index]
                                              .name
                                              .split('')[0][0]
                                              .toUpperCase() +
                                          filteredUsers[index]
                                              .name
                                              .split(' ')[1][0]
                                              .toUpperCase()),
                                    ),
                              title: Text(
                                filteredUsers[index].name.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(filteredUsers[index].mobile +
                                  '\n' +
                                  filteredUsers[index].classNumber +
                                  ' - ' +
                                  filteredUsers[index].section),
                              isThreeLine: true,
                              trailing: Text(filteredUsers[index].isTeacher
                                  ? 'Teacher'
                                  : 'Student'),
                              dense: false,
                              onTap: () {
                                Navigator.pop(context, [
                                  filteredUsers[index].id,
                                  filteredUsers[index].isTeacher
                                ]);
                              },
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
