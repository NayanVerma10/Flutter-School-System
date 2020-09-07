import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart';
import '../Chat/FlutterWebFileUpload.dart';
import 'GroupChats.dart';
import 'dart:io' as io;
import 'dart:async';

class GroupName extends StatefulWidget {
  String schoolCode;
  GroupName(this.schoolCode);

  @override
  _GroupNameState createState() => _GroupNameState();
}

class _GroupNameState extends State<GroupName> {
  String name = "", description = "";

  ImageProvider _selectedImage;

  // String _uploadedFileURL;

  // var _fileBytes;
  // Image _imageWidget;
  // File cropped;

  Future<void> getImage() async {
    if (kIsWeb) {
      Image image = await FlutterWebFileUpload();
      setState(() {
        _selectedImage = image.image;
      });
    } else {
      final _pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);

      if (_pickedFile != null) {
        this.setState(() {
          _selectedImage = Image.file(io.File(_pickedFile.path)).image;
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
                onPressed: () {
                  getImage();
                  Navigator.pop(context);
                }),
            FlatButton(
                child: Text(
                  'Remove Image',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: _selectedImage == null
                    ? null
                    : () {
                        setState(() {
                          _selectedImage = null;
                          Navigator.pop(context);
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
                                image: _selectedImage != null
                                    ? _selectedImage
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
                                    builder: (_) => AlertDialog(
                                          title: Text(
                                            'Edit Photo',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: editImage(),
                                        ));
                                //getImageFromGallery();
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
                    ? () {
                        print(Firestore.instance
                            .collection("School")
                            .document(widget.schoolCode)
                            .collection("GroupChats")
                            .add({
                          "Description": description,
                          "Name": name,
                          "GroupIcon": _selectedImage ?? null
                        }));
                        if (_selectedImage != null) {
                          uploadImageFile(imageName: "${widget.schoolCode}/GroupChats/$name/icon/");
                        }
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

  // String picName = timeToString();

  // Future uploadFile() async {
  //   var ref = FirebaseStorage.instance
  //       .ref()
  //       .child(widget.schoolCode)
  //       .child("GroupChats")
  //       .child('${timeToString()}.jpg}');
  //   var uploadTask = ref.putFile(cropped);
  //   await uploadTask.onComplete;
  //   print('File Uploaded');
  //   ref.getDownloadURL().then((fileURL) {
  //     setState(() {
  //       _uploadedFileURL = fileURL;
  //     });
  //   });
  // }
}
