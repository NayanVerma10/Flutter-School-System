import 'package:flutter/material.dart';
import './classDetails.dart';
import '../Icons/iconssss_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Classes extends StatefulWidget {
  String schoolCode, teachersId;
  Classes(this.schoolCode, this.teachersId);
  @override
  _ClassesState createState() => _ClassesState(schoolCode, teachersId);
}

//String className='X-A';

class _ClassesState extends State<Classes> {
  String schoolCode, teachersId;
  _ClassesState(this.schoolCode, this.teachersId);

  List<dynamic> classList = [];
  List<int> noOfStdInClass = [];
  bool hasClass = true;

  void loadData() async {
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Teachers')
        .document(teachersId)
        .get()
        .then((value) async {
      List<dynamic> classes = value.data['classes'];
      await Future.forEach(classes ,(element) async {
        int numberOfStudents = await loadNumberOfStudents(
            element['Class'], element['Section'], element['Subject']);
            noOfStdInClass.add(numberOfStudents);
        return true;
      });
      return classes;
      
    }).then((classes) {
      if(noOfStdInClass.length==classes.length)
      setState(() {
        if (classes != null && classes.isNotEmpty) {
          classList = classes;
        } else
          hasClass = false;
      });
    });
  }

  Future<int> loadNumberOfStudents(
      String classno, String section, String subject) async {
    int no;
    await Firestore.instance
        .collection('School')
        .document(schoolCode)
        .collection('Student')
        .where('class', isEqualTo: classno)
        .where('section', isEqualTo: section)
        .where('subjects', arrayContains: subject)
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) no = docs.documents.length;
      print(no);
    });
    return no;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  //final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    if (classList.isNotEmpty && hasClass)
      return ListView.builder(
        scrollDirection: Axis.vertical,
        //itemCount: 10,s
        itemCount: classList.length,
        itemBuilder: (context, index) {
          int noOfStd = noOfStdInClass!=null ?noOfStdInClass[index]: 0;
          String className = classList[index]['Class'] +
              ' ' +
              classList[index]['Section'] +
              ' ' +
              classList[index]['Subject'];
          return Container(
              color: Colors.grey[200],
              height: 90,
              child: Card(
                child: Container(
                    margin: EdgeInsets.only(top: 20),
                    // color: Colors.blue,
                    alignment: Alignment.center,
                    child: ListTile(
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              className,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Number of students: $noOfStd',
                              style: TextStyle(fontSize: 14),
                            ),
                          ]),
                      leading: Container(
                          margin: EdgeInsets.only(bottom: 26, left: 6),
                          child: Icon(
                            Iconssss.doc_text,
                            color: Colors.black,
                            size: 20,
                          )),
                      trailing: Container(
                          margin: EdgeInsets.only(bottom: 26, left: 6),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black,
                          )),
                      onTap: () {
                        //                                  <-- onTap
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ClassDetails(
                                        className: className,
                                        classNumber: classList[index]['Class'],
                                        schoolCode: schoolCode,
                                        teachersId: teachersId,
                                        section: classList[index]['Section'],
                                        subject: classList[index]['Subject'],
                                      )));
                        });
                      },
                      //  leading: Icon(icons[index]),
                      // title: Text(titles[index]),
                    )),
              ));
        },
      );
    else if (!hasClass)
      return Text('');
    else
      return Center(child: CircularProgressIndicator());
  }
}
