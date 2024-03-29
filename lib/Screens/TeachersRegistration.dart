import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeachersRegistration extends StatefulWidget {
  @override
  _TeachersRegistrationState createState() => _TeachersRegistrationState();
}

class _TeachersRegistrationState extends State<TeachersRegistration> {
  final _formKey = GlobalKey<FormState>();

  String givenemailmobile;
  String givenpassword;
  String givenConfirmPassword;
  String schoolCode;
  String teachersId;
  bool passwordDoesNotExists = false;
  bool verified = false;
  bool verifiedSchoolcode = false;

  Future<bool> setData() async {
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Teachers')
        .document(teachersId)
        .setData({'password': givenpassword}, merge: true);
    return true;
  }

  Future<bool> verifySchoolCode() async {
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .get()
        .then((value) => {if (value.exists) verifiedSchoolcode = true});
    return true;
  }

  Future<bool> verifyPasswordExists() async {
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Teachers')
        .document(teachersId)
        .get()
        .then((value) => {
              if (!(value.data.containsKey('password')))
                passwordDoesNotExists = true
            });
    return true;
  }

  Future<bool> verifyemail() async {
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Teachers')
        .where('email', isEqualTo: givenemailmobile)
        .getDocuments()
        .then((value) => {
              value.documents.forEach((element) {
                verified = true;
                teachersId = element.documentID;
              })
            });
    return true;
  }

  Future<bool> verifyphone() async {
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Teachers')
        .where('mobile', isEqualTo: givenemailmobile)
        .getDocuments()
        .then((value) => {
              value.documents.forEach((element) {
                verified = true;
                teachersId = element.documentID;
              })
            });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Registration'),
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
                        height: 30,
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
                      TextFormField(
                        onChanged: (string) => {givenConfirmPassword = string},
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          hintText: 'Confirm Password',
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
                              await verifySchoolCode();
                              await verifyemail();
                              await verifyphone();
                              if(verifiedSchoolcode && verified)
                                await verifyPasswordExists();

                              if (verified &&
                                  verifiedSchoolcode &&
                                  passwordDoesNotExists &&
                                  givenConfirmPassword == givenpassword) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                  'Registering...',
                                )));
                                print(teachersId);
                                await setData();
                                Navigator.pop(context);
                              } else if (!verifiedSchoolcode) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('School Code Doesn\'t Exists'),
                                ));
                              } else if (!verified) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Could Not find the specified Email / Mobile Number '),
                                ));
                              } else if (!passwordDoesNotExists) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Already Registered'),
                                ));
                              } else {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Passwords don\'t match'),
                                ));
                              }
                              verified = false;
                              verifiedSchoolcode = false;
                              teachersId = null;
                              passwordDoesNotExists = false;
                            }
                          },
                          child: Text('Submit'),
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
