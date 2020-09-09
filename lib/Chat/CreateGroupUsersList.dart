import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'ChatList.dart';
import 'GroupName.dart';

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

class CreateGroup extends StatefulWidget {
  String schoolCode, userId;
  static DocumentReference _docRef;
  bool isTeacher;
  List<User> alreadyAdded;
  static set docRef(DocumentReference value) {
    _docRef = value;
  }

  CreateGroup(this.schoolCode, this.userId, this.isTeacher,
      {this.alreadyAdded});

  @override
  _CreateGroupState createState() =>
      _CreateGroupState(schoolCode, userId, isTeacher,
          alreadyAdded: alreadyAdded);
}

class _CreateGroupState extends State<CreateGroup> {
  String schoolCode, userId;
  bool isTeacher;
  List<User> alreadyAdded;
  _CreateGroupState(this.schoolCode, this.userId, this.isTeacher,
      {this.alreadyAdded});
  Debouncer _debouncer = new Debouncer(milliseconds: 500);
  List<User> users = List();
  List<User> filteredUsers = List();
  bool loading = true;
  List<bool> totalUsers;
  int count = 0;
  User user;
  void loadData() async {
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Student')
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              User currentUser = User(
                mobile: (element.data['mobile'] ?? ''),
                id: element.documentID,
                name: (element.data['first name'] ?? '') +
                    ' ' +
                    (element.data['last name'] ?? ''),
                classNumber: element.data['class'] ?? '',
                section: element.data['section'] ?? '',
                isTeacher: false,
                imgURL: (element.data['url'] ?? '') == ''
                    ? null
                    : element.data['url'],
              );
              if (alreadyAdded == null ||
                  (alreadyAdded != null &&
                      !alreadyAdded.contains(currentUser))) {
                users.add(currentUser);
              }
            }));

    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Teachers')
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              User currentUser = User(
                mobile: element.data['mobile'] ?? '',
                id: element.documentID,
                name: (element.data['first name'] ?? '') +
                    ' ' +
                    (element.data['last name'] ?? ''),
                classNumber: element.data['classteacher'] != null
                    ? element.data['classteacher']['class']
                    : (element.data['class'] ?? ''),
                section: element.data['classteacher'] != null
                    ? element.data['classteacher']['section']
                    : element.data['section'] ?? '',
                isTeacher: true,
                imgURL: (element.data['url'] ?? '') == ''
                    ? null
                    : element.data['url'],
              );
              if (alreadyAdded == null ||
                  (alreadyAdded != null &&
                      !alreadyAdded.contains(currentUser))) {
                users.add(currentUser);
              }
            }));

    Firestore.instance
        .collection("School")
        .document(schoolCode)
        .collection(isTeacher ? "Teachers" : "Student")
        .document(userId)
        .get()
        .then((value) {
      setState(() {
        user = User(
            id: value.documentID,
            name: (value.data["first name"] ?? '') +
                    " " +
                    value.data["last name"] ??
                '',
            mobile: value.data["mobile"] ?? '',
            classNumber: value.data['classteacher'] != null
                ? value.data['classteacher']['class']
                : (value.data['class'] ?? ''),
            section: value.data['classteacher'] != null
                ? value.data['classteacher']['section']
                : value.data['section'] ?? '',
            isTeacher: value.data["isTeacher"] ?? false,
            imgURL: (value.data["url"] ?? '') == '' ? null : value.data['url']);
        users.remove(user);
      });
    });
    setState(() {
      filteredUsers = users;
      loading = false;
      for (int i = 0; i < users.length; i++) {
        totalUsers.add(false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
    totalUsers = List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            onPressed: count == 0
                ? null
                : () async {
                    List<User> usersList = List();
                    for (int i = 0; i < users.length; i++) {
                      if (totalUsers.elementAt(i)) {
                        usersList.add(users.elementAt(i));
                      }
                    }
                    user.isAdmin = true;
                    usersList.add(user);
                    var results = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupName(
                                schoolCode, usersList, userId, isTeacher)));
                    if (results != null) {
                      Navigator.pop(context, results);
                    }
                  },
            child: Row(
              children: [
                Icon(
                  Icons.done,
                  color: count > 0 ? Colors.black : Colors.black26,
                ),
                Text(
                  "Done",
                  style: TextStyle(
                      color: count > 0 ? Colors.black : Colors.black26),
                ),
              ],
            ),
          )
        ],
        title: Text('$count selected'),
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
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                      value: totalUsers[index],
                                      onChanged: (value) {
                                        setState(() {
                                          totalUsers[index] = value;
                                          value ? count++ : count--;
                                        });
                                      }),
                                  filteredUsers[index].imgURL != null
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
                                ],
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

String timeToString() {
  return DateTime.now().toString().replaceAll(RegExp(r'\.|:|-| '), "");
}

String stringToTime(String createdAt) {
  String year = createdAt.substring(0, 4);
  String month = createdAt.substring(4, 6);
  String date = createdAt.substring(6, 8);
  String hours = createdAt.substring(8, 10);
  String min = createdAt.substring(10, 12);
  return "$year-$month-$date $hours:$min";
}
