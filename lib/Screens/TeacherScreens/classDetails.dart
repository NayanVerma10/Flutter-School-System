import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import './studentsGrid.dart';
import './assignment.dart';
import './attendance.dart';
import './behavior.dart';
import '../Icons/iconssss_icons.dart';
import '../Icons/my_flutter_app_icons.dart';
import './students.dart';
import './tutorials.dart';
import '../Icons/iconsss_icons.dart';
import './Discussions.dart';
import './VideoChat.dart';
import '../../ChatNecessary/WebJitsiMeet.dart';
import 'database.dart';

class ClassDetails extends StatefulWidget {
  final String className, schoolCode, teachersId, classNumber, section, subject;
  ClassDetails(
      {Key key,
      this.className,
      this.schoolCode,
      this.teachersId,
      this.classNumber,
      this.section,
      this.subject})
      : super(key: key);
  @override
  _ClassDetailsState createState() => _ClassDetailsState(
      className, schoolCode, teachersId, classNumber, section, subject);
}

class _ClassDetailsState extends State<ClassDetails> {
  final String className, schoolCode, teachersId, classNumber, section, subject;
  _ClassDetailsState(this.className, this.schoolCode, this.teachersId,
      this.classNumber, this.section, this.subject);
  int _currentIndex = 0;
  int v = 0;

  void videoChat() {
    if (!kIsWeb)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyApp(
                    schoolCode: schoolCode,
                    className: className,
                    classNumber: classNumber,
                    section: section,
                    subject: subject,
                    teachersId: teachersId,
                  )));
    else
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebJitsiMeet(
                  schoolCode +
                      '-' +
                      classNumber +
                      '-' +
                      section +
                      '-' +
                      subject,
                  className)));
  }

  @override
  Widget build(BuildContext context) {
    var tabs = [
      v == 0
          ? StudentsList(
              className, schoolCode, teachersId, classNumber, section, subject)
          : StudentsGrid(
              className, schoolCode, teachersId, classNumber, section, subject),
      TutorialUpload(),
      Home(),

      Attendance(
          className, schoolCode, teachersId, classNumber, section, subject)
    ];

    db.subject=subject;
    db.schoolCode=schoolCode;
    db.classNumber=classNumber;
    db.section=section;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            className,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: _currentIndex == 0
              ? <Widget>[
                  IconButton(
                      icon: Icon(Iconssss.list,
                          size: 20,
                          //color: Colors.white,

                          color: v == 0 ? Colors.white : Colors.grey),
                      onPressed: () {
                        setState(() {
                          v = 0;
                        });
                      }),
                  IconButton(
                      icon: Icon(Iconssss.th_thumb,
                          // color: Colors.white,
                          size: 20,
                          color: v == 1 ? Colors.white : Colors.grey),
                      onPressed: () {
                        setState(() {
                          v = 1;
                        });
                      }),
                  FlatButton.icon(
                    label: Text('Join Class'),
                    icon: Icon(
                      Icons.videocam,
                      color: Colors.white,
                    ),
                    onPressed: videoChat,
                    textColor: Colors.white,
                  ),
                ]
              : <Widget>[
                  FlatButton.icon(
                    label: Text('Join Class'),
                    icon: Icon(
                      Icons.videocam,
                      color: Colors.white,
                    ),
                    onPressed: videoChat,
                    textColor: Colors.white,
                  ),
                ],
        ),
        body: tabs[_currentIndex],
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.chat,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Discussions(
                        className: className,
                        schoolCode: schoolCode,
                        teachersId: teachersId,
                        classNumber: classNumber,
                        section: section,
                        subject: subject)));
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.black,
          selectedFontSize: 15,
          unselectedFontSize: 13,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed, //static bar
          iconSize: 20, //iconsze
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(
                Iconsss.book_reader,
                size: 17,
              ),
              title: Container(
                margin: EdgeInsets.only(top: 2),
                child: Text(
                  'Students',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //backgroundColor: Colors.grey
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Container(
                  margin: EdgeInsets.only(top: 3),
                  child: Icon(
                    Iconsss.book,
                    size: 18,
                  )),
              title: Container(
                  margin: EdgeInsets.only(top: 2),
                  child: Text(
                    'Tutorials',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              //backgroundColor: Colors.grey
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(
                Icons.assignment,
                size: 22,
              ),
              title: Text(
                'Assignments',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              //backgroundColor: Colors.grey
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Container(
                  padding: EdgeInsets.all(0),
                  height: 20,
                  width: 30,
                  child: Icon(
                    Iconssss.user_check,
                    size: 17,
                  )),
              title: Text(
                'Attendance',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              //backgroundColor: Colors.grey
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ));
  }
}