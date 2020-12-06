import 'package:Schools/widgets/notificationsinit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache/flutter_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Screens/SchoolScreens/main.dart';
import './Screens/StudentScreens/main.dart';
import './Screens/TeacherScreens/main.dart';

import './Screens/InitialScreen.dart';

String ver = "0";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  FirebaseApp app = await Firebase.initializeApp();

  ver = "0";
  if (prefs.getString("version") != null &&
      prefs.getString("version").length > 0) {
    ver = prefs.getString('version');
  }
  String latest = (await FirebaseFirestore.instance.collection('Version').get())
      .docs
      .last
      .id;
  print(latest);
  if (latest.compareTo(ver) != 0 && ver.compareTo('0') != 0) {
    Cache.clear();
    print(await prefs.setString('version', latest));
  } else {
    print(await prefs.setString('version', latest));
  }
  notificationsInit();
  if (prefs.getString('type') == 'School')
    runApp(MyAppSchool(prefs.getString('schoolCode')));
  else if (prefs.getString('type') == 'Student')
    runApp(MyAppStudent(
        prefs.getString('schoolCode'), prefs.getString('studentId')));
  else if (prefs.getString('type') == 'Teacher')
    runApp(MyAppTeacher(
        prefs.getString('schoolCode'), prefs.getString('teachersId')));
  else
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // darkTheme: ThemeData.dark(),
      title: 'Aatmanirbhar Institutions',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.white,
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.black, selectionHandleColor: Colors.black),

        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InitialScreen(),
    );
  }
}
