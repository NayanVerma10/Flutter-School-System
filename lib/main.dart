import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Screens/SchoolScreens/main.dart';
import './Screens/StudentScreens/main.dart';
import './Screens/TeacherScreens/main.dart';

import './Screens/InitialScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('type') == 'School')
    runApp(MyAppSchool(prefs.getString('schoolCode')));
  else if (prefs.getString('type') == 'Student')
    runApp(MyAppStudent(prefs.getString('schoolCode'),prefs.getString('studentId')));
  else if (prefs.getString('type') == 'Teacher')
    runApp(MyAppTeacher(prefs.getString('schoolCode'),prefs.getString('teachersId')));
  else
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        cursorColor: Colors.black,
        textSelectionHandleColor: Colors.black,
        
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InitialScreen(),
    );
  }
}
