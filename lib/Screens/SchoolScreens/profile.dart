import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Schools/models/school.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  final String schoolCode;
  Profile(this.schoolCode);
  @override
  _ProfileState createState() => _ProfileState(schoolCode);
}

class _ProfileState extends State<Profile> {
  File _image;
  String schoolCode;
  School school = School("", "", "", "");
  TextEditingController _schoolNameController = TextEditingController();
  TextEditingController _schoolBoardController = TextEditingController();
  TextEditingController _schoolNoController = TextEditingController();
  TextEditingController _schoolEmailController = TextEditingController();

  _ProfileState(this.schoolCode);

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      setState(() {
        print("Profile picture Uploaded");
        // Scaffold.of(context).showSnackBar(Snackbar(content: Text('Profile Picture Uploaded')));
      });
    }

    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: _getProfileData(schoolCode),
              builder: (context, snapshot) {
                return displayUserInformation(context, snapshot);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Color(0xa9a9a9),
                child: ClipOval(
                  child: SizedBox(
                    width: 180.0,
                    height: 180.0,
                    child: (_image != null)
                        ? Image.file(_image)
                        : Image.network('data:image/jpeg;base64,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', fit: BoxFit.fill),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.camera,
                  size: 30.0,
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${school.schoolname}",
            style:
                DefaultTextStyle.of(context).style.apply(fontSizeFactor: 3.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Board: ${school.schoolboard}",
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "School Number: ${school.schoolno}",
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Email: ${school.schoolemail}",
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2),
          ),
        ),
        RaisedButton(
          child: Text("Edit Details",
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2)),
          onPressed: () {
            _schoolEditBottomSheet(context);
          },
        )
      ],
    );
  }

  Future<bool> _getProfileData(schoolCode) async {
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .get()
        .then((DocumentSnapshot result) {
      school.schoolname = result.data['schoolname'];
      school.schoolboard = result.data['schoolboard'];
      school.schoolno = result.data['schoolno'];
      school.schoolemail = result.data['schoolemail'];
      return true;
    });
    return true;
  }

  void _schoolEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * .65,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Update Profile",
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.5)),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.cancel),
                      color: Colors.black,
                      iconSize: 25,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextField(
                          controller: _schoolNameController,
                          decoration: InputDecoration(
                            helperText: "School Name",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextField(
                          controller: _schoolBoardController,
                          decoration: InputDecoration(
                            helperText: "School Board",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextField(
                          controller: _schoolEmailController,
                          decoration: InputDecoration(
                            helperText: "School Email",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextField(
                          controller: _schoolNoController,
                          decoration: InputDecoration(
                            helperText: "School Number",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Save'),
                      color: Colors.black,
                      textColor: Colors.white,
                      onPressed: () async {
                        school.schoolname = _schoolNameController.text;
                        school.schoolemail = _schoolEmailController.text;
                        school.schoolno = _schoolNoController.text;
                        school.schoolboard = _schoolBoardController.text;
                        setState(() {
                          _schoolNameController.text = school.schoolname;
                          _schoolEmailController.text = school.schoolemail;
                          _schoolNoController.text = school.schoolno;
                          _schoolBoardController.text = school.schoolboard;
                        });
                        Firestore.instance
                            .collection('School')
                            .document(schoolCode)
                            .setData(school.toJson(), merge: true);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
