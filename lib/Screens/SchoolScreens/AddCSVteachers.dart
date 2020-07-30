import 'package:flutter/material.dart';
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

  callback()async{
    await attachment().then((files) {
      print(files);
      files.forEach((file) async{
        print('+++');
        ReadCSVTeacher(file, schoolCode);

      });
    });
  }

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
            RaisedButton.icon(onPressed:
                callback
            , icon: Icon(Icons.file_upload), label: Text('Upload Excel')),
          ],
        ),
      ),
    );
  }
}
