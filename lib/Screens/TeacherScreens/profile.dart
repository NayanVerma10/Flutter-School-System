import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:firebase/firebase.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker_web/image_picker_web.dart';
import 'package:universal_platform/universal_platform.dart';

import '../LogoutTheUser.dart';
//import 'dart:html';
/*class Profile extends StatelessWidget {
  String schoolCode,teachersId;
  Profile(this.schoolCode,this.teachersId);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Behavior',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600
          )
        ),
      ),
    );
  }
}*/
class Profile1 extends StatefulWidget 
{
  String schoolCode,teacherId, teacherName;
  Profile1(this.schoolCode,this.teacherId, this.teacherName);
  @override
  //final DocumentSnapshot post;
//  Profile({this.post,this.schoolCode});
  MapScreenState createState() => MapScreenState(schoolCode,teacherId,teacherName);
}

class MapScreenState extends State<Profile1>with SingleTickerProviderStateMixin 
{ 
  String schoolCode,teacherId,teacherName;
  MapScreenState(this.schoolCode,this.teacherId, this.teacherName);
  TextEditingController controller1;
  TextEditingController controller2;
  TextEditingController controller3;
  TextEditingController controller4;
  TextEditingController controllerd;
  TextEditingController controllera;
  TextEditingController controllerg;
  TextEditingController controllerq;
  final namecontroller  = new TextEditingController();
  final namecontroller1 = new TextEditingController();
  final namecontroller2 = new TextEditingController();
  final namecontrollera = new TextEditingController();
  final namecontrollerg = new TextEditingController();
  final namecontrollerq = new TextEditingController();
  final namecontrollerd = new TextEditingController();
  List<dynamic> classList = [];
 // String schoolCode;
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  @override
 File _image; 
String link="#";
void check()
{
var val=FirebaseFirestore.instance.collection('School').doc(schoolCode).
      collection("Teachers").doc(teacherId).get().then((value){
    //if(value.data()['url'])
    link=value.data()['url'];
    if(link==null)
    link='#';
      });
}

 Future<String>getD() async
 {
       var storageref = FirebaseStorage.instance    
       .ref()    
       .child('teachers/${namecontroller2.text}');    
       return await storageref.getDownloadURL();
 }
  void initState() {
    super.initState();
   check();
      String stored=getD().toString();
    DocumentReference dc=FirebaseFirestore.instance.collection('School').doc(schoolCode).
    collection("Teachers").doc(teacherId);
 
    dc.get().then((datas)  
    {
    List<dynamic> classes = datas.data()['classes']; 
    setState(() {
    print(datas.data()['first name']);
    namecontroller1.text = datas.data()['first name'];
    //namecontroller1.text = widget.post.data()["first name"];
    controller1 = TextEditingController(text: (datas.data()['first name']));
    namecontroller.text =datas.data()['email'];
    controller2 = TextEditingController(text:datas.data()['email']);
    namecontroller2.text = datas.data()['mobile'];
    controller3 = TextEditingController(text: datas.data()['mobile']);
    namecontrollerq.text = datas.data()['qualification'];
    controllerq = TextEditingController(text: datas.data()['qualification']);
    namecontrollera.text = datas.data()['address'];
    controllera = TextEditingController(text: datas.data()['address']);
    namecontrollerg.text = datas.data()['gender'];
    controllerg = TextEditingController(text: datas.data()['gender']);
    classList=classes;
    namecontrollerd.text=datas.data()['designation'];
    controllerd = TextEditingController(text: datas.data()['designation']);
    
/*    for(int i=0;i<classList.length;i++){ 
    namecontrollerd.text = classList[i]['Class'] + ' ' + classList[i]['Section'] + ' ' + classList[i]['Subject'];
    controllerd = TextEditingController(text: (classList[i]['Class'] + ' ' + classList[i]['Section'] + 
    ' ' + classList[i]['Subject']));
    }
    */});
    });
//  return datas;
//    FirebaseFirestore.instance.collection('69').doc(teacherId).snapshots();
//  AsyncSnapshot<DocumentSnapshot> snapshot;
    //Map<String, dynamic>documentFields = snapshot.data.data();
   // namecontroller1.text = documentFields['first name'];
    //namecontroller1.text = widget.post.data()["first name"];
    //controller1 = TextEditingController(text: (documentFields['first name']));
 //   namecontroller.text =documentFields['first name'];
  //  controller2 = TextEditingController(text:documentFields['email']);
 //   namecontroller2.text = documentFields['mobile'];
  //  controller3 = TextEditingController(text: documentFields['mobile']);
  //  namecontrollerq.text = documentFields['qualification'];
  //  controllerq = TextEditingController(text: documentFields['qualification']);
   // namecontrollera.text = documentFields['address'];
   // controllera = TextEditingController(text: documentFields['address']);
   // namecontrollerg.text = documentFields['gender'];
   // controllerg = TextEditingController(text: documentFields['gender']);
  //  namecontrollerd.text = documentFields["designation"];
  //  controllerd = TextEditingController(text: documentFields['designation']);
  }
  @override
  Widget build(BuildContext context) {
    String rt,rt1,rt2;
  bool isWeb=UniversalPlatform.isWeb;
//   bool isWeb = UniversalPlatform.isWeb;

  Future<void> _addPathToDatabase(String text) async {
    try {
      // Get image URL from firebase
      final ref = FirebaseStorage().ref().child(text);
      var imageString = await ref.getDownloadURL();

      // Add location and url to database
      await FirebaseFirestore.instance.collection('School').doc(schoolCode).
      collection("Teachers").doc(teacherId).set({'url':imageString , 'location':text},SetOptions(merge: true));
    }catch(e){
      print(e.message);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message),
            );
          }
      );
    }
  }
/*Future uploadPicWeb(BuildContext context) async{
  String fileName=_image.path;
  setState(() {
   fb.storage().refFromURL("https://console.firebase.google.com/project/aatmanirbhar-51cd2/storage/aatmanirbhar-51cd2.appspot.com/files")
   .child("teachers/${namecontroller2.text}").put(_image); 
  });
} */

  Future<void> uploadPic(BuildContext context) async {    
   String fileName=_image.path;
   StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('teachers/${namecontroller2.text}');    
   StorageUploadTask uploadTask = storageReference.putFile(_image);    
   StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;    
   print('File Uploaded');    
     setState(() {    
       print("Profile updated");
   //    getUrl();
   _addPathToDatabase("teachers/${namecontroller2.text}");
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
     });
 }  

Future getImage(BuildContext context) async 
{
      var image = await ImagePicker().getImage(source: ImageSource.gallery);
      setState(() {
      _image = File(image.path);
      //print(_image);
   //   print("g"+_images.path);
      print('Image path $_image');                                    
    });

    await uploadPic(context);


}
/*Future getImageWeb() async 
{
var fromPicker = await ImagePickerWeb.getImage(  outputType: ImageType.file);
   setState(() {
      _image = File(fromPicker.path);
      //print(_image);
   //   print("g"+_images.path);
      print('Image path $_image');                                    
    });
}*/
    DocumentReference dc=FirebaseFirestore.instance.collection('School').doc(schoolCode).
    collection("Teachers").doc(teacherId);
    dc.get().then((datas){
    rt = datas.data()['first name'];
    rt1=datas.data()['email'];
    rt2=datas.data()['mobile'];
    });
       return new Scaffold(
        appBar: AppBar(
            title: Text(
              teacherName,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 200.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        
                        
                        //ye andorid le ffd
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child:
                          new Stack(fit: StackFit.loose, children: <Widget>[
                          new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                    width: 140.0,
                                    height: 140.0,
                                    child: 
          (_image!=null )?CircleAvatar(
                            backgroundColor: Colors.black,
       backgroundImage: FileImage(_image),
        // NetworkImage(_image,),
                          ):((link=='#')?CircleAvatar(
                            backgroundColor: Colors.black,
       backgroundImage: AssetImage('assets/images/dev.jpg'),
        // NetworkImage(_image,),
                          ):CircleAvatar(
                            backgroundColor: Colors.black,
       backgroundImage: NetworkImage(link),
        // NetworkImage(_image,),
                          ))

                                    /*(_image!=null)?CircleAvatar(    
                                    backgroundColor: Colors.black87,                                      
                                      /*url==null?Image.asset('assets/images/dev.jpg' ,fit: BoxFit.cover,height: 100,width:100.0,):*/
                                    child:(_image!=null)?Image.file(_image,fit:BoxFit.cover,height: 100,width:100.0,):
                                   (link=='#')?(Image.asset("assets/images/dev.jpg",
                                     fit: BoxFit.cover,height: 100,width:100.0,)):(Image.network(link,
                                     fit: BoxFit.cover,height: 100,width:100.0,)),
                                     ):
                                     CircleAvatar(    
                                    backgroundColor: Colors.grey,                                      
                                      /*url==null?Image.asset('assets/images/dev.jpg' ,fit: BoxFit.cover,height: 100,width:100.0,):*/
                                  child:(_image!=null)?Image.file(_image,fit:BoxFit.cover,height: 100,width:100.0,):
                                   (link=='#')?(Image.asset("assets/images/mteacher2.jpg",
                                     fit: BoxFit.cover,height: 101,width:101.0,)):(Image.network(link,
                                     fit: BoxFit.cover,height: 101,width:101.0,)),
                                     ),
*/
                                    ),
                              ],
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 90.0, left: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: new CircleAvatar(
                                        backgroundColor: Colors.black87,
                                        radius: 25.0,
                                        child: new Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      ), 
                                      onTap:(){                                      
                                     // (isWeb==true)?getImageWeb():
                                      getImage(context); 
                                        //print(_image);
                                      },
                                    ),
                                  ],
                                ),
                                ),
                                
                          ]),
                        )
                      ],
                    ),
                  ),
                          StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {
                        return new Container(
                          color: Color(0xffFFFFFF),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 0.0),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Profile:',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            _status
                                                ? _getEditIcon(context, rt2)
                                                : new Container(),
                                          ],
                                        )
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 15.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Name',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 0.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            readOnly: true,
                                            controller: controller1,
                                            decoration: const InputDecoration(
                                                hintText: "Name"
                                                //hintText: "rfe",

                                                //  hintText:rt,
                                                //labelText:  widget.post.data()["schoolname"]
                                                ),
                                            enabled: !_status,
                                            //   autofocus: !_status,
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 15.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Email ID',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 0.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            readOnly: true,
                                            controller: controller2,
                                            decoration: const InputDecoration(
                                                hintText: "Enter Email ID"),
                                            enabled: !_status,
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 15.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Mobile',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 0.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            readOnly: true,
                                            controller: controller3,
                                            decoration: const InputDecoration(
                                                hintText:
                                                    "Enter Mobile Number"),
                                            enabled: !_status,
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 15.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Qualification',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 0.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            readOnly: true,
                                            controller: controllerq,
                                            decoration: const InputDecoration(
                                                hintText:
                                                    "Enter Qualification"),
                                            enabled: !_status,
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 15.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Address',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 0.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            readOnly: true,
                                            controller: controllera,
                                            decoration: const InputDecoration(
                                                hintText: "Enter Address"),
                                            enabled: !_status,
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 15.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Designation:',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 0.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            readOnly: true,
                                            controller: controllerd,
                                            decoration: const InputDecoration(
                                                hintText: "Enter Classes"),
                                            enabled: !_status,
                                          ),
                                        ),
                                      ],
                                    )),
                              
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 15.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: new Text(
                                              'Designation',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: new Text(
                                              'Gender',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          flex: 2,
                                        ),
                                      ],
                                    )
                                    ,),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 0.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 10.0),
                                            child: new TextField(
                                              readOnly: true,
                                              controller: controllerd,
                                              decoration: const InputDecoration(
                                                  hintText:
                                                      "designation"),
                                              enabled: !_status,
                                            ),
                                          ),
                                          flex: 2,
                                        ),
                                        Flexible(
                                          child: new TextField(
                                            readOnly: true,
                                            controller: controllerg,
                                            decoration: const InputDecoration(
                                                hintText: "Your Gender"),
                                            enabled: !_status,
                                          ),
                                          flex: 2,
                                        ),
                                      ],
                                    )),
                       
                                !_status
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 15.0),
                                        child: new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10.0),
                                                child: Container(
                                                    child: new RaisedButton(
                                                  child: new Text(
                                                      "Save".toUpperCase()),
                                                  textColor: Colors.white,
                                                  color: Colors.black,
                                                  onPressed: () {
                                                    setState(() {
                                                      _status = true;
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              new FocusNode());
                                                    });
                                                  //  Navigator.of(context).pop();
                                                  },
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  20.0)),
                                                )),
                                              ),
                                              flex: 2,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10.0),
                                                child: Container(
                                                    child: new FlatButton(
                                                  child: new Text(
                                                      "Cancel".toUpperCase()),
                                                  textColor: Colors.white,
                                                  color: Colors.black,
                                                  onPressed: () {
                                                    setState(() {
                                                      _status = true;
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              new FocusNode());
                                                    });
                                                    //Navigator.of(context).pop();
                                                  },
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  20.0)),
                                                )),
                                              ),
                                              flex: 2,
                                            ),
                                          ],
                                        ),
                                      )
                                    : new Container(),
                              ],
                            ),
                          ),
                        );
                      })
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  /*Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save".toUpperCase()),
                textColor: Colors.white,
                color: Colors.black,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new FlatButton(
                child: new Text("Cancel".toUpperCase()),
                textColor: Colors.white,
                color: Colors.black,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }
*/
  void tripEdit(BuildContext context, String rt2) {
    String name;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Container(
            height: MediaQuery.of(context).size.height * .65,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "EDIT TEXT",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.black,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        style: TextStyle(
                          height: 1.5,
                        ),
                        controller: namecontroller,
                        decoration: InputDecoration(hintText: 'Email'),
                        // controller: controller4,
                        //  autofocus: true,
                      )),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        style: TextStyle(
                          height: 1.5,
                        ),
                        controller: namecontrollerd,
                        decoration: InputDecoration(hintText: 'Designation'),
                        // controller: controller4,
                        //  autofocus: true,
                      )),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        style: TextStyle(
                          height: 1.5,
                        ),
                        controller: namecontrollerg,
                        decoration: InputDecoration(hintText: 'Gender'),
                        // controller: controller4,
                        //  autofocus: true,
                      )),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                        color: Colors.black,
                        onPressed: () {
                          setState(() {
                            Navigator.of(context).pop();

                            controller1.text = namecontroller1.text;
                            controller2.text = namecontroller.text;
                            namecontroller2.text = rt2;
                            controller3.text = namecontroller2.text;

                            controllerq.text = namecontrollerq.text;

                            controllera.text = namecontrollera.text;
                            controllerg.text = namecontrollerg.text;
                            controllerd.text = namecontrollerd.text;
                          });
                          setState(() {
                            name = namecontroller.text;
                            print('$name is');
  DocumentReference dc=FirebaseFirestore.instance.collection('School').doc(schoolCode).
    collection('Teachers').doc(teacherId);
    dc.get().then((datas){
    datas.data()['first name']=       namecontroller1.text;
                         
    datas.data()['email']=       namecontroller.text;
    datas.data()['mobile']=namecontroller2.text;
                         datas.data()["qualification"] =
                                namecontrollerq.text;
                            datas.data()["address"] = namecontrollera.text;
                            datas.data()["gender"] = namecontrollerg.text;
                            datas.data()["designation"] =
                                namecontrollerd.text;
                           updateuserdata(datas.data()['mobile']);
    });                      });
//sprint(name);
                        },
                        child: Text(
                          'Save Data'.toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  Future updateuserdata(String rt2) async {
    final CollectionReference brew = FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection('Teachers');
    return await brew.doc(rt2).set({
      'email': namecontroller.text,
      'mobile': namecontroller2.text,
      'first name': namecontroller1.text,
      'address': namecontrollera.text,
      'gender': namecontrollerg.text,
      'designation': namecontrollerd.text,
      'qualification': namecontrollerq.text,
    },SetOptions(merge: true));
  }

  void update(String rt2) {
    final CollectionReference brew = FirebaseFirestore.instance
        .collection('School')
        .doc(schoolCode)
        .collection('Teachers');
    brew.doc(rt2).set({
      'email': controller4.text,
    },SetOptions(merge: true));
  }

  Widget _getEditIcon(BuildContext context, String rt2) {
    return new GestureDetector(
      child: new RaisedButton(
        onPressed: () {
//update(rt2);
          tripEdit(context, rt2);
          setState(() {
            _status = false;
          });
        },
        child: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        color: Colors.black,
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
