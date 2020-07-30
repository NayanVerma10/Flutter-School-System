import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SchoolRegistration.dart';
import 'SchoolScreens/main.dart';
import 'service.dart';
import './Policies.dart';

class SchoolLogin extends StatefulWidget {
  @override
  _SchoolLoginState createState() => _SchoolLoginState();
}

class _SchoolLoginState extends State<SchoolLogin> {
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
        await logTheUserIn(context);
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
          'Email ID does not exist in the database',
        )));
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> logTheUserIn(BuildContext context) async {
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
      'Logged in',
    )));
    print(schoolCode);
    service(schoolCode);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('schoolCode', schoolCode);
    await prefs.setString('type', 'School');

    main(schoolCode);
    verified = false;
  }

  Future<bool> verifyGoogleMail() async {
    await Firestore.instance
        .collection('School')
        .where('schoolemail', isEqualTo: givenemailmobile)
        .getDocuments()
        .then((value) {
      if (value.documents.isNotEmpty) {
        verified = true;
        schoolCode = value.documents[0].documentID;
      }
    });
    return true;
  }

  Future<bool> verifyemail() async {
    await Firestore.instance
        .collection('School')
        .where('schoolemail', isEqualTo: givenemailmobile.toLowerCase())
        .getDocuments()
        .then((value) => {
              value.documents.forEach((element) {
                if (element["password"] == givenpassword) {
                  verified = true;
                  schoolCode = element.documentID;
                }
              })
            });
    return true;
  }

  Future<bool> verifyphone() async {
    await Firestore.instance
        .collection('School')
        .where('schoolno', isEqualTo: givenemailmobile)
        .getDocuments()
        .then((value) => {
              value.documents.forEach((element) {
                if (element["password"] == givenpassword) {
                  verified = true;
                  schoolCode = element.documentID;
                }
              })
            });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('School Login'),
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
                                logTheUserIn(context);
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
                                          SchoolRegistration()));
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style.merge(TextStyle(fontSize: 12,fontWeight: FontWeight.bold,decoration: TextDecoration.underline)),
                              text: 'Policies',
                              recognizer: TapGestureRecognizer()..onTap= () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Policies()));
                              }
                            ),
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
