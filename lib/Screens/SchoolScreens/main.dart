import 'package:flutter/material.dart';
import 'academics.dart';
import 'classes.dart';
import 'management.dart';
import 'profile.dart';
import 'staff.dart';
import '../Icons/iconss_icons.dart';
import '../Icons/iconsss_icons.dart';

void main(String schoolCode) {
  runApp(MyApp(schoolCode));
}

class MyApp extends StatefulWidget {

  String schoolCode;

  MyApp(this.schoolCode);

   @override
  _MyAppState createState() => _MyAppState(schoolCode);
}
class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  String schoolCode;
  _MyAppState(this.schoolCode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SCHOOL NAME',
      // theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,      // Number of Tabs you want
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            bottom: TabBar(
              isScrollable: true,
              tabs: [   // Headings of each tab
                Tab(icon: Icon(Iconsss.book_reader, size: 20),text: 'CLASSES'),
                 Column(
                  children: <Widget>[
                  Container(
                    height: 20,
                    width: 30,
                  child: Icon(Iconsss.user_cog, size: 20),
                  ),
                  SizedBox(height: 10,),
                  Text('MANAGEMENT'),
                  
                  ]
                  ),
                Column(
                  children: <Widget>[
                  Icon(Iconsss.book, size: 20),
                  SizedBox(height: 10,),
                  Text('ACADEMICS')
                  ]
                  ),
                  Column(
                  children: <Widget>[
                  Icon(Iconss.user_tie, size: 22),
                  SizedBox(height: 9),
                  Text('STAFF')
                  ]
                  ),
                // Tab(icon: Icon(Iconss.user_tie),text: 'STAFF',),
                // Tab(icon: Icon(Icons.person, size: 30,),text: 'PROFILE',)
                Column(
                  children: <Widget>[
                    Container(
                      height: 33,
                  child: Icon(Icons.person, size: 33),
                    ),
                   SizedBox(height: 6),
                  Text('PROFILE'),
                  SizedBox(height: 8),
                  ]
                  ),
              ],
            ),
            title: Text('SCHOOL NAME', style: TextStyle(fontSize: 20),),
          ),
          body: TabBarView(
            children: [   //What each tab will contain
             Classes(schoolCode),
             Management(),
             Academics(),
             Staff(),
             Profile()
              
            ],
          ),
        ),
      ),
    );
  }
}

