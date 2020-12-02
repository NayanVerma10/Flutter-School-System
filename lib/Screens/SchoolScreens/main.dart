import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'academics.dart';
import 'classes.dart';
import 'management.dart';
import 'profile.dart';
import 'staff.dart';
import 'addemployee.dart';
import 'addteacher.dart';
import 'addstd.dart';
import '../LogoutTheUser.dart';

import '../Icons/iconss_icons.dart';
import '../Icons/iconsss_icons.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:Schools/widgets/add_event.dart';
import 'package:Schools/widgets/add_announcements.dart';

void main(String schoolCode) {
  runApp(MyAppSchool(schoolCode));
}

class MyAppSchool extends StatefulWidget {
  final String schoolCode;

  MyAppSchool(this.schoolCode);

  @override
  _MyAppSchoolState createState() => _MyAppSchoolState(schoolCode);
}

class _MyAppSchoolState extends State<MyAppSchool> {
  // This widget is the root of your application.
  String schoolCode;
  String schoolName='';
  _MyAppSchoolState(this.schoolCode);
  
  Future<void> loadData() async{
    return FirebaseFirestore.instance.collection('School').doc(schoolCode).get().then((doc) {
      setState(() {
        schoolName = doc.data()['schoolname'];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "add_event": (_) => AddEventPage(),
        "add_announcement": (_) => AddAnnouncementPage(),
      },
      title: 'Aatmanirbhar Institutions',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black, 
          selectionHandleColor: Colors.black
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5, // Number of Tabs you want
        child: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  // Headings of each tab
                  Tab(
                      icon: Icon(Iconsss.book_reader, size: 20),
                      text: 'STUDENTS'),
                  Column(children: <Widget>[
                    Container(
                      height: 20,
                      width: 30,
                      child: Icon(Iconsss.user_cog, size: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('MANAGEMENT'),
                  ]),
                  Column(children: <Widget>[
                    Icon(Iconsss.book, size: 20),
                    SizedBox(
                      height: 10,
                    ),
                    Text('ACADEMICS')
                  ]),
                  Column(children: <Widget>[
                    Icon(Iconss.user_tie, size: 22),
                    SizedBox(height: 9),
                    Text('STAFF')
                  ]),
                  // Tab(icon: Icon(Iconss.user_tie),text: 'STAFF',),
                  // Tab(icon: Icon(Icons.person, size: 30,),text: 'PROFILE',)
                  Column(children: <Widget>[
                    Container(
                      height: 33,
                      child: Icon(Icons.person, size: 33),
                    ),
                    SizedBox(height: 6),
                    Text('PROFILE'),
                    SizedBox(height: 8),
                  ]),
                ],
              ),
              title: Text(
                schoolName,
                style: TextStyle(fontSize: 20),
              ),
              actions: <Widget>[
              //   IconButton(
              //   icon: Icon(Icons.notifications),
              //   onPressed: (){},
              // ),
                FlatButton(onPressed: (){logoutTheUser();}, child: Text('Logout',style: TextStyle(color:Theme.of(context).accentColor,))),
                
              ],
            ),
            body: TabBarView(
              children: [
                //What each tab will contain
                Studnets(schoolCode),
                Management(schoolName, schoolCode),
                Academics(),
                Staff(schoolCode),
                Profile(schoolCode)
              ],
            ),
            floatingActionButton: SpeedDial(
              // both default to 16
              marginRight: 18,
              marginBottom: 20,
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 22.0),
              // this is ignored if animatedIcon is non null
              // child: Icon(Icons.add),

              // If true user is forced to close dial manually
              // by tapping main button and overlay is not rendered.
              closeManually: false,
              curve: Curves.bounceIn,
              overlayColor: Colors.black,
              overlayOpacity: 0,
              onOpen: () => print('OPENING DIAL'),
              onClose: () => print('DIAL CLOSED'),
              tooltip: 'Menu',
              heroTag: 'menu-hero-tag',
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 8.0,
              shape: CircleBorder(),
              children: [
                SpeedDialChild(
                    child: Icon(Icons.person, size: 30, color: Colors.black),
                    backgroundColor: Colors.grey[400],
                    label: 'Add Employee',
                    labelStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEmployee(
                                  schoolCode: schoolCode,
                                )),
                      );
                    }),
                SpeedDialChild(
                    child: Icon(
                      Iconss.user_tie,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.grey[400],
                    label: 'Add Teacher',
                    labelStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTeacher(
                                  schoolCode: schoolCode,
                                )),
                      );
                    }),
                SpeedDialChild(
                  child: Icon(
                    Iconss.user_graduate,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.grey[400],
                  label: 'Add Student',
                  labelStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddStd(
                                schoolCode: schoolCode,
                              )),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
