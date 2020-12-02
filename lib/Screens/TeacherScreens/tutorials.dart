import 'package:Schools/Chat/CreateGroupUsersList.dart';
import 'package:Schools/Screens/StudentScreens/tutorials.dart';
import 'package:Schools/plugins/url_launcher/url_launcher.dart';
import 'package:Schools/widgets/ClassTutorial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:toast/toast.dart';

class TutorialUpload extends StatefulWidget {
  final String schoolCode,
      classNumber,
      section,
      subject,
      name,
      rollno,
      id,
      docname;
  final bool isTeacher;
  TutorialUpload(this.schoolCode, this.classNumber, this.section, this.subject,
      this.isTeacher,
      {this.rollno, this.name, this.id, this.docname});
  @override
  _TutorialUploadState createState() => new _TutorialUploadState(
      schoolCode, classNumber, section, subject, isTeacher,
      id: id, name: name, rollno: rollno, docname: docname);
}

class _TutorialUploadState extends State<TutorialUpload> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String schoolCode,
      classNumber,
      section,
      subject,
      name,
      rollno,
      id,
      docname;
  final bool isTeacher;
  AppBar a1, a2;
  FilePickerResult result;
  _TutorialUploadState(this.schoolCode, this.classNumber, this.section,
      this.subject, this.isTeacher,
      {this.rollno, this.name, this.id, this.docname});
  Map<PlatformFile, bool> showPath;
  List<Widget> list;
  List<PlatformFile> files;
  bool upload = false;

  @override
  void initState() {
    super.initState();
    print("$rollno#$name#$id");
    result = FilePickerResult([]);
    showPath = Map<PlatformFile, bool>();
    list = List<Widget>();
    files = List<PlatformFile>();
    a1 = AppBar(
      title: ClassTutorial(
        title1: 'Class',
        title2: 'Tutorials',
        size: 28,
        c1: Colors.black54,
        c2: Colors.black87,
      ),
      centerTitle: true,
      brightness: Brightness.light,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      //brightness: Brightness.li,
    );
    a2 = AppBar(
      title: Text("Upload Files"),
    );
  }

  @override
  Widget build(BuildContext context) {
    list = List<Widget>();
    list.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconButton(
            tooltip: 'Select files',
            iconSize: 80,
            icon: Icon(
              Icons.folder_open_rounded,
              size: 80,
              color: Colors.black,
            ),
            onPressed: () async {
              final res = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                withData: true,
              );
              if (res != null) {
                res.files.forEach((element) {
                  showPath[element] = false;
                  files.add(element);
                });
                setState(() {
                  result = res;
                });
              }
            },
          ),
          new IconButton(
            iconSize: 80,
            icon: Icon(
              Icons.upload_file,
              size: 80,
            ),
            color: Colors.black,
            tooltip: "Upload",
            onPressed: () async {
              if (result != null) {
                files.forEach((element) async {
                  if (isTeacher) {
                    await UrlUtils.uploadFileToFirebase(
                        element,
                        "$schoolCode/classes/$classNumber-$section-$subject/tutorials/",
                        context,
                        FirebaseFirestore.instance
                            .collection('School')
                            .doc(schoolCode)
                            .collection('Classes')
                            .doc(classNumber + '_' + section + '_' + subject)
                            .collection('Tutorials'),
                        {'size': element.size.toString()},
                        'url',
                        'name');
                  } else {
                    await FirebaseFirestore.instance
                        .collection('School')
                        .doc(schoolCode)
                        .collection('Classes')
                        .doc(classNumber + '_' + section + '_' + subject)
                        .collection('Tutorials')
                        .doc(docname)
                        .collection('Responses')
                        .doc("$rollno#$name#$id")
                        .set({'name': name, 'rollno':rollno,'id':id});
                    await UrlUtils.uploadFileToFirebase(
                      element,
                      "$schoolCode/classes/$classNumber-$section-$subject/tutorials/$rollno#$name#$id/",
                      context,
                      FirebaseFirestore.instance
                          .collection('School')
                          .doc(schoolCode)
                          .collection('Classes')
                          .doc(classNumber + '_' + section + '_' + subject)
                          .collection('Tutorials')
                          .doc(docname)
                          .collection('Responses')
                          .doc("$rollno#$name#$id")
                          .collection('Files'),
                      {"size": element.size},
                      'url',
                      'name',
                    );
                  }
                });
              } else {
                Toast.show('Select at least one file before uploading', context,
                    duration: 3);
              }
            },
          ),
          isTeacher
              ? new IconButton(
                  iconSize: 80,
                  icon: Icon(
                    Icons.history,
                    size: 80,
                  ),
                  color: Colors.black,
                  tooltip: "History",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentTutorial(
                                  schoolCode,
                                  classNumber,
                                  section,
                                  subject,
                                  optional: true,
                                )));
                  })
              : SizedBox(),
        ],
      ),
    );
    if (result.count > 0 && list.length < 3) {
      list.add(ListTile(
          title: Column(
        children: [
          Text(
            'Details of picked files :',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      )));
    }
    files.forEach((element) {
      list.add(Card(
        child: ListTile(
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                files.remove(element);
              });
            },
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClassTutorial(
                title1: 'Name : ',
                title2: element.name.split('\\').last,
                size: 14,
                weight: FontWeight.normal,
                c1: Colors.black,
                c2: Colors.blue,
              ),
              ClassTutorial(
                title1: 'Size : ',
                title2: element.size.toString() + ' KB',
                size: 14,
                weight: FontWeight.normal,
                c1: Colors.black,
                c2: Colors.blue,
              ),
              kIsWeb
                  ? SizedBox()
                  : showPath[element]
                      ? ClassTutorial(
                          title1: 'Path : ',
                          title2: element.path,
                          size: 14,
                          weight: FontWeight.normal,
                          c1: Colors.black,
                          c2: Colors.blue,
                        )
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              showPath[element] = (!showPath[element]);
                            });
                          },
                          child: Text(
                            'Show Path',
                            style: TextStyle(
                                color: Colors.blue[800], fontSize: 14),
                          ),
                        ),
            ],
          ),
        ),
      ));
    });
    result = FilePickerResult([]);
    print(list.length);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: isTeacher
            ? a1
            : AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  "Upload Response",
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
              ),
        key: _scaffoldKey,
        body: new Center(
            child: new Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: new SingleChildScrollView(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center, children: list),
          ),
        )),
      ),
    );
  }
}
