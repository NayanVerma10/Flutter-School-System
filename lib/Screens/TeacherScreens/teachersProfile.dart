import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'pro.dart';
import 'dart:async';

class Pagin extends StatefulWidget 
{
  final String schoolCode;
  Pagin(this.schoolCode);
  @override
  _PaginState createState() => _PaginState(schoolCode);
}

class _PaginState extends State<Pagin> 
{
  String schoolCode;
  String name;
  _PaginState(this.schoolCode);
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      backgroundColor: Colors.white,
      body: ListPage(schoolCode),
    );
  }
}

String schoolname;
String classTeacher;
/*readData ()
{
   DocumentReference documentReference =Firestore.instance.collection("School").document("0147");
documentReference.get().then((datasnapshot)
{   
  schoolname=datasnapshot.data["schoolname"];
  classTeacher=datasnapshot.data["schoolboard"];
  print(datasnapshot.data["schoolname"]);
  print(datasnapshot.data["schoolemail"]);
  print(datasnapshot.data["schoolcode"]);
  print(datasnapshot.data["password"]);
  print(datasnapshot.data["schoolno"]);
  print(datasnapshot.data["schoolboard"]);
}
);
}*/

class ListPage extends StatefulWidget {
  String schoolCode;
  ListPage(this.schoolCode);
  @override
  _ListPageState createState() => _ListPageState(schoolCode);
}

class _ListPageState extends State<ListPage> {
  String schoolCode;
  _ListPageState(this.schoolCode);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorkey =
      new GlobalKey<RefreshIndicatorState>();
  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection("School")
        .document(schoolCode)
        .collection("Teachers")
        .getDocuments();
    return qn.documents;
  }

  Future<Null> _refreshLocalGallery() async 
{
    print('refreshing....');
    setState(() {
      getPosts();
    });
    return null;
}
 
  @override
  Widget build(BuildContext context) {
    funcButton(DocumentSnapshot post) 
    {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(
                  post: post,
                  schoolCode:schoolCode
                ),),
      );
    }
    return Container(
        child: FutureBuilder(
            future: getPosts(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text(
                    "Please wait...",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                );
              } 
              else {
                return Container(
                  child: new RefreshIndicator(
                    key: _refreshIndicatorkey,
                    onRefresh: _refreshLocalGallery,
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          //hoverColor: Colors.blue,
                          //isThreeLine: true
                          title: Text(
                            (snapshot.data[index].data["first name"]),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            print("pressed");
                            //readData();
                          funcButton(snapshot.data[index]);
                          },
                          subtitle: Text(
                            snapshot.data[index].data["designation"],
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_right,
                            size: 40,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            }));
  }
}

/*
ListView _buildListView(BuildContext context)
{
  return ListView.builder(
    itemCount: 10,

    
    itemBuilder: (_,index){
      return Container(
           child: ListTile(
          //hoverColor: Colors.blue,
         //isThreeLine: true,
    
            onTap: ()
            {
            print("pressed");
            readData();
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
            );
           },        

          title:Text("$schoolname",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),
          ),
          leading: CircleAvatar(      
          backgroundColor: Colors.black,
          child: Icon(Icons.person,color: Colors.white,),
          ),
          subtitle: Text("$classTeacher",style: TextStyle(color: Colors.black,),
          ),
          trailing: Icon(Icons.arrow_right,size: 40,color: Colors.black,
          ),
          ),
      );
    },
    );
}
*/

//profile

class ProfilePage extends StatefulWidget {
  String schoolCode;
  @override
  final DocumentSnapshot post;
  ProfilePage({this.post,this.schoolCode});
  MapScreenState createState() => MapScreenState(schoolCode);
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {

  String schoolCode;
  MapScreenState(this.schoolCode);
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  TextEditingController controller1;
  TextEditingController controller2;
  TextEditingController controller3;
  TextEditingController controller4;
  TextEditingController controllerd;
  TextEditingController controllera;
  TextEditingController controllerg;
  TextEditingController controllerq;
  final namecontroller = new TextEditingController();
  final namecontroller1 = new TextEditingController();
  final namecontroller2 = new TextEditingController();
  final namecontrollera = new TextEditingController();
  final namecontrollerg = new TextEditingController();
  final namecontrollerq = new TextEditingController();
  final namecontrollerd = new TextEditingController();
  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    namecontroller1.text = widget.post.data["first name"];
    controller1 = TextEditingController(text: (widget.post.data["first name"]));
    namecontroller.text = widget.post.data["email"];
    controller2 = TextEditingController(text: widget.post.data["email"]);
    namecontroller2.text = widget.post.data["mobile"];
    controller3 = TextEditingController(text: widget.post.data["mobile"]);
    namecontrollerq.text = widget.post.data["qualification"];
    controllerq =
        TextEditingController(text: widget.post.data["qualification"]);
    namecontrollera.text = widget.post.data["address"];
    controllera = TextEditingController(text: widget.post.data["address"]);
    namecontrollerg.text = widget.post.data["gender"];
    controllerg = TextEditingController(text: widget.post.data["gender"]);
    namecontrollerd.text = widget.post.data["designation"];
    controllerd = TextEditingController(text: widget.post.data["designation"]);
  }
  @override
  Widget build(BuildContext context) {
    String rt = widget.post.data["first name"];
    String rt1 = widget.post.data["email"];
    String rt2 = widget.post.data["mobile"];

    return new Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          backgroundColor: Colors.black,
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
                                                      "Enter Designation"),
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
                                                    Navigator.of(context).pop();
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
                                                    Navigator.of(context).pop();
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
                        controller: namecontrollerq,
                        decoration: InputDecoration(hintText: 'Qualification'),
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
                            widget.post.data["first name"] =
                                namecontroller1.text;
                            widget.post.data["email"] = namecontroller.text;
                            widget.post.data["mobile"] = namecontroller2.text;
                            widget.post.data["qualification"] =
                                namecontrollerq.text;
                            widget.post.data["address"] = namecontrollera.text;
                            widget.post.data["gender"] = namecontrollerg.text;
                            widget.post.data["designation"] =
                                namecontrollerd.text;
                            updateuserdata(widget.post.data["mobile"]);
                          });
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
    });
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
