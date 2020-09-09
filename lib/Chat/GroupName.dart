import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'CreateGroupUsersList.dart';
import 'dart:io';
import 'dart:async';
import 'ChatList.dart';

class GroupName extends StatefulWidget {
  String schoolCode;
  List<User> list = List<User>();
  String userId;
  bool isTeacher;
  GroupName(
    this.schoolCode,
    this.list,
    this.userId,
    this.isTeacher,
  );

  @override
  _GroupNameState createState() => _GroupNameState();
}

class _GroupNameState extends State<GroupName> {
  String name = "", description = "";
  PickedFile _pickedFile;

  File _image;
  final picker = ImagePicker();
  File _selectedFile;
  bool _inProcess = false;
  Uint8List bytesList;
  Image webImage;

  Future getImageFromGallery() async {
    this.setState(() {
      _inProcess = true;
    });
      _pickedFile = await picker.getImage(source: ImageSource.gallery);
      print(_pickedFile.path);
      Image webImage1 = Image.network(_pickedFile.path);
      print(webImage1.image.toString());
      Uint8List bytesList1 = await _pickedFile.readAsBytes();
      setState(() {
        bytesList = bytesList1;
        webImage = Image.memory(bytesList);
      });
    // } else {
    //   _pickedFile = await picker.getImage(source: ImageSource.gallery);
    //   if (_pickedFile != null) {
    //     setState(() {
    //       _image = File(_pickedFile.path);
    //       _selectedFile = _image;
    //       _inProcess = false;
    //     });
    //   } else {
    //     this.setState(() {
    //       _inProcess = false;
    //     });
    //   }
    //}
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
                  Navigator.pop(this.context);
                }),
            FlatButton(
                child: Text(
                  'Remove Image',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: _selectedFile == null
                    ? null
                    : () {
                        setState(() {
                          _selectedFile = null;
                          Navigator.pop(this.context);
                        });
                      }),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create a group"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Stack(fit: StackFit.loose, children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 140.0,
                        height: 140.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: _selectedFile != null
                                    ? Image.file(_selectedFile).image
                                    : (kIsWeb && webImage != null
                                        ? webImage.image
                                        : ExactAssetImage(
                                            'assets/images/coverimage.jpg')),
                                fit: BoxFit.cover)),
                      )
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 90.0, right: 100.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.grey[800],
                            radius: 25.0,
                            child: IconButton(
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
                              },
                              color: Colors.white,
                            ),
                          )
                        ],
                      )),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          labelText: "Group name",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          description = value;
                        });
                      },
                      maxLines: 4,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          labelText: "Group Description",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: name != "" && description != ""
                    ? () async {
                        showDialog(
                          context: this.context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            content: Row(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Please wait....")
                              ],
                            ),
                          ),
                        );
                        DocumentReference docRef;
                        if (bytesList!=null) {
                          
                            docRef = await Firestore.instance
                                .collection("School")
                                .document(widget.schoolCode)
                                .collection("GroupChats")
                                .add({
                              "Description": description,
                              "Name": name,
                              "Icon": List<int>.unmodifiable(bytesList),
                            });
                          } else {
                            docRef = await Firestore.instance
                                .collection("School")
                                .document(widget.schoolCode)
                                .collection("GroupChats")
                                .add({
                              "Description": description,
                              "Name": name,
                              "Icon": null,
                            });
                          }
                        if (docRef != null) {
                          CollectionReference teachersRef = Firestore.instance
                              .collection("School")
                              .document(widget.schoolCode)
                              .collection("Teachers");
                          CollectionReference studentsRef = Firestore.instance
                              .collection("School")
                              .document(widget.schoolCode)
                              .collection("Student");
                          widget.list.forEach((element) async {
                            if (element.id.compareTo(widget.userId)==0 &&
                                element.isTeacher == widget.isTeacher) {
                              element.isAdmin = true;
                            } else {
                              element.isAdmin = false;
                            }
                            await docRef
                                .collection("Members")
                                .document(element.id +
                                    "_" +
                                    (element.isTeacher ? "true" : "false"))
                                .setData(element.toMap());
                            if (element.isTeacher != null &&
                                element.isTeacher) {
                              await teachersRef
                                  .document(element.id)
                                  .collection("GroupsJoined")
                                  .document(docRef.documentID)
                                  .setData({});
                            } else {
                              await studentsRef
                                  .document(element.id)
                                  .collection("GroupsJoined")
                                  .document(docRef.documentID)
                                  .setData({});
                            }
                            await docRef
                                .collection('ChatMessages')
                                .document(timeToString())
                                .setData({});
                          });
                        }
                        Navigator.pop(context);
                        Navigator.pop(context, [
                          docRef,
                          widget.schoolCode,
                          widget.userId,
                          widget.isTeacher
                        ]);
                      }
                    : null,
                child: Text(
                  "Done",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
              ),
            ],
          ),
        ));
  }
}
