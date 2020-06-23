import 'package:flutter/material.dart';
import 'package:teacher_dashboard/iconssss_icons.dart';
import 'dart:math' as math;


class SetBehavior extends StatefulWidget {
  //final String stdName;
 // SetBehavior({Key key, this.stdName}) : super(key: key);
  @override
  _SetBehaviorState createState() => _SetBehaviorState();
}
class _SetBehaviorState extends State<SetBehavior> {
 // final String stdName;
  //Color _iconColor = Colors.grey;
//_SetBehaviorState(this.stdName);
int _value = 0;
String behavior='';
String behavDesc='';
String date=new DateTime.now().toString();
TextEditingController txtcontroller = new TextEditingController();
List<String> behav=['','',''];

  @override
  Widget build(BuildContext context) {
    return  Column(   
            children: <Widget>[         
                 SizedBox(height: 20,),  
                 Center(
                   child: Text('BEHAVIOR',
                   style: TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: 20
                   ),
                   ),
                   ),  
                    SizedBox(height: 30),  
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                 size: 40,
                 color: _value == 1 ? Colors.green : Colors.grey),
                            onPressed: () {
                    setState(() {
                    _value = 1;
                     behavior='Good';
                     print(behavior);
                     behav[0]=behavior;
                  });
                },
              ),),
              SizedBox(width: 10,),
               Container(   
                  padding: EdgeInsets.symmetric(),
                 // color: Colors.blue, 
                  width: 60,           
                  child:Transform(
                 alignment: Alignment.center,
                     transform: Matrix4.rotationY(math.pi),
             child: IconButton(
                 icon: Icon(Iconssss.thumbs_down, 
                 size: 40,
                 color: _value == 2 ? Colors.red : Colors.grey,
                 ),
                    onPressed: () {
                    setState(() {                      
                    _value = 2;
                    behavior='Bad';
                    print(behavior);
                     behav[0]=behavior;
                  });
                },
              ))),
              
                  ]
                 ),
                 SizedBox(height: 50,),
                 Container(
                   width: 250,
                 child: TextField(
                   maxLines: 10,
                   controller: txtcontroller,
                  
                    decoration: InputDecoration(
            border: OutlineInputBorder()
          )
        ),),
        SizedBox(height: 20,),
        FlatButton(
          disabledColor: Colors.black,
          disabledTextColor: Colors.white,
          color: Colors.black,
          child: Text('Save',
          style: TextStyle(
            color: Colors.white
          ),
          ),
          onPressed: (){
             behavDesc=txtcontroller.text;
             behav[1]=behavDesc;
             print(behavior);
            print(behavDesc);             
             print(date);
             behav[2]=date;
            // behav.add(date);
             print(behav);
          })
               ],
    
    );
  }
}