import 'package:Schools/widgets/passwordTF.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentRegistration extends StatefulWidget {
  @override
  _StudentRegistrationState createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {
  final _formKey = GlobalKey<FormState>();

  String givenemailmobile;
  String givenpassword;
  String givenConfirmPassword;
  String schoolCode;
  String studentId;
  bool passwordDoesNotExists = false;
  bool verified = false;
  bool verifiedSchoolcode = false;
  TextEditingController controller1, controller2;
  PasswordTF ptf1, ptf2;

  @override
  void initState() {
    super.initState();
    controller1 = TextEditingController(text: "");
    controller2 = TextEditingController(text: "");
    ptf1 = PasswordTF(controller1);
    ptf2 = PasswordTF(controller2, hintText: "Confirm Password");
  }

  Future<bool> setData() async {
    await FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection('Student')
        .doc(studentId)
        .set({'password': givenpassword}, SetOptions(merge: true));
    return true;
  }

  Future<bool> verifySchoolCode() async {
    await FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .get()
        .then((value) => {if (value.exists) verifiedSchoolcode = true});
    return true;
  }

  Future<bool> verifyPasswordExists() async {
    await FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection('Student')
        .doc(studentId)
        .get()
        .then((value) => {
              if (!(value.data().containsKey('password')))
                passwordDoesNotExists = true
            });
    return true;
  }

  Future<bool> verifyemail() async {
    await FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection('Student')
        .where('email', isEqualTo: givenemailmobile)
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                verified = true;
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
                verified = true;
                studentId = element.id;
              })
            });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Registration'),
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
                      ptf1,
                      SizedBox(
                        height: 30,
                      ),
                      ptf2,
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
                              setState(() {
                                givenpassword = controller1.text;
                                givenConfirmPassword = controller2.text;
                              });
                              await verifySchoolCode();
                              await verifyemail();
                              await verifyphone();
                              if (verifiedSchoolcode && verified)
                                await verifyPasswordExists();

                              if (verified &&
                                  verifiedSchoolcode &&
                                  passwordDoesNotExists &&
                                  givenConfirmPassword == givenpassword) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                  'Registering...',
                                )));
                                print(studentId);
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
                              studentId = null;
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
