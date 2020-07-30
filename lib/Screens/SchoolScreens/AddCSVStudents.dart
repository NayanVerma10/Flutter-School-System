import 'package:flutter/material.dart';
import '../../ChatNecessary/UploadFile.dart';



class AddCSVStudents extends StatefulWidget {
  String schoolCode;
  AddCSVStudents(this.schoolCode);
  @override
  _AddCSVStudentsState createState() => _AddCSVStudentsState(schoolCode);
}

class _AddCSVStudentsState extends State<AddCSVStudents> {
  String schoolCode;

  _AddCSVStudentsState(this.schoolCode);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Excel'),
      ),
      body: Container(
        child: Column(
          children: [
            Text('TODO Sample Excel'),
            RaisedButton.icon(onPressed: (){
              attachment().then((files) {
                files.forEach((file) {
                  ReadCSVStudents(file, schoolCode);

                });
              });
            }, icon: Icon(Icons.file_upload), label: Text('Upload Excel')),
          ],
        ),
      ),
    );
  }
}
