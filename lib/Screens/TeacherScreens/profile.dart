import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
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
class Profile extends StatefulWidget 
{
  String schoolCode,teacherId;
  Profile(this.schoolCode,this.teacherId);
  @override
  //final DocumentSnapshot post;
//  Profile({this.post,this.schoolCode});
  MapScreenState createState() => MapScreenState(schoolCode,teacherId);
}

class MapScreenState extends State<Profile>with SingleTickerProviderStateMixin 
{ 
  String schoolCode,teacherId;
  MapScreenState(this.schoolCode,this.teacherId);
 
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
  void initState() {
    // TODO: implement initState
    super.initState();
  
  
    DocumentReference dc=Firestore.instance.collection('School').document(schoolCode).
    collection('Teachers').document(teacherId);
 
    dc.get().then((datas)  
    {
    List<dynamic> classes = datas.data['classes']; 
    setState(() {
    print(datas.data['first name']);
    namecontroller1.text = datas.data['first name'];
    //namecontroller1.text = widget.post.data["first name"];
    controller1 = TextEditingController(text: (datas.data['first name']));
    namecontroller.text =datas.data['email'];
    controller2 = TextEditingController(text:datas.data['email']);
    namecontroller2.text = datas.data['mobile'];
    controller3 = TextEditingController(text: datas.data['mobile']);
    namecontrollerq.text = datas.data['qualification'];
    controllerq = TextEditingController(text: datas.data['qualification']);
    namecontrollera.text = datas.data['address'];
    controllera = TextEditingController(text: datas.data['address']);
    namecontrollerg.text = datas.data['gender'];
    controllerg = TextEditingController(text: datas.data['gender']);
    classList=classes;
    namecontrollerd.text=datas.data['designation'];
    controllerd = TextEditingController(text: datas.data['designation']);
    
/*    for(int i=0;i<classList.length;i++){ 
    namecontrollerd.text = classList[i]['Class'] + ' ' + classList[i]['Section'] + ' ' + classList[i]['Subject'];
    controllerd = TextEditingController(text: (classList[i]['Class'] + ' ' + classList[i]['Section'] + 
    ' ' + classList[i]['Subject']));
    }
    */});
    });
//  return datas;
//    Firestore.instance.collection('69').document(teacherId).snapshots();
//  AsyncSnapshot<DocumentSnapshot> snapshot;
    //Map<String, dynamic>documentFields = snapshot.data.data;
   // namecontroller1.text = documentFields['first name'];
    //namecontroller1.text = widget.post.data["first name"];
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
    DocumentReference dc=Firestore.instance.collection('School').document(schoolCode).
    collection('Teachers').document(teacherId);
    dc.get().then((datas){
    rt = datas.data['first name'];
    rt1=datas.data['email'];
    rt2=datas.data['mobile'];
    });
       return new Scaffold(
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
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: new ExactAssetImage(
                                            'assets/images/dev.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 90.0, right: 100.0),
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
                                      //onTap: imageSelectorGallery,
                                    )
                                  ],
                                )),
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
                                                //labelText:  widget.post.data["schoolname"]
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
                                    )),
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
                                                      "designatiob"),
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
  DocumentReference dc=Firestore.instance.collection('School').document(schoolCode).
    collection('Teachers').document(teacherId);
    dc.get().then((datas){
    datas.data['first name']=       namecontroller1.text;
                         
    datas.data['email']=       namecontroller.text;
    datas.data['mobile']=namecontroller2.text;
                         datas.data["qualification"] =
                                namecontrollerq.text;
                            datas.data["address"] = namecontrollera.text;
                            datas.data["gender"] = namecontrollerg.text;
                            datas.data["designation"] =
                                namecontrollerd.text;
                           updateuserdata(datas.data['mobile']);
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
    final CollectionReference brew = Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Teachers');
    return await brew.document(rt2).setData({
      'email': namecontroller.text,
      'mobile': namecontroller2.text,
      'first name': namecontroller1.text,
      'address': namecontrollera.text,
      'gender': namecontrollerg.text,
      'designation': namecontrollerd.text,
      'qualification': namecontrollerq.text,
    }, merge: true);
  }

  void updateData(String rt2) {
    final CollectionReference brew = Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Teachers');
    brew.document(rt2).setData({
      'email': controller4.text,
    }, merge: true);
  }

  Widget _getEditIcon(BuildContext context, String rt2) {
    return new GestureDetector(
      child: new RaisedButton(
        onPressed: () {
//updateData(rt2);
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
