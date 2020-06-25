import 'package:flutter/material.dart';

class StdProfile extends StatefulWidget {
  final String stdName;
  StdProfile({Key key, this.stdName}) : super(key: key);
  @override
  _StdProfileState createState() => _StdProfileState(stdName);
}
class _StdProfileState extends State<StdProfile> {
  final String stdName;
_StdProfileState(this.stdName);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(stdName,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        ), 
        iconTheme: new IconThemeData(color: Colors.white), 
        backgroundColor: Colors.black,       
        
             ),
             body: Container(
               child: Center(
               child: Text('Student Profile'),
               )
             ),

      
    );
  }
}