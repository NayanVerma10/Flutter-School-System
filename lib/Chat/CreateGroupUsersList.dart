import 'dart:async';

import 'package:Schools/Chat/GroupChatBox.dart';
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
  bool isTeacher, value;
  List<User> alreadyAdded;
  _CreateGroupState(this.schoolCode, this.userId, this.isTeacher,
      {this.alreadyAdded});
  Debouncer _debouncer = new Debouncer(milliseconds: 500);
  List<User> users = List();
  List<User> filteredUsers = List();
  bool loading = true;
  Map<String, bool> totalUsers;
  int count = 0;
  User user;
  void loadData() async {
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Student')
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              totalUsers[element.documentID + "_false"] = false;
              User currentUser = User(
                mobile: (element.data['mobile'] ?? ''),
                id: element.documentID,
                name: (element.data['first name'] ?? '') +
                    ' ' +
                    (element.data['last name'] ?? ''),
                classNumber: element.data['class'] ?? '',
                section: element.data['section'] ?? '',
                isTeacher: false,
                imgURL: element.data['url'],
                isAdmin: false,
              );
              if (alreadyAdded == null || !alreadyAdded.contains(currentUser)) {
                users.add(currentUser);
              }
            }));

    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Teachers')
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              totalUsers[element.documentID + "_true"] = false;
              User currentUser = User(
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
                isAdmin: false,
              );
              if (alreadyAdded == null || !alreadyAdded.contains(currentUser)) {
                users.add(currentUser);
              }
            }));

    await Firestore.instance
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
              (value.data["last name"] ?? ''),
          mobile: (value.data["mobile"] ?? ''),
          classNumber: value.data['classteacher'] != null
              ? value.data['classteacher']['class']
              : (value.data['class'] ?? ''),
          section: value.data['classteacher'] != null
              ? value.data['classteacher']['section']
              : (value.data['section'] ?? ''),
          isTeacher: isTeacher,
          imgURL: value.data["url"],
          isAdmin: false,
        );
      });
    });
    users.remove(user);
    setState(() {
      filteredUsers = users;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
    totalUsers = Map();
    value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (alreadyAdded != null)
              Navigator.pop(context);
              
                // Navigator.popUntil(
                //     context, ModalRoute.withName('GroupChatBox'));
              else {
                Navigator.pop(context);
              }
            }),
        actions: [
          FlatButton(
            onPressed: count == 0
                ? null
                : () async {
                    List<User> usersList = List();
                    users.forEach((element) {
                      if (totalUsers[element.id +
                          "_" +
                          (element.isTeacher ? "true" : "false")]) {
                        usersList.add(element);
                      }
                    });
                    //print("length " + alreadyAdded.length.toString());
                    if (alreadyAdded == null || alreadyAdded.length == 0) {
                      user.isAdmin = true;
                      usersList.add(user);
                      var results = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: RouteSettings(name: 'GroupName'),
                              builder: (context) => GroupName(
                              
                                  schoolCode, usersList, userId, isTeacher)));
                      if (results != null) {
                        Navigator.pop(context, results);
                      }
                    } else {
                      Navigator.pop(context, usersList);
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
                ListTile(
                  onTap: () {
                    setState(() {
                      value = (!value);
                      filteredUsers.forEach((element) {
                        totalUsers[element.id +
                            "_" +
                            (element.isTeacher ? "true" : "false")] = value;
                      });
                      count = 0;
                      totalUsers.forEach((key, value) {
                        if (value) count++;
                      });
                    });
                  },
                  title: Text(
                    'Select All',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  leading: Checkbox(
                      value: value,
                      onChanged: (val) {
                        setState(() {
                          value = val;
                          filteredUsers.forEach((element) {
                            totalUsers[element.id +
                                "_" +
                                (element.isTeacher ? "true" : "false")] = val;
                          });
                          count = 0;
                          totalUsers.forEach((key, value) {
                            if (value) count++;
                          });
                        });
                      }),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(0),
                    itemCount: filteredUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 0),
                        elevation: 0,
                        child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  totalUsers[filteredUsers.elementAt(index).id +
                                      "_" +
                                      (filteredUsers.elementAt(index).isTeacher
                                          ? "true"
                                          : "false")] = (!totalUsers[
                                      filteredUsers.elementAt(index).id +
                                          "_" +
                                          (filteredUsers
                                                  .elementAt(index)
                                                  .isTeacher
                                              ? "true"
                                              : "false")]);
                                  if (totalUsers[filteredUsers
                                          .elementAt(index)
                                          .id +
                                      "_" +
                                      (filteredUsers.elementAt(index).isTeacher
                                          ? "true"
                                          : "false")])
                                    count++;
                                  else
                                    count--;
                                });
                              },
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                      value: totalUsers[
                                          filteredUsers.elementAt(index).id +
                                              "_" +
                                              (filteredUsers
                                                      .elementAt(index)
                                                      .isTeacher
                                                  ? "true"
                                                  : "false")],
                                      onChanged: (value) {
                                        setState(() {
                                          totalUsers[filteredUsers
                                                  .elementAt(index)
                                                  .id +
                                              "_" +
                                              (filteredUsers
                                                      .elementAt(index)
                                                      .isTeacher
                                                  ? "true"
                                                  : "false")] = value;
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
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      thickness: 1,
                      indent: 70,
                      color: Colors.black12,
                    ),
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
