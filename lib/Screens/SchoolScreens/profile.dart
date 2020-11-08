import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Schools/models/school.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';

class Profile extends StatefulWidget {
  final String schoolCode;
  Profile(this.schoolCode);
  @override
  _ProfileState createState() => _ProfileState(schoolCode);
}

class _ProfileState extends State<Profile> {
  // File _image;
  String schoolCode;
  School school = School("", "", "", "", "", "");
  TextEditingController _schoolNameController = TextEditingController();
  TextEditingController _schoolBoardController = TextEditingController();
  TextEditingController _schoolNoController = TextEditingController();
  TextEditingController _schoolEmailController = TextEditingController();
  TextEditingController _schoolPasswordController = TextEditingController();
  TextEditingController _schoolAboutController = TextEditingController();

  _ProfileState(this.schoolCode);
  final databaseReference = Firestore.instance;

 

  @override
  Widget build(BuildContext context) {
    // Future getImage() async {
    //   var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    //   setState(() {
    //     _image = image;
    //     print('Image Path $_image');
    //   });
    // }


    // Future uploadPic(BuildContext context) async {
    //   String fileName = basename(_image.path);
    //   StorageReference firebaseStorageRef =
    //       FirebaseStorage.instance.ref().child(fileName);
    //   StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    //   StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    //   setState(() {
    //     print("Profile picture Uploaded");
    //     // Scaffold.of(context).showSnackBar(Snackbar(content: Text('Profile Picture Uploaded')));
    //   });
    // }

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

 File _coverImage;
 File _profImage;
bool isProf=false;
bool isCover=false;
  final picker = ImagePicker();
  File _selectedProfFile;
  File _selectedCoverFile;
  bool _inProcess = false;
      Future getImageFromGallery() async {
    this.setState(() {
      _inProcess = true;
    });
    final pickedProfFile = await picker.getImage(source: ImageSource.gallery);
    _profImage = File(pickedProfFile.path);


    if (_profImage != null) {
      File croppedProf = await ImageCropper.cropImage(
          sourcePath: _profImage.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.white,
            toolbarTitle: "Crop profile image",
            statusBarColor: Colors.orange,
            backgroundColor: Colors.white,
          ));

      this.setState(() {
        _selectedProfFile = croppedProf;
        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

   Future getCoverFromGallery() async {
    this.setState(() {
      _inProcess = true;
    });
   

     final pickedCoverFile = await picker.getImage(source: ImageSource.gallery);
    _coverImage = File(pickedCoverFile.path);

    if (_coverImage != null) {
      File croppedCover = await ImageCropper.cropImage(
          sourcePath: _coverImage.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.white,
            toolbarTitle: "Crop cover image",
            statusBarColor: Colors.orange,
            backgroundColor: Colors.white,
          ));

      this.setState(() {
        _selectedCoverFile = croppedCover;
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
                  isProf=true;
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

   Widget editCoverImage() {
    return Container(
        height: 100,
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FlatButton(
                child: Text('Add cover image',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                onPressed: () {
                  getCoverFromGallery();
                }),
            FlatButton(
                child: Text(
                  'Remove cover image',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: null)
          ],
        ));
  }

  Widget displayUserInformation(context, snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
                Padding(
              padding: EdgeInsets.only(top: 0),
              child: new Stack(fit: StackFit.loose, children: <Widget>[
                Container(
                 // color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 170,
                   decoration: new BoxDecoration(
                     color: Colors.white,
                          image: new DecorationImage(
                              image: _selectedCoverFile != null
                                  ? FileImage(_selectedCoverFile)
                                  :
                                  // Image.file(_selectedFile) :
                                  ExactAssetImage('assets/images/coverimage.jpg'),
                              fit: BoxFit.cover))
                ),
               
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(top: 100),
                      width: 130.0,
                      height: 130.0,
                      decoration: new BoxDecoration(
                       border: Border.all(color: Colors.white,
                       width: 5
                       ),
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              image: _selectedProfFile != null
                                  ? FileImage(_selectedProfFile)
                                  :
                                  // Image.file(_selectedFile) :
                                  ExactAssetImage('assets/images/profile.jpg'),
                              fit: BoxFit.cover)),
                    )
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top: 180.0, left: 90.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new CircleAvatar(
                          backgroundColor: Colors.grey[800],
                          radius: 22.0,
                          child: new IconButton(
                            icon: Icon(Icons.camera_alt,
                            size: 25,
                            ),
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
                    GestureDetector(
                  child: Container(
                      // alignment: Alignment.center,
                       decoration: BoxDecoration(
             borderRadius: BorderRadius.only(topLeft:Radius.circular(5)),
             color:const Color(0xFFFFFF).withOpacity(0.5),
             ),
                  margin: EdgeInsets.only(top:134,left: 290),
                  // color:const Color(0xFFFFFF).withOpacity(0.5),
                  height: 38,
                  width:80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     Icon(Icons.camera_alt,
                            size: 25),
                            SizedBox(width: 5,),
                            Text('Edit',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                            ),
                            )
                  ],),
                ),
                onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Text(
                                          'Edit Photo',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: editCoverImage(),
                                      ));
                }
                ),
              
              ]),
            ),
          ],
        ),      
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children:[
                    Icon(Icons.school,
                    size: 22),
                    SizedBox(width: 10,),
                Text(
                  "Board: ${school.schoolboard}",
                  style:TextStyle(fontSize: 17,
                  fontWeight: FontWeight.bold
                  )
                      
                    )]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children:[
                    Icon(Icons.phone,
                    size: 22),
                    SizedBox(width: 10,),
                 Text(
                  "School Number: ${school.schoolno}",
                  style:
                     TextStyle(fontSize: 17,
                  fontWeight: FontWeight.bold
                  )
                )]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:  Row(
                  children:[
                    Icon(Icons.email,
                    size: 22),
                    SizedBox(width: 10,),
                Text(
                  "Email: ${school.schoolemail}",
                  style:TextStyle(fontSize: 17,
                  fontWeight: FontWeight.bold
                  )
                  // style:
                  //     DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2),
                )]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Icon(Icons.person,
                    size: 22
                    ),
                    SizedBox(width: 10,),
                     Text(
                  "About Us: ",
                  style:TextStyle(fontSize: 17,
                  fontWeight: FontWeight.bold
                  )
                 
                ),
                
                   Expanded(
                    
                   child:  Text(
                  "${school.about}",
                  style:TextStyle(fontSize: 17,
                  fontWeight: FontWeight.bold
                  ),
                   overflow: TextOverflow.ellipsis,
                   maxLines: 20,
                   textAlign: TextAlign.left,
                  // style: DefaultTextStyle.of(context)
                  //     .style
                  //     .apply(fontSizeFactor: 1.8),
                )
                )
                ]),
              ),
            ],
          ),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
          GestureDetector(
               child: Container(
                  decoration: BoxDecoration(
             borderRadius: BorderRadius.all(Radius.circular(40)),
              color: Colors.black,
             ),
             padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                
                // margin: EdgeInsets.only(top:210,left: 260),
                  // color:const Color(0xFFFFFF).withOpacity(0.5),
                  
               // padding: EdgeInsets.zero,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                   Icon(Icons.edit,
                   size: 18,
                   color: Colors.white,),
                   SizedBox(width: 5,),
                   Text('Edit Profile',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)
                   )
                 ],)),
                 onTap:(){ _schoolEditBottomSheet(context);}
              )]))
      //  Padding(padding: const EdgeInsets.all(10)),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.only(left: 20),
        //       child: RaisedButton(
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(18.0),
        //             side: BorderSide(color: Colors.black)),
        //         child: Text("Edit Details",
        //             style: DefaultTextStyle.of(context)
        //                 .style
        //                 .apply(fontSizeFactor: 2)),
        //         onPressed: () {
        //           _schoolEditBottomSheet(context);
        //         },
        //       ),
        //     )
        //   ],
        // )
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
                              ? "Please Enter your School's Mobile Number"
                              : null,
                          decoration: InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              labelText: "School's Mobile Number",
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
