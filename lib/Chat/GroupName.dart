import 'dart:typed_data';

import 'package:Schools/widgets/AlertDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'CreateGroupUsersList.dart';
import 'dart:async';
import 'ChatList.dart';
import '../plugins/url_launcher/url_launcher.dart';
import 'GroupChatBox.dart';

class GroupName extends StatefulWidget {
  String schoolCode;
  List<dynamic> list = List<dynamic>();
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
  List<String> allowedExt;
  Image image;
  Uint8List bytesData;
  FilePickerResult result;
  @override
  void initState() {
    super.initState();
    allowedExt = [
      'xbm',
      'tif',
      'pjp',
      'svg',
      'jpg',
      'jpeg',
      'ico',
      'tiff',
      'gif',
      'svgz',
      'jfif',
      'webp',
      'png',
      'bmp',
      'pjpeg',
      'avif'
    ];
  }

  Future getImageFromGallery() async {
    result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);
    if (result != null) {
      if (allowedExt.contains(result.files.first.extension)) {
        Uint8List bytesData1 = result.files.first.bytes;
        setState(() {
          bytesData = bytesData1;
          image = Image.memory(bytesData);
        });
      }
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
                onPressed: () async {
                  await getImageFromGallery();
                  Navigator.of(context, rootNavigator: true).pop('edit');
                }),
            FlatButton(
                child: Text(
                  'Remove Image',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: image == null
                    ? null
                    : () {
                        setState(() {
                          image = null;
                        });
                        Navigator.of(context, rootNavigator: true).pop('edit');
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
                                image: image != null
                                    ? image.image
                                    : ExactAssetImage(
                                        'assets/images/coverimage.jpg'),
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
                                    useRootNavigator: true,
                                    routeSettings: RouteSettings(name: 'edit'),
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
                        showLoaderDialog(context, "Please wait....");
                        DocumentReference docRef = await Firestore.instance
                            .collection("School")
                            .document(widget.schoolCode)
                            .collection("GroupChats")
                            .add({
                          "Description": description,
                          "Name": name,
                          'AdminCount': 1,
                        });
                        if (bytesData != null) {
                          await UrlUtils.open(result,
                              "${widget.schoolCode}/GroupChats/${docRef.documentID}/icon/", context,
                              docRef: docRef, );
                        } else {
                          await docRef.updateData({"Icon": null});
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
                            if (element.id == widget.userId &&
                                element.isTeacher == widget.isTeacher) {
                              element.isAdmin = true;
                              await docRef
                                  .collection('ChatMessages')
                                  .document(timeToString())
                                  .setData({
                                'type': 'notification',
                                'text':
                                    '${element.name} created this group and added ${widget.list.length - 1} members'
                              });
                            } else {
                              element.isAdmin = false;
                            }
                            await docRef
                                .collection("Members")
                                .document(element.id +
                                    "_" +
                                    (element.isTeacher ? "true" : "false"))
                                .setData(element.toMap());
                            if (element.isTeacher) {
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
                          });
                        }

                        Navigator.of(context, rootNavigator: true).pop('loading');
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
