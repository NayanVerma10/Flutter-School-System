import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Icons/iconssss_icons.dart';
import 'dart:math' as math;

class SetBehavior extends StatefulWidget {
  String schoolCode, studentId, className;
  SetBehavior(this.schoolCode, this.studentId, this.className);

  @override
  _SetBehaviorState createState() =>
      _SetBehaviorState(schoolCode, studentId, className);
}

class _SetBehaviorState extends State<SetBehavior> {
  String schoolCode, studentId, className;
  _SetBehaviorState(this.schoolCode, this.studentId, this.className);

  int _value = 0;
  String behavior = '';
  String behavDesc = '';
  TextEditingController txtcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            'BEHAVIOR',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          // color: Colors.cyan,
          //  height: 100,
          //  width: MediaQuery.of(context).size.width,
          //  padding: EdgeInsets.symmetric(),

          Container(
            padding: EdgeInsets.symmetric(),
            // color: Colors.blue,
            width: 60,
            child: IconButton(
              icon: Icon(Iconssss.thumbs_up,
                  size: 40, color: _value == 1 ? Colors.green : Colors.grey),
              onPressed: () {
                setState(() {
                  _value = 1;
                  behavior = 'Good';
                  print(behavior);
                });
              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
              padding: EdgeInsets.symmetric(),
              // color: Colors.blue,
              width: 60,
              child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: IconButton(
                    icon: Icon(
                      Iconssss.thumbs_down,
                      size: 40,
                      color: _value == 2 ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _value = 2;
                        behavior = 'Bad';
                        print(behavior);
                      });
                    },
                  ))),
        ]),
        SizedBox(
          height: 50,
        ),
        Container(
          width: 250,
          child: TextField(
              maxLines: 10,
              controller: txtcontroller,
              decoration: InputDecoration(border: OutlineInputBorder())),
        ),
        SizedBox(
          height: 20,
        ),
        FlatButton(
            disabledColor: Colors.black,
            disabledTextColor: Colors.white,
            color: Colors.black,
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              behavDesc = txtcontroller.text;
              print(behavior);
              print(behavDesc);
              if (behavior.isEmpty)
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      final curvedValue =
                          Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: AlertDialog(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0)),
                            
                            title: Row(children:[Icon(Icons.warning,color: Colors.red,),Expanded(child: Text('Warning!!',))]),
                            content: Text('Please set a behavior'),
                          ),
                        ),
                      );
                    },
                    transitionDuration: Duration(milliseconds: 200),
                    barrierDismissible: true,
                    barrierLabel: '',
                    context: context,
                    pageBuilder: (context, animation1, animation2) {});
              else {
                Firestore.instance
                    .collection('School')
                    .document(schoolCode)
                    .collection('Student')
                    .document(studentId)
                    .setData(
                  {
                    "Behavior in class " + className: {
                      "Behavior": behavior,
                      "Discription": behavDesc,
                      "Time": DateTime.now()
                    },
                  },
                  merge: true,
                );
                Navigator.pop(context);
              }
            })
      ],
    );
  }
}
