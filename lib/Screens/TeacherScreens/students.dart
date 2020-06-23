import 'package:flutter/material.dart';
import './classDetails.dart';
import '../Icons/iconssss_icons.dart';
import './stdProfile.dart';
import '../Icons/iconss_icons.dart';

class Students extends StatefulWidget {
  @override
  _StudentsState createState() => _StudentsState();
}
 
//String className='X-A';

class _StudentsState extends State<Students> {

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
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StdProfile(stdName: stdName[index])));
                  });
                },
            //  leading: Icon(icons[index]),
             // title: Text(titles[index]),
            ),
          );
        },
      )
    );
  }
}
