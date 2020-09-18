import 'dart:typed_data';

import 'package:Schools/Chat/CreateGroupUsersList.dart';
import 'package:Schools/Chat/GroupChatBox.dart';
import 'package:Schools/Screens/StudentScreens/main.dart';
import 'package:Schools/Screens/TeacherScreens/main.dart';
import 'package:Schools/plugins/url_launcher.dart';
import 'package:Schools/widgets/AlertDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'ChatPersonProfile.dart';

class GroupDetails extends StatefulWidget {
  DocumentReference groupRef;
  String schoolCode, id, userName;
  bool isAdmin, isTeacher;
  GroupDetails(this.schoolCode, this.groupRef, this.id, this.isTeacher,
      this.isAdmin, this.userName);

  @override
  _GroupDetailsState createState() => _GroupDetailsState(groupRef);
}

class _GroupDetailsState extends State<GroupDetails> {
  TextEditingController nameController, controller;
  DocumentReference groupRef;
  int adminCount = 1;
  CollectionReference teachersRef, studentsRef;
  _GroupDetailsState(this.groupRef);
  String name, description, icon, id, iconFileName;
  List<Widget> list;
  @override
  void initState() {
    super.initState();
    id = widget.id + "_" + ((widget.isTeacher) ? "true" : "false");
    teachersRef = Firestore.instance
        .collection("School")
        .document(widget.schoolCode)
        .collection("Teachers");
    studentsRef = Firestore.instance
        .collection("School")
        .document(widget.schoolCode)
        .collection("Student");
    groupRef.get().then((value) {
      setState(() {
        icon = value.data['Icon'];
        name = value.data["Name"];
        adminCount = value.data['AdminCount'];
        iconFileName = value.data['IconFileName'];
        description = value.data["Description"];
        controller = TextEditingController(text: description);
        nameController = TextEditingController(text: name);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    settings: RouteSettings(name: 'GroupChatBox'),
                    builder: (BuildContext context) => GroupChatBox(groupRef,
                        widget.schoolCode, widget.id, widget.isTeacher)),
                (route) => false)),
        title: TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                widget.isAdmin ? Icons.edit : Icons.edit_off,
                color: widget.isAdmin ? Colors.black : Colors.black54,
                semanticLabel: 'Edit',
              ),
              tooltip: widget.isAdmin
                  ? "Change Group Name"
                  : "Only admins can change group name",
              onPressed: widget.isAdmin ? () {} : null,
            ),
          ),
          maxLines: null,
          controller: nameController,
          readOnly: !widget.isAdmin,
          onSubmitted: (value) async {
            if (value.compareTo(name) != 0 && value.length > 0) {
              showLoaderDialog(context, "Please wait....");
              await groupRef.updateData({'Name': value});
              await groupRef
                  .collection('ChatMessages')
                  .document(timeToString())
                  .setData({
                'type': 'notification',
                'text': '${widget.userName} changed group name to \'$value\''
              });
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          IconButton(
            icon: Text(
              'delete group',
              style: TextStyle(
                  color: widget.isAdmin ? Colors.black : Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
            iconSize: 50,
            onPressed: widget.isAdmin
                ? () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete this group?'),
                        titleTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                        content: Text(
                          'Are you sure want to delete this group?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              groupRef
                                  .collection('Members')
                                  .getDocuments()
                                  .then((value) {
                                value.documents.forEach((element) async {
                                  bool isT = element.data['isTeacher'];
                                  String cid = element.data['id'];
                                  if (isT) {
                                    await teachersRef
                                        .document(cid)
                                        .collection('GroupsJoined')
                                        .document(groupRef.documentID)
                                        .delete();
                                  } else {
                                    await studentsRef
                                        .document(cid)
                                        .collection('GroupsJoined')
                                        .document(groupRef.documentID)
                                        .delete();
                                  }
                                  await groupRef
                                      .collection('ChatMessages')
                                      .getDocuments()
                                      .then((value) {
                                    value.documents.forEach((element) async {
                                      await element.reference.delete();
                                    });
                                  });
                                  await groupRef
                                      .collection('Members')
                                      .getDocuments()
                                      .then((value) {
                                    value.documents.forEach((element) async {
                                      await element.reference.delete();
                                    });
                                  });
                                  await groupRef.delete();
                                  // var ref = FirebaseStorage.instance.ref().child(
                                  //     '${widget.schoolCode}/GroupChats/${groupRef.documentID}/$iconFileName');
                                  //await ref.delete();

                                  // ref.getPath().then((dir) {
                                  //   dir.items.forEach((fileRef) async {
                                  //     await fileRef.delete();
                                  //   });
                                  // }).catchError((error) {
                                  //   print(error);
                                  // });
                                });
                              });
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => widget
                                              .isTeacher
                                          ? MyAppTeacher(
                                              widget.schoolCode, widget.id)
                                          : MyAppStudent(
                                              widget.schoolCode, widget.id)),
                                  (route) => false);
                            },
                            splashColor: Colors.black12,
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            splashColor: Colors.black12,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                : null,
            tooltip: widget.isAdmin
                ? 'Delete Group'
                : 'Only admins can delete the group',
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Group Icon",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  IconButton(
                    icon: Icon(
                      widget.isAdmin ? Icons.edit : Icons.edit_off,
                      color: widget.isAdmin ? Colors.black : Colors.black54,
                    ),
                    tooltip: widget.isAdmin
                        ? "Change Group Icon"
                        : "Only admins can change group icon",
                    onPressed: widget.isAdmin
                        ? () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                    actionsPadding: EdgeInsets.only(bottom: 20),
                                    title: Text("Edit Group Icon"),
                                    titleTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            height: 40,
                                            width: 200,
                                            child: FlatButton(
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .padded,
                                                onPressed: () async {
                                                  final PickedFile _pickedFile =
                                                      await ImagePicker()
                                                          .getImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                  showLoaderDialog(context,
                                                      "Uploading icon");
                                                  if (_pickedFile != null) {
                                                    Uint8List bytesData =
                                                        await _pickedFile
                                                            .readAsBytes();

                                                    if (!kIsWeb) {
                                                      StorageReference ref =
                                                          FirebaseStorage
                                                              .instance
                                                              .ref()
                                                              .child('${widget.schoolCode}/GroupChats/${widget.groupRef.documentID}/icon/' +
                                                                  _pickedFile
                                                                      .path
                                                                      .toString()
                                                                      .split(
                                                                          '/')
                                                                      .last +
                                                                  '.txt');
                                                      StorageUploadTask
                                                          uploadTask =
                                                          ref.putData(
                                                              bytesData,
                                                              StorageMetadata(
                                                                  contentType:
                                                                      'images/'));
                                                      await uploadTask
                                                          .onComplete;
                                                      groupRef.updateData({
                                                        'Icon': (await ref
                                                                .getDownloadURL())
                                                            .toString(),
                                                        'IconFileName':
                                                            _pickedFile.path
                                                                    .toString()
                                                                    .split('/')
                                                                    .last +
                                                                '.txt'
                                                      });
                                                      ref
                                                          .getDownloadURL()
                                                          .then((value) {
                                                        setState(() {
                                                          icon =
                                                              value.toString();
                                                          iconFileName =
                                                              _pickedFile.path
                                                                      .toString()
                                                                      .split(
                                                                          '/')
                                                                      .last +
                                                                  '.txt';
                                                        });
                                                      });
                                                    } else {
                                                      UrlUtils.open(
                                                          bytesData,
                                                          '${widget.schoolCode}/GroupChats/${widget.groupRef.documentID}/icon/' +
                                                              _pickedFile.path
                                                                  .toString()
                                                                  .split('/')
                                                                  .last +
                                                              '.txt',
                                                          docRef: groupRef);
                                                      await groupRef
                                                          .updateData({
                                                        'IconFileName':
                                                            _pickedFile.path
                                                                    .toString()
                                                                    .split('/')
                                                                    .last +
                                                                '.txt'
                                                      });
                                                    }
                                                    Navigator.popUntil(
                                                        context,
                                                        ModalRoute.withName(
                                                            'GroupDetails'));
                                                    await groupRef
                                                        .collection(
                                                            'ChatMessages')
                                                        .document(
                                                            timeToString())
                                                        .setData({
                                                      'type': 'notification',
                                                      'text':
                                                          '${widget.userName} changed group icon'
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  "Change Icon",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: 200,
                                          child: FlatButton(
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize.padded,
                                              onPressed: icon == null
                                                  ? null
                                                  : () async {
                                                      await FirebaseStorage
                                                          .instance
                                                          .ref()
                                                          .child(
                                                              '${widget.schoolCode}/GroupChats/${widget.groupRef.documentID}/icon/$iconFileName')
                                                          .delete();
                                                      groupRef.updateData({
                                                        'Icon': null,
                                                        'IconFileName': null,
                                                      }).then((value) {
                                                        setState(() {
                                                          icon = null;
                                                          iconFileName = null;
                                                        });
                                                      });
                                                      await groupRef
                                                          .collection(
                                                              'ChatMessages')
                                                          .document(
                                                              timeToString())
                                                          .setData({
                                                        'type': 'notification',
                                                        'text':
                                                            '${widget.userName} removed group icon'
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                              child: Text("Remove Icon",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ))),
                                        ),
                                      ],
                                    )));
                          }
                        : null,
                  ),
                ]),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
            elevation: 5,
            child: Container(
              child: icon != null
                  ? Image.network(icon)
                  : Center(
                      child: Image.asset(
                      'assets/images/coverimage.jpg',
                      fit: BoxFit.cover,
                    )),
            ),
          ),
          Card(
            margin: EdgeInsets.only(left: 5, right: 5, top: 15),
            elevation: 5,
            child: ListTile(
              title: Text(
                "Description",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              subtitle: TextField(
                readOnly: !widget.isAdmin,
                cursorColor: Colors.black,
                maxLines: null,
                keyboardType: TextInputType.text,
                controller: controller,
                onSubmitted: (value) async {
                  if (value.compareTo(description) != 0 && value.length > 0) {
                    showLoaderDialog(context, "Please wait....");
                    await groupRef.updateData({"Description": value});
                    await groupRef
                        .collection('ChatMessages')
                        .document(timeToString())
                        .setData({
                      'type': 'notification',
                      'text': '${widget.userName} changed group description'
                    });
                    Navigator.pop(context);
                  }
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      widget.isAdmin ? Icons.edit : Icons.edit_off,
                      color: widget.isAdmin ? Colors.black : Colors.black54,
                    ),
                    tooltip: widget.isAdmin
                        ? "Change Group Description"
                        : "Only admins can change group description",
                    onPressed: widget.isAdmin ? () {} : null,
                  ),
                ),
              ),
            ),
          ),
          Card(
            elevation: 5,
            margin: EdgeInsets.only(left: 5, right: 5, top: 15),
            child: StreamBuilder(
                stream: groupRef.collection("Members").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  list = List();
                  list.add(ListTile(
                    title: Text(
                      "Members",
                      style: TextStyle(fontSize: 20),
                    ),
                  ));
                  QuerySnapshot snapshotData = snapshot.data;
                  snapshotData.documents.forEach((element) {
                    bool isAdmin = element.data['isAdmin'];
                    list.add(ListTile(
                      onTap: element.documentID.compareTo(id) != 0 &&
                              widget.isAdmin
                          ? () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatPersonProfile(
                                                                widget
                                                                    .schoolCode,
                                                                element
                                                                    .data['id'],
                                                                element.data[
                                                                    'isTeacher'])));
                                              },
                                              child: Text(
                                                "View Profile",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                          FlatButton(
                                              onPressed: () {
                                                groupRef.updateData({
                                                  'AdminCount': adminCount +
                                                      (isAdmin ? -1 : 1),
                                                }).then((value) {
                                                  element.reference.updateData({
                                                    'isAdmin': !isAdmin
                                                  }).then((value) {
                                                    setState(() {
                                                      adminCount = adminCount +
                                                          (isAdmin ? -1 : 1);
                                                      isAdmin = (!isAdmin);
                                                    });
                                                  });
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                isAdmin
                                                    ? 'Remove from admin'
                                                    : 'Make admin',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                          FlatButton(
                                              onPressed: () async {
                                                if (element.documentID
                                                        .split('_')
                                                        .last ==
                                                    'true') {
                                                  await teachersRef
                                                      .document(element
                                                          .documentID
                                                          .split('_')
                                                          .first)
                                                      .collection(
                                                          'GroupsJoined')
                                                      .document(
                                                          element.documentID)
                                                      .delete();
                                                } else {
                                                  await studentsRef
                                                      .document(element
                                                          .documentID
                                                          .split('_')
                                                          .first)
                                                      .collection(
                                                          'GroupsJoined')
                                                      .document(
                                                          element.documentID)
                                                      .delete();
                                                }
                                                if (isAdmin) {
                                                  groupRef.updateData({
                                                    'AdminCount': adminCount - 1
                                                  }).then((value) {
                                                    setState(() {
                                                      adminCount =
                                                          adminCount - 1;
                                                    });
                                                  });
                                                }
                                                await groupRef
                                                    .collection('ChatMessages')
                                                    .document(timeToString())
                                                    .setData({
                                                  'type': 'notification',
                                                  'text':
                                                      '${widget.userName} removed ${element.data['name']}'
                                                });
                                                await element.reference
                                                    .delete();
                                                Navigator.pop(context);
                                              },
                                              child: Text('Remove',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400)))
                                        ],
                                      ),
                                    );
                                  });
                            }
                          : null,
                      leading: element.data["imgURL"] != null
                          ? CircleAvatar(
                              backgroundImage: Image.network(
                                element.data["imgURL"],
                                fit: BoxFit.cover,
                              ).image,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black54,
                              child: Text(element.data['name']
                                      .split('')[0][0]
                                      .toUpperCase() +
                                  element.data['name']
                                      .split(' ')[1][0]
                                      .toUpperCase()),
                            ),
                      title: Text(
                          element.documentID.compareTo(id) == 0
                              ? "You"
                              : element.data['name'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(element.data['mobile'] +
                          "\n" +
                          element.data['classNumber'] +
                          " - " +
                          element.data['section']),
                      isThreeLine: true,
                      trailing: Column(
                        children: [
                          Text(element.data['isTeacher']
                              ? "Teacher"
                              : "Student"),
                          if (isAdmin) Text("Admin"),
                        ],
                      ),
                    ));
                    list.add(Divider(thickness: 0.8,color: Colors.black54,indent: 70,));
                  });
                  return list.length > 0
                      ? Column(children: list)
                      : CircularProgressIndicator();
                }),
          ),
          Card(
              elevation: 10,
              margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
              child: FlatButton(
                  onPressed: ((widget.isAdmin == true &&
                              (adminCount - 1) > 0) ||
                          widget.isAdmin == false)
                      ? () async {
                          if (widget.isAdmin) {
                            groupRef.updateData(
                                {'AdminCount': adminCount - 1}).then((value) {
                              setState(() {
                                adminCount = adminCount - 1;
                              });
                            });
                          }
                          await groupRef
                              .collection('Members')
                              .document(id)
                              .delete();
                          if (widget.isTeacher) {
                            await teachersRef
                                .document(widget.id)
                                .collection('GroupsJoined')
                                .document(groupRef.documentID)
                                .delete();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyAppTeacher(
                                        widget.schoolCode, widget.id)),
                                (route) => false);
                          } else {
                            await studentsRef
                                .document(widget.id)
                                .collection('GroupsJoined')
                                .document(groupRef.documentID)
                                .delete();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyAppStudent(
                                        widget.schoolCode, widget.id)),
                                (route) => false);
                          }
                        }
                      : null,
                  child: Text(
                    "Leave Group",
                    style: TextStyle(color: Colors.black),
                  ))),
        ],
      ),
    );
  }
}
