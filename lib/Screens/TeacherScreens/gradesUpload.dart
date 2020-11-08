import 'package:Schools/plugins/url_launcher/url_launcher.dart';
import 'package:Schools/widgets/AlertDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class UploadGrades extends StatefulWidget {
  final String schoolCode, classNumber, section, subject;
  UploadGrades(this.schoolCode, this.classNumber, this.section, this.subject);

  @override
  _UploadGradesState createState() =>
      _UploadGradesState(schoolCode, classNumber, section, subject);
}

class _UploadGradesState extends State<UploadGrades> {
  TextEditingController controller;
  String schoolCode, classNumber, section, subject;
  _UploadGradesState(
      this.schoolCode, this.classNumber, this.section, this.subject);
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 28),
            children: <TextSpan>[
              TextSpan(
                  text: 'Upload',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black54)),
              TextSpan(
                  text: 'Grades',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 400),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: 'Enter test name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(style: BorderStyle.solid))),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                  child: Text('Download excel sheet for uploading Grades'),
                  onPressed: () async {
                    if (controller.text.isEmpty) {
                      print(controller.text.isEmpty);
                      print(controller.text);
                      Toast.show('Please enter test name', context);
                      return;
                    }
                    Map<String, String> mainMap = Map<String, String>();
                    await Firestore.instance
                        .collection('School')
                        .document(schoolCode)
                        .collection('Student')
                        .where('class', isEqualTo: classNumber)
                        .where('section', isEqualTo: section)
                        .where('subjects', arrayContains: subject)
                        .getDocuments()
                        .then((value) {
                      Map<String, String> map = Map<String, String>();

                      if (value.documents.isNotEmpty) {
                        value.documents.forEach((element) {
                          String std = element.data['first name'] +
                              ' ' +
                              element.data['last name'];
                          String rollno = element.data['rollno'];
                          map[rollno] = std;
                        });
                        setState(() {
                          mainMap = map;
                        });
                      }
                    });
                    if (mainMap != null && mainMap.isNotEmpty) {
                      Excel excel = Excel.createExcel();
                      Sheet sheet = excel['Sheet1'];
                      List<String> rollnos = mainMap.keys.toList();
                      mergeSort<String>(rollnos);
                      int i = 1;
                      sheet
                          .cell(CellIndex.indexByColumnRow(
                              columnIndex: 0, rowIndex: 0))
                          .value = 'Roll Numbers';
                      sheet
                          .cell(CellIndex.indexByColumnRow(
                              columnIndex: 1, rowIndex: 0))
                          .value = 'Name of the students';
                      sheet
                          .cell(CellIndex.indexByColumnRow(
                              columnIndex: 2, rowIndex: 0))
                          .value = 'Grades';
                      rollnos.forEach((element) {
                        sheet
                            .cell(CellIndex.indexByColumnRow(
                                columnIndex: 0, rowIndex: i))
                            .value = element;
                        sheet
                            .cell(CellIndex.indexByColumnRow(
                                columnIndex: 1, rowIndex: i))
                            .value = mainMap[element];
                        i++;
                      });
                      await excel.encode().then((onValue) async {
                        await UrlUtils.downloadGradesExcel(
                            onValue, controller.text, context);
                      });
                    }
                  }),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                child: Text('Upload Grades'),
                onPressed: () async {
                  try {
                    var result = await FilePicker.platform
                        .pickFiles(allowMultiple: false, withData: true);
                    print('yes');
                    if (result == null) {
                      return;
                    }
                    if (result != null &&
                        result.files[0].extension
                                .toLowerCase()
                                .compareTo('xlsx') !=
                            0) {
                      Toast.show(
                          'Please upload grades in ".xlsx" file only', context);
                      return;
                    }
                    print('yes');
                    print(result.files[0].bytes.toString());
                    Excel excel = Excel.decodeBytes(result.files[0].bytes);
                    print('yes');
                    Sheet sheet = excel[await excel.getDefaultSheet()];
                    print('yes');
                    Map<String, String> mainMap = Map<String, String>();
                    print('yes');
                    sheet.rows.sublist(1).forEach((element) {
                      mainMap[element[0].toString()] = element[2].toString();
                    });
                    print(controller.text);
                    showLoaderDialog(context, 'Uploading data....');
                    await Firestore.instance
                        .collection('School')
                        .document(schoolCode)
                        .collection('Classes')
                        .document('${classNumber}_${section}_$subject')
                        .collection('Grades')
                        .document(controller.text)
                        .setData(mainMap)
                        .whenComplete(() {
                      Toast.show('Uploaded successfully', context, duration: 3);
                    }).catchError((e) {
                      Toast.show('Some error occured. Please retry.', context);
                    });
                    Navigator.pop(context);
                  } catch (e) {
                    print(e.toString());
                    Toast.show(
                        'Some error occured. Please try again.', context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
