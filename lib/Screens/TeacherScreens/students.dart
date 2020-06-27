import 'package:flutter/material.dart';
import './classDetails.dart';
import '../Icons/iconssss_icons.dart';
import './stdProfile.dart';
import '../Icons/iconss_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Students extends StatefulWidget {
  String className, schoolCode, teachersId, classNumber, section, subject;
  Students(this.className, this.schoolCode, this.teachersId, this.classNumber,
      this.section, this.subject);
  @override
  _StudentsState createState() => _StudentsState(className, schoolCode, teachersId, classNumber, section, subject);
}
 
//String className='X-A';

class _StudentsState extends State<Students> {
  String className, schoolCode, teachersId, classNumber, section, subject;
  List stdName = [];

  _StudentsState(this.className, this.schoolCode, this.teachersId, this.classNumber,
      this.section, this.subject);

  void loadData() {
    Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Student')
        .where('class', isEqualTo: classNumber)
        .where('section', isEqualTo: section)
        .where('subjects', arrayContains: subject)
        .getDocuments()
        .then((value) {
      List<String> temp = [];
      if (value.documents.isNotEmpty) {
        value.documents.forEach((element) {
          String std = 
                  element.data['first name'] + ' ' + element.data['last name'];

          temp.add(std);
        });
        setState(() {
          stdName = temp;
        });
      } 
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }


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
