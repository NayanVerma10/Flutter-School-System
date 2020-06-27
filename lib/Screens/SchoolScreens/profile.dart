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
  School school = School("", "", "", "", "", "");
  TextEditingController _schoolNameController = TextEditingController();
  TextEditingController _schoolBoardController = TextEditingController();
  TextEditingController _schoolNoController = TextEditingController();
  TextEditingController _schoolEmailController = TextEditingController();
  TextEditingController _schoolPasswordController = TextEditingController();
  TextEditingController _schoolAboutController = TextEditingController();

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(10)),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 70,
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${school.schoolname}",
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 2.5),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Board: ${school.schoolboard}",
                  style:
                      DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "School Number: ${school.schoolno}",
                  style:
                      DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Email: ${school.schoolemail}",
                  style:
                      DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "About Us: ${school.about}",
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.8),
                ),
              ),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.all(10)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.black)),
                child: Text("Edit Details",
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 2)),
                onPressed: () {
                  _schoolEditBottomSheet(context);
                },
              ),
            )
          ],
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
      school.about = result.data['about'];
      return true;
    });
    return true;
  }

  void _schoolEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      backgroundColor: Colors.white70,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * .75,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextFormField(
                          controller: _schoolNameController,
                          validator: (value) => (value.isEmpty)
                              ? "Please Enter your School Name"
                              : null,
                          decoration: InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              labelText: "School Name",
                              filled: true,
                              fillColor: Colors.white54,
                              focusColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25))),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(padding: const EdgeInsets.all(5)),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextFormField(
                          controller: _schoolBoardController,
                          validator: (value) => (value.isEmpty)
                              ? "Please Enter your School's Board of Affiliation"
                              : null,
                          decoration: InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              labelText: "School Board",
                              filled: true,
                              fillColor: Colors.white54,
                              focusColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25))),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(padding: const EdgeInsets.all(5)),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextFormField(
                          controller: _schoolNoController,
                          validator: (value) => (value.isEmpty)
                              ? "Please Enter your School's Affiliation Code"
                              : null,
                          decoration: InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              labelText: "School's Affiliation Code",
                              filled: true,
                              fillColor: Colors.white54,
                              focusColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25))),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(padding: const EdgeInsets.all(5)),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: TextFormField(
                        controller: _schoolEmailController,
                        validator: (value) => (value.isEmpty)
                            ? "Please Enter your School Email to be used for login"
                            : null,
                        decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 10.0),
                            labelText: "School Email",
                            filled: true,
                            fillColor: Colors.white54,
                            focusColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25))),
                      ),
                    ))
                  ],
                ),
                Padding(padding: const EdgeInsets.all(5)),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextFormField(
                          controller: _schoolPasswordController,
                          validator: (value) => (value.isEmpty)
                              ? "Please Enter the password to be used for login"
                              : null,
                          decoration: InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              labelText: "Login Password",
                              filled: true,
                              fillColor: Colors.white54,
                              focusColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25))),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(padding: const EdgeInsets.all(5)),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: TextFormField(
                        controller: _schoolAboutController,
                        minLines: 3,
                        maxLines: 5,
                        validator: (value) => (value.isEmpty)
                            ? "Please Enter your something about the School Organization"
                            : null,
                        decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 10.0),
                            labelText: "About Us",
                            filled: true,
                            fillColor: Colors.white54,
                            focusColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25))),
                      ),
                    ))
                  ],
                ),
                Padding(padding: const EdgeInsets.all(5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black)),
                      child: Text('Save', style: TextStyle(fontSize: 22)),
                      color: Colors.black,
                      textColor: Colors.white,
                      onPressed: () async {
                        school.schoolname = _schoolNameController.text;
                        school.schoolemail = _schoolEmailController.text;
                        school.schoolno = _schoolNoController.text;
                        school.schoolboard = _schoolBoardController.text;
                        school.schoolpassword = _schoolPasswordController.text;
                        school.about = _schoolAboutController.text;
                        setState(() {
                          _schoolNameController.text = school.schoolname;
                          _schoolEmailController.text = school.schoolemail;
                          _schoolNoController.text = school.schoolno;
                          _schoolBoardController.text = school.schoolboard;
                          _schoolPasswordController.text =
                              school.schoolpassword;
                          _schoolAboutController.text = school.about;
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
