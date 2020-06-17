import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
// import 'package:image_picker_ui/image_picker_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddTeacher extends StatefulWidget {
  final String schoolCode;
  AddTeacher({Key key, this.schoolCode}) : super(key: key);

  @override
  _AddTeacherState createState() => _AddTeacherState(schoolCode);
}
// class Item {
//   const Item(this.name);
//   final String name;

//}

class _AddTeacherState extends State<AddTeacher> {
//  _formKey and _autoValidate
  final String schoolCode;
  _AddTeacherState(this.schoolCode);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _firstname;
  String _lastname;
  String _email;
  String _mobile;
  String _dob;
  String _address;
  String _gender;
  String _desig;
  String _qual;

  // File _image;
  AnimationController _controller;
  // ImagePickerHandler imagePicker;

  final databaseReference = Firestore.instance;

  File _image;
  final picker = ImagePicker();
  File _selectedFile;
  bool _inProcess = false;

  // File _image;
  // final picker = ImagePicker();

  // Future getImageFromCam() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);

  //   setState(() {
  //     _image = File(pickedFile.path);
  //   });
  // }
  // Future getImageFromGallery() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);

  //   setState(() {
  //     _image = File(pickedFile.path);
  //   });
  // }

  // List gender=["Male","Female"];

  // String select;

//  Row addRadioButton(int btnValue, String title) {
//     return Row(
//   mainAxisAlignment: MainAxisAlignment.start,
//   children: <Widget>[
  // Radio(
  //   // activeColor: Theme.of(context).primaryColor,
  //   activeColor: Colors.black,
  //   value: gender[btnValue],
  //   groupValue: select,
  //   onChanged: (value){
  //     setState(() {
  //       print(value);
  //       _gender=value;
  //     });
  //   },
  // ),

//     Text(title,style: TextStyle(
//               fontSize: 17,
//               color: Colors.grey[600],
//              fontWeight: FontWeight.bold
//       ))
//   ],
// );
//  }

  Future getImageFromGallery() async {
    this.setState(() {
      _inProcess = true;
    });
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    _image = File(pickedFile.path);

    if (_image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: _image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.white,
            toolbarTitle: "Crop Image",
            statusBarColor: Colors.orange,
            backgroundColor: Colors.white,
          ));

      this.setState(() {
        _selectedFile = cropped;
        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  Widget editImage() {
    return Container(
        height: 100,
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FlatButton(
                child: Text('Add image',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                onPressed: () {
                  getImageFromGallery();
                }),
            FlatButton(
                child: Text(
                  'Remove Image',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: null)
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'ADD TEACHER',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.black,
            iconTheme: new IconThemeData(color: Colors.white)),
        body: SingleChildScrollView(
            child: Container(
                child: Column(
          children: <Widget>[
            SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: new Stack(fit: StackFit.loose, children: <Widget>[
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              image: _selectedFile != null
                                  ? FileImage(_selectedFile)
                                  :
                                  // Image.file(_selectedFile) :
                                  ExactAssetImage('assets/images/download.png'),
                              fit: BoxFit.cover)),
                    )
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top: 90.0, right: 100.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new CircleAvatar(
                          backgroundColor: Colors.grey[800],
                          radius: 25.0,
                          child: new IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Text(
                                          'Edit Photo',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: editImage(),
                                      ));
                              // getImageFromGallery();
                            },
                            color: Colors.white,
                          ),
                        )
                      ],
                    )),
              ]),
            ),
            //  Row(
            //    children: <Widget>[
            //     Flexible(
            //        child: Container(
            //        child: FlatButton(
            //          onPressed:null,
            //       //  onPressed: getImageFromGallery,
            //           child:  CircleAvatar(
            //           backgroundColor: Colors.grey[200],
            //          radius: 60,
            //         child:  _image==null ?  Icon(Icons.person,
            //         color: Colors.black54,
            //         size: 100,) : Image.file(_image,
            //         fit: BoxFit.cover
            //         )
            //          ),
            //          ),
            //          alignment: Alignment(0.0,-1.0),
            //            )
            //    )
            //     ]
            //      ) ,
            SizedBox(height: 10),
            Container(
                margin: new EdgeInsets.all(15.0),
                child: new Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(children: <Widget>[
                      new TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'First Name',
                            hoverColor: Colors.black,
                            focusColor: Colors.black),
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        style:
                            TextStyle(height: 1.5, fontWeight: FontWeight.bold),
                        validator: validateName,
                        onSaved: (String val) {
                          _firstname = val;
                        },
                      ),
                      new TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Last Name',
                            hoverColor: Colors.black,
                            focusColor: Colors.black),
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        style:
                            TextStyle(height: 1.5, fontWeight: FontWeight.bold),
                        validator: validateName,
                        onSaved: (String val) {
                          _lastname = val;
                        },
                      ),
                      new TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Date of birth',
                            hoverColor: Colors.black,
                            fillColor: Colors.black,
                            focusColor: Colors.black,
                            hintText: 'DD/MM/YYYY'),
                        validator: validateText,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        style:
                            TextStyle(height: 1.5, fontWeight: FontWeight.bold),
                        onSaved: (String val) {
                          _dob = val;
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Text('Gender',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      RadioButtonGroup(
                          activeColor: Colors.black,
                          orientation: GroupedButtonsOrientation.HORIZONTAL,
                          labels: [
                            "Male",
                            "Female",
                          ],
                          labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                          itemBuilder: (Radio rb, Text txt, int i) {
                            return Row(
                              children: <Widget>[
                                rb,
                                txt,
                              ],
                            );
                          },
                          // disabled: [
                          //     "Option 1"
                          //      ],
                          onChange: (String label, int index) =>
                              print("label: $label index: $index"),
                          onSelected: (String label) =>
                              {print(label), _gender = label}),

                      // Row(
                      //   children: <Widget>[
                      //   addRadioButton(0, 'Male'),
                      //    addRadioButton(1, 'Female'),
                      //       ],
                      //    ),

                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Qualification',
                            hoverColor: Colors.black,
                            fillColor: Colors.black,
                            focusColor: Colors.black),
                        //  maxLines: 4,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        style:
                            TextStyle(height: 1.5, fontWeight: FontWeight.bold),
                        validator: validateText,
                        onSaved: (String val) {
                          _qual = val;
                        },
                      ),

                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Designation',
                            hoverColor: Colors.black,
                            fillColor: Colors.black,
                            focusColor: Colors.black),
                        //  maxLines: 4,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        style:
                            TextStyle(height: 1.5, fontWeight: FontWeight.bold),
                        validator: validateText,
                        onSaved: (String val) {
                          _desig = val;
                        },
                      ),

                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Address',
                            hoverColor: Colors.black,
                            fillColor: Colors.black,
                            focusColor: Colors.black),
                        //  maxLines: 4,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        style:
                            TextStyle(height: 1.5, fontWeight: FontWeight.bold),
                        validator: validateText,
                        onSaved: (String val) {
                          _address = val;
                        },
                      ),

                      //  SizedBox(height: 30),
                      //  Align(
                      //    alignment: Alignment.centerLeft,
                      //   child: Container(

                      //     child: Text(
                      //       'PERSONAL INFORMATION',
                      //       style: TextStyle(
                      //          fontSize: 20.0,
                      //           backgroundColor: Colors.grey[200],
                      //          fontWeight: FontWeight.bold
                      //       ),

                      //     ),
                      //   )
                      //  ),
                      // Divider(
                      //   color: Colors.black54,
                      //   thickness: 2,
                      // ),
                      // SizedBox(height: 10),

                      new TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Mobile',
                            hoverColor: Colors.black,
                            focusColor: Colors.black),
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        style:
                            TextStyle(height: 1.5, fontWeight: FontWeight.bold),
                        validator: validateMobile,
                        onSaved: (String val) {
                          _mobile = val;
                        },
                      ),

                      new TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            hoverColor: Colors.black,
                            fillColor: Colors.black,
                            focusColor: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        validator: validateEmail,
                        cursorColor: Colors.black,
                        style:
                            TextStyle(height: 1.5, fontWeight: FontWeight.bold),
                        onSaved: (String val) {
                          _email = val;
                        },
                      ),

                      SizedBox(height: 30),

                      FlatButton(
                          color: Colors.black,
                          onPressed: _validateInputs,
                          child: const Text('ADD TEACHER',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)))
                    ])))
          ],
        ))));
  }

  String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
  }

  String validateText(String value) {
    if (value.length == 0)
      return 'Enter valid roll number';
    else
      return null;
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      createRecord();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Added"),
            content: new Text("The details for $_firstname have been added"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void createRecord() async {
    print(schoolCode);
    await databaseReference
        .collection("School")
        .document(schoolCode)
        .collection("Teachers")
        .document(_mobile)
        .setData({
      'first name': _firstname,
      'last name': _lastname,
      'email': _email,
      'mobile': _mobile,
      'dob': _dob,
      'address': _address,
      'gender': _gender,
      'designation': _desig,
      'qualification': _qual,
    }).whenComplete(() => print('Teacher Added'));
  }
//  @override
//   userImage(File _image) {
//     setState(() {
//       this._image = _image;
//     });
//   }
}
