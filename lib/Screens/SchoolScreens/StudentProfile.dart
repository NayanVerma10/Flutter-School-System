import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Icons/iconss_icons.dart';

class StudentProfile extends StatefulWidget {
  final String schoolCode;
  final String studentId;
  StudentProfile({this.schoolCode, this.studentId});
  @override
  _StudentProfileState createState() =>
      _StudentProfileState(schoolCode, studentId);
}

class _StudentProfileState extends State<StudentProfile> {
  String schoolCode;
  String studentId;
  _StudentProfileState(this.schoolCode, this.studentId);

  Widget _buildList(BuildContext context,String key, value) {
    if (value.runtimeType == String)
      return ListTile(
        title: Text(key.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,)),
        subtitle: Text(value),
        onTap: () {
          _showDialog(context, key, value);
        },
      );
    else /*if (value.runtimeType == List) */{
      return ListTile(
        title: Text(key.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,)),
        subtitle: Text(value.toString()),
      );
    }
  }

  _showDialog(BuildContext context, String key, String value) async {
    String newValue;
    await showDialog<String>(
      context: context,
      child: new _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,),
                      labelText: key.toUpperCase(), hintText: 'eg. '+value),
                  onChanged: (value) {
                    newValue = value;
                  },
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('Save'),
                onPressed: () async {
                  Firestore.instance
                      .collection('School')
                      .document(schoolCode)
                      .collection('Student')
                      .document(studentId)
                      .setData({key: newValue}, merge: true);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Student'),
        ),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('School')
              .document(schoolCode)
              .collection('Student')
              .document(studentId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            DocumentSnapshot document = snapshot.data;
            Map<String, dynamic> studentData = document.data;
            var keys = studentData.keys.toList();

            return Container(
              margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                children: <Widget>[
                  Icon(
                    Iconss.user_graduate,
                    size: 100,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemExtent: 80.0,
                      itemCount: keys.length,
                      itemBuilder: (context, index) {
                        return _buildList(
                            context, keys[index], studentData[keys[index]]);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets/200,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
