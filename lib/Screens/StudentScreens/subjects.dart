import 'package:flutter/material.dart';
import '../icons/iconssss_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './subjectDetails.dart';

class Subjects extends StatefulWidget {
  String schoolCode,studentId;
  Subjects(this.schoolCode,this.studentId);
  @override
  _SubjectsState createState() => _SubjectsState(schoolCode,studentId);
}
 

class _SubjectsState extends State<Subjects> {
  String schoolCode,studentId;
  _SubjectsState(this.schoolCode,this.studentId);
  
  String classNumber,section;
  bool gotData=false;
  List subjects= [];

  loadData(){
    Firestore.instance.collection('School').document(schoolCode).collection('Student').document(studentId).get()
    .then((value){
      setState(() {
        print(value.data);
        classNumber=value.data['class'];
        section=value.data['section'];
        if(value.data['subjects']!=null)
          subjects= value.data['subjects'];
        gotData=true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }
  

  @override
  Widget build(BuildContext context) {
    if(!gotData)
      return Center(child: CircularProgressIndicator());
    return ListView.builder(
        //itemCount: 10,s
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return Card( //                           <-- Card widget
            child: ListTile(              
              title: Text(subjects[index],
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
                      MaterialPageRoute(builder: (context) => SubjectDetails(subjName: subjects[index])));
                  });
                },
            ),
          );
        }, 
    
    );
  }
}
