import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'StudentRegistration.dart';
import './StudentScreens/main.dart';

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
        print(studentId);
        main(schoolCode, studentId);
        verified = false;
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

  Future<bool> verifyGoogleMail() async {
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Student')
        .where('email', isEqualTo: givenemailmobile)
        .getDocuments()
        .then((value) {
      if (value.documents.isNotEmpty) {
        verified = true;
        studentId = value.documents[0].documentID;
      }
    });
    return true;
  }

  Future<bool> verifyemail() async {
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Student')
        .where('email', isEqualTo: givenemailmobile.toLowerCase())
        .getDocuments()
        .then((value) => {
              value.documents.forEach((element) {
                if (element["password"] == givenpassword) verified = true;
                studentId = element.documentID;
              })
            });
    return true;
  }

  Future<bool> verifyphone() async {
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Student')
        .where('mobile', isEqualTo: givenemailmobile)
        .getDocuments()
        .then((value) => {
              value.documents.forEach((element) {
                if (element["password"] == givenpassword) verified = true;
                studentId = element.documentID;
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
                      TextFormField(
                        onChanged: (string) => {givenpassword = string},
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          hintText: 'Password',
                        ),
                        obscureText: true,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          color: Colors.black,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await verifyemail();
                              await verifyphone();
                              print(verified);
                              if (verified) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                  'Logged in',
                                )));
                                print(studentId);
                                main(schoolCode, studentId);
                                verified = false;
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
                            'New to our app ',
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
                                  fontSize: 12,
                                  decoration: TextDecoration.underline),
                            ),
                          )
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
                      SizedBox(height: 100),
                      Center(
                        child: RaisedButton.icon(
                          onPressed: () {
                            loginWithGoole(context);
                          },
                          icon: Icon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                          ),
                          label: Text('Sign in with Google'),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
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
