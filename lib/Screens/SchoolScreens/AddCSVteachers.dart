import 'package:Schools/ChatNecessary/DownloadFile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../ChatNecessary/UploadFile.dart';

class AddCSVTeachers extends StatefulWidget {
  String schoolCode;
  AddCSVTeachers(this.schoolCode);
  @override
  _AddCSVTeachersState createState() => _AddCSVTeachersState(schoolCode);
}

class _AddCSVTeachersState extends State<AddCSVTeachers> {
  String schoolCode;
  _AddCSVTeachersState(this.schoolCode);

  callback() async {
    await attachment().then((files) {
      print(files);
      files.forEach((file) async {
        print('+++');
        readCSVTeacher(file, schoolCode);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Entries Using Spreadsheet'),
      ),
      body: Builder(
        builder: (context) => Stack(
          children: <Widget>[
            Container(
              height: 380,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                  gradient: LinearGradient(
                      colors: [Colors.black38, Colors.white10],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 80),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Download Spreadsheet Template tapping the below icon, fill respective columns and upload it to create Teacher's Database",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 28,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Container(
//                        height: double.infinity,
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: InkWell(
                              child: Image.asset('assets/images/sheet.png'),
                              onTap: () => downloadFile(
                                  'https://firebasestorage.googleapis.com/v0/b/aatmanirbhar-51cd2.appspot.com/o/Template%2FteacherTemplate.xlsx?alt=media&token=e307dc37-de41-4921-ad37-e92cb85a5a5f',
                                  'Teachers Database.xlsx',
                                  context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.black54,
            tooltip: 'Upload Entries to Database',
            heroTag: null,
            child: Icon(Icons.cloud_upload),
            onPressed: () {
              callback();
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
