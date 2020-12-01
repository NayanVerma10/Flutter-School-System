import 'package:Schools/widgets/passwordTF.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'StudentRegistration.dart';
import './StudentScreens/main.dart';
import './Policies.dart';

class StudentLogin extends StatefulWidget {
  @override
  _StudentLoginState createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  final _formKey = GlobalKey<FormState>();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  GoogleSignInAccount googleUser;

  String givenemailmobile;
  String givenpassword;
  String schoolCode;
  String studentId;
  bool verified = false;
  TextEditingController controller;
  PasswordTF passwordTF;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: "");
    passwordTF = PasswordTF(controller);
  }

  loginWithGoole(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      googleUser = await _googleSignIn.signIn();
      print('signed in');
      print(googleUser.email);
      givenemailmobile = googleUser.email;
      await verifyGoogleMail();
      print(verified);
      print(schoolCode);
      await _googleSignIn.signOut();

      if (verified) {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
          'Logged in',
        )));
        logInTheUser();
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Icon(
            Icons.error,
            semanticLabel: 'Wrong Credentials',
            size: 30,
          ),
        ));
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> logInTheUser() async {
    print(studentId);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('schoolCode', schoolCode);
    await prefs.setString('type', 'Student');
    await prefs.setString('studentId', studentId);

    main(schoolCode, studentId);
    verified = false;
  }

  Future<bool> verifyGoogleMail() async {
    await FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection('Student')
        .where('email', isEqualTo: givenemailmobile)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        verified = true;
        studentId = value.docs[0].id;
      }
    });
    return true;
  }

  Future<bool> verifyemail() async {
    await FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection('Student')
        .where('email', isEqualTo: givenemailmobile.toLowerCase())
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                if (element["password"] == givenpassword) verified = true;
                studentId = element.id;
              })
            });
    return true;
  }

  Future<bool> verifyphone() async {
    await FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection('Student')
        .where('mobile', isEqualTo: givenemailmobile)
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                if (element["password"] == givenpassword) verified = true;
                studentId = element.id;
              })
            });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Login'),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 70, vertical: 50),
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        onChanged: (string) => {schoolCode = string},
                        decoration: InputDecoration(
                            hintText: 'School Code',
                            prefixIcon: Icon(
                              Icons.school,
                              color: Colors.black,
                            )),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      TextFormField(
                        onChanged: (string) => {givenemailmobile = string},
                        decoration: InputDecoration(
                            hintText: 'Email / Mobile Number',
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                            )),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      passwordTF,
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          color: Colors.black,
                          textColor: Colors.white,
                          onPressed: () async {
                            setState(() {
                              givenpassword = controller.text;
                            });
                            if (_formKey.currentState.validate()) {
                              await verifyemail();
                              await verifyphone();
                              print(verified);
                              if (verified) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                  'Logged in',
                                )));
                                logInTheUser();
                              } else {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Icon(
                                    Icons.error,
                                    semanticLabel: 'Wrong Credentials',
                                    size: 30,
                                  ),
                                ));
                              }
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'New User',
                            style: TextStyle(fontSize: 12),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StudentRegistration()));
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  fontSize: 14,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                                style: DefaultTextStyle.of(context).style.merge(
                                    TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline)),
                                text: 'Policies',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Policies()));
                                  }),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Row(children: <Widget>[
                        Expanded(child: Divider(thickness: 2)),
                        SizedBox(width: 5),
                        Text("OR"),
                        SizedBox(width: 5),
                        Expanded(child: Divider(thickness: 2)),
                      ]),
                      SizedBox(height: 70),
                      Center(
                        child: RaisedButton.icon(
                          onPressed: () {
                            loginWithGoole(context);
                          },
                          icon: Icon(
                            FontAwesomeIcons.google,
                          ),
                          label: Text('Sign in with Google'),
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
