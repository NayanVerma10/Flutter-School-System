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
  School school = School("", "", "", "","");
  TextEditingController _schoolNameController = TextEditingController();
  TextEditingController _schoolBoardController = TextEditingController();
  TextEditingController _schoolNoController = TextEditingController();
  TextEditingController _schoolEmailController = TextEditingController();
  TextEditingController _schoolPasswordController = TextEditingController();


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
                backgroundColor: Color(0x8A000000),
                child: ClipOval(
                  child: SizedBox(
                    width: 180.0,
                    height: 180.0,
                    child: (_image != null)
                        ? Image.file(_image)
                        : Image.network('', fit: BoxFit.fill),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.camera,
                  size: 20.0,
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
          height: MediaQuery.of(context).size.height * .80,
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
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextField(
                          controller: _schoolEmailController,
                          decoration: InputDecoration(
                            helperText: "School Email (required for login)",
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
                          controller: _schoolPasswordController,
                          decoration: InputDecoration(
                            helperText: "Password required for login",
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
                        school.schoolpassword =_schoolPasswordController.text;
                        setState(() {
                          _schoolNameController.text = school.schoolname;
                          _schoolEmailController.text = school.schoolemail;
                          _schoolNoController.text = school.schoolno;
                          _schoolBoardController.text = school.schoolboard;
                          _schoolPasswordController.text=school.schoolpassword;
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
