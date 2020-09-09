import 'dart:typed_data';

import 'package:Schools/widgets/AlertDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupDetails extends StatefulWidget {
  DocumentReference groupRef;
  bool isAdmin;
  GroupDetails(this.groupRef, this.isAdmin);

  @override
  _GroupDetailsState createState() => _GroupDetailsState(groupRef);
}

class _GroupDetailsState extends State<GroupDetails> {
  TextEditingController nameController, controller;
  DocumentReference groupRef;
  _GroupDetailsState(this.groupRef);
  Uint8List bytes;
  String name, description;
  List<Widget> list;
  @override
  void initState() {
    super.initState();
    groupRef.get().then((value) => setState(() {
          bytes = Uint8List.fromList(List<int>.unmodifiable(value.data["Icon"]));
          name = value.data["Name"];
          description = value.data["Description"];
          controller = TextEditingController(text: description);
          nameController = TextEditingController(text: name);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: TextField(
          maxLines: null,
          controller: nameController,
          readOnly: !widget.isAdmin,
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isAdmin ? Icons.edit : Icons.edit_off,
              color: Colors.black,
            ),
            tooltip: widget.isAdmin
                ? "Change Group Name"
                : "Only admins can change group name",
            onPressed: () {},
          ),
          SizedBox(
            width: 5,
          ),
          Icon(Icons.more_vert),
          SizedBox(
            width: 5,
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
                      color: Colors.black,
                    ),
                    tooltip: widget.isAdmin
                        ? "Change Group Icon"
                        : "Only admins can change group icon",
                    onPressed: () {},
                  ),
                ]),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
            elevation: 5,
            child: Container(
              child: bytes != null?Image(image: MemoryImage(bytes),fit: BoxFit.cover,)
                  // ? DecoratedBox(
                  //     decoration: BoxDecoration(
                  //         shape: BoxShape.rectangle,
                  //         image: DecorationImage(
                  //             fit: BoxFit.cover,
                  //             image: Image.memory(bytes).image)),
                  //   )
                  : Center(child: CircularProgressIndicator()),
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
              trailing: IconButton(
                icon: Icon(
                  widget.isAdmin ? Icons.edit : Icons.edit_off,
                  color: Colors.black,
                ),
                tooltip: widget.isAdmin
                    ? "Change Group Description"
                    : "Only admins can change group description",
                onPressed: widget.isAdmin ? () {} : null,
              ),
              subtitle: TextField(
                readOnly: !widget.isAdmin,
                cursorColor: Colors.black,
                maxLines: null,
                keyboardType: TextInputType.text,
                controller: controller,
                onSubmitted: (value) {
                  if (value.compareTo(description) != 0) {
                    showLoaderDialog(context, "Please wait....");
                    groupRef.updateData({"Description": value}).then(
                        (value) => null);
                    Navigator.pop(context);
                  }
                },
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
                    list.add(ListTile(
                      leading: element.data["imgURL"] != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                element.data["imgURL"],
                              ),
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
                      title: Text(element.data['name'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(element.data['mobile'] +
                          "\n" +
                          element.data['classNumber'] +
                          " - " +
                          element.data['section']),
                      isThreeLine: true,
                      trailing: Text(
                          element.data['isTeacher'] ? "Teacher" : "Student"),
                    ));
                  });
                  return list.length > 0
                      ? Column(children: list)
                      : CircularProgressIndicator();
                }),
          ),
        ],
      ),
    );
  }
}
