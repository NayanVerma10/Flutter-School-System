import 'package:flutter/material.dart';
import './classDetails.dart';
import '../Icons/iconssss_icons.dart';
import './stdProfile.dart';
import '../Icons/iconss_icons.dart';
import './setBehavior.dart';
import 'dart:math' as math;

class Behavior extends StatefulWidget {
  @override
  _BehaviorState createState() => _BehaviorState();
}
 
//String className='X-A';

class _BehaviorState extends State<Behavior> {

  final stdName = [
      'Lee Joon Gi', 'Cha Eun Woo', 'Lee Sung Kyung', 'Yang Ki Jong', 'Jang Ki Yong',
      'Kim Tae Hyung', 'Kim Seo Woo', 'Jung Hae In', 'Bae Suzy', 'Chae Soo Bin', 'Jung Jin Yeong', 'Jung Ji Hyun'
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: ListView.builder(
        //itemCount: 10,
        itemCount: stdName.length,
        itemBuilder: (context, index) {
         
          return Card( //                           <-- Card widget
            child: ListTile(              
              title: Text(stdName[index],
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
              ),
              leading: Icon(Iconss.user_graduate,
              color: Colors.black,
              size: 20,
              ),
              trailing: Icon(Icons.keyboard_arrow_right,
              color: Colors.black,
              ),
              onTap: () { //                                  <-- onTap
                  setState(() {
                    
                    // Navigator.push(context,
                    //   MaterialPageRoute(builder: (context) => SetBehavior()));
                    showDialog(
                context: context,
                builder: (context) {                                     
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    elevation: 16,  
                     child: SingleChildScrollView(                 
                    child: Container(
                      height: 500.0,
                      width: 700.0,          
                        child: 
                              SetBehavior()
                             // ])
                    )
                    )
                  );
                }
                    );
                      });
                  }
              
            //  leading: Icon(icons[index]),
             // title: Text(titles[index]),
            ),
          );
        },
      )
    );
  }
}
