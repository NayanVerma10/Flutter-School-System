import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'SchoolRegistration.dart';
import 'SchoolScreens/main.dart';
import 'service.dart';

class SchoolLogin extends StatefulWidget {
  @override
  _SchoolLoginState createState() => _SchoolLoginState();
}

class _SchoolLoginState extends State<SchoolLogin> {
  final _formKey = GlobalKey<FormState>();

  String givenemailmobile;
  String givenpassword;
  String schoolCode;
  bool verified = false;

  Future<bool> verifyemail() async {
    await Firestore.instance
        .collection('School')
        .where('schoolemail', isEqualTo: givenemailmobile.toLowerCase())
        .getDocuments()
        .then((value) => {
              value.documents.forEach((element) {
                if (element["password"] == givenpassword) verified = true;
                schoolCode=element.documentID;
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
                if (element["password"] == givenpassword) verified = true;
                schoolCode=element.documentID;
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
        builder: (context) => Container(
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
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                'Logged in',
                              )));
                              print(schoolCode);
                              main(schoolCode);
                              service(schoolCode);
                              //Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolRegistration()));
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
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolRegistration()));},
                          child: Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
