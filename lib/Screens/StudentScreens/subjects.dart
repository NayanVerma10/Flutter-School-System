import 'package:flutter/material.dart';
import '../icons/iconssss_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './subjectDetails.dart';

class Subjects extends StatefulWidget {
  @override
  _SubjectsState createState() => _SubjectsState();
}
 
//String className='X-A';

class _SubjectsState extends State<Subjects> {
  

  final subjList = [
      'Maths', 'Science', 'Hindi', 'English','Social Science'
  ];
  //final databaseReference = Firestore.instance;
  
 

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        //itemCount: 10,s
        itemCount: subjList.length,
        itemBuilder: (context, index) {
          return Card( //                           <-- Card widget
            child: ListTile(              
              title: Text(subjList[index],
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
              ),
              leading: Icon(Iconssss.doc_text,
              color: Colors.black,
              size: 20,
              ),
              trailing: Icon(Icons.keyboard_arrow_right,
              color: Colors.black,
              ),
              onTap: () { //                                  <-- onTap
                  setState(() {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SubjectDetails(subjName: subjList[index])));
                  });
                },
            //  leading: Icon(icons[index]),
             // title: Text(titles[index]),
            ),
          );
        }, 
    
    );
  }
}
