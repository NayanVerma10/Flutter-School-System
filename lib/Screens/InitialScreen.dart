import 'package:flutter/material.dart';

import 'SchoolLogin.dart';
import './Icons/iconss_icons.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our App'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text('You are a',style: TextStyle(fontSize: 36),),
            SizedBox(height:20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton.icon(
                color: Colors.black,
                textColor: Colors.white,
                padding: EdgeInsets.all(50),
                onPressed: () {},
                icon: Icon(Iconss.user_graduate),
                label: Text('Student'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton.icon(
                color: Colors.black,
                textColor: Colors.white,
                padding: EdgeInsets.all(50),
                onPressed: () {},
                icon: Icon(Iconss.user_tie),
                label: Text('Teacher'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton.icon(
                color: Colors.black,
                textColor: Colors.white,
                padding: EdgeInsets.all(50),
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolLogin()));},
                icon: Icon(Icons.school),
                label: Text('School'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
