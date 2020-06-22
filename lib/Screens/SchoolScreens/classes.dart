import 'package:Schools/Screens/SchoolScreens/StudentProfile.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import '../Icons/iconss_icons.dart';

// import 'package:fab_circular_menu/fab_circular_menu.dart';

class User {
  String id;
  String name;
  String email;
  String studentsClass;
  String studnetsSection;

  User(
      {this.id,
      this.name,
      this.email,
      this.studentsClass,
      this.studnetsSection});
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

class Studnets extends StatefulWidget {
  final String schoolCode;
  Studnets(this.schoolCode);
  @override
  _StudnetsState createState() => _StudnetsState(schoolCode);
}

class _StudnetsState extends State<Studnets> {
  String schoolCode;
  final _debouncer = Debouncer(milliseconds: 500);
  List<User> users = List();
  List<User> filteredUsers = List();

  _StudnetsState(this.schoolCode);

  void loadData(){
    Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Student')
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              users.add(User(
                email: element.data['email'],
                id: element.documentID,
                name: element.data['first name'] +
                    ' ' +
                    element.data['last name'],
                studentsClass: element.data['class'],
                studnetsSection: element.data['section'],
              ));
            }))
        .then((value) {
      setState(() {
        filteredUsers = users;
      });
    });
  }
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if(users.isNotEmpty)
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(15.0),
              hintText: 'Filter by name or email',
            ),
            onChanged: (string) {
              _debouncer.run(() {
                setState(() {
                  filteredUsers = users
                      .where((u) => (u.name
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          u.email
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          u.id.toLowerCase().contains(string.toLowerCase()) ||
                          u.studentsClass
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          u.studnetsSection
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                      .toList();
                });
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: filteredUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  elevation: 0,
                  child: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: ListTile(
                        leading: Icon(
                          Iconss.user_graduate,
                          color: Colors.black,
                        ),
                        title: Text(
                          filteredUsers[index].name.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(filteredUsers[index].email +
                            '\n' +
                            filteredUsers[index].id),
                        isThreeLine: true,
                        trailing: Text(filteredUsers[index].studentsClass +
                            ' - ' +
                            filteredUsers[index].studnetsSection +
                            ' \t'),
                        dense: false,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentProfile(
                                        schoolCode: schoolCode,
                                        studentId: filteredUsers[index].id,
                                      )));
                        },
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
    else
    return Center(widthFactor: 100, child: CircularProgressIndicator());
  }
}
