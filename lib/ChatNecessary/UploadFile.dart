/*
  This file is very important 

  The contents of this files need to change in order to deploy as an app or website


*/

import 'dart:io';

import 'package:Schools/plugins/url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:universal_platform/universal_platform.dart';

//  import 'package:file_picker_web/file_picker_web.dart';
//  import 'package:http/http.dart';
//  import 'package:universal_html/html.dart';
//  import 'package:firebase/firebase.dart' as fb;

Future<List<PlatformFile>> attachment() async {
  List<PlatformFile> files = List<PlatformFile>();
  FilePickerResult result =
      await FilePicker.platform.pickFiles(allowMultiple: true);
  if (result != null) files = result.files;
  return files;
}

// Future<List<String>> uploadToFirebase(
//     String path, PlatformFile file, BuildContext context) async {
//   List<String> str = await UrlUtils.uploadFileToFirebase(file, path, context);
//   return str;
// }

//  Future<List<String>> uploadToFirebase(String path, File file) async {
//    //This is for WEB
//    fb.StorageReference storageRef = fb.storage().ref(path + file.name);
//    fb.UploadTaskSnapshot uploadTaskSnapshot = await storageRef.put(file).future;

//    Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
//    return [imageUri.toString(), file.name];
//  }

/*-------------------------------------CSV/Excel------------------------------------------------- */

/*---For Web  ------*/
//  Future<void> readCSVTeacher(File file,String schoolCode){
//    readBytes(file).then((value) => print(value.toString()));
//    FileReader();
//  }

//  Future<void> readCSVStudents (File file,String schoolCode ){

//  }

/*--For Mobile ------*/

Future<void> readCSVTeacher(PlatformFile file1, String schoolCode) async {
  var bytes;
  if (UniversalPlatform.isAndroid) {
    File file = File(file1.path);
    bytes = file.readAsBytesSync();
  } else {
    bytes = file1.bytes;
  }
  var decoder = Excel.decodeBytes(bytes);
  var sheetName = await decoder.getDefaultSheet();
  int i = 0;
  decoder.sheets[sheetName].rows.forEach((row) {
    if (i > 0) {
      print(row.toString());

      String firstName = row[0].toString();
      String lastName = row[1].toString();
      String mobile = row[2].toString();
      String address = row[3].toString();
      String designation = row[4].toString();
      String dob = row[5].toString();
      String email = row[6].toString();
      String gender = row[7].toString();
      String location = row[8].toString();
      String password = row[9].toString();
      String qualification = row[10].toString();
      print(schoolCode);

      print(
          '$firstName, $lastName, $mobile,$address,$designation,$dob,$email,$gender,$location,$password,$qualification');
      FirebaseFirestore.instance
          .collection("School")
          .doc(schoolCode)
          .collection("Teachers")
          .doc()
          .set({
        "first name": "$firstName",
        "last name": "$lastName",
        "address": "$address",
        "designation": "$designation",
        "dob": "$dob",
        "email": "$email",
        "gender": "$gender",
        "mobile": "$mobile",
        "qualification": "$qualification",
        "location": "$location",
        "password": "$password"
      },SetOptions(merge: true)).then((_) {
        print("success!");
      }, onError: (e) {
        print(e.toString());
      });
    }
    i++;
  });
}

Future<void> readCSVStudents(PlatformFile file1, String schoolCode) async {
  var bytes;
  if (UniversalPlatform.isAndroid) {
    File file = File(file1.path);
    bytes = file.readAsBytesSync();
  } else {
    bytes = file1.bytes;
  }
  var decoder = Excel.decodeBytes(bytes);
  var sheetName = await decoder.getDefaultSheet();
  int i = 0;
  decoder.sheets[sheetName].rows.forEach((row) {
    if (i > 0) {
      String firstName = row[0].toString();
      String lastName = row[1].toString();
      String address = row[2].toString();
      String classNo = row[3].toString();
      String section = row[4].toString();
      String rollNo = row[5].toString();
      String email = row[6].toString();
      String dob = row[7].toString();
      String gender = row[8].toString();
      String fathersName = row[9].toString();
      String mothersName = row[10].toString();
      String mobile = row[11].toString();
      String password = row[12].toString();

      print(
          '$firstName, $lastName,$address, $classNo,$section,$rollNo,$email,$dob,$gender,$fathersName,$mothersName,$mobile,$password');
      FirebaseFirestore.instance
          .collection("Schools")
          .doc(schoolCode)
          .collection("Students")
          .doc(mobile)
          .set({
        "first name": "$firstName",
        "last name": "$lastName",
        "address": "$address",
        "class": "$classNo",
        "section": "$section",
        "roll no": "$rollNo",
        "dob": "$dob",
        "email": "$email",
        "gender": "$gender",
        "father's name": "$fathersName",
        "mother's name": "$mothersName",
        "mobile": "$mobile",
        "password": "$password"
      },SetOptions(merge: true)).then((_) {
        print("success!");
      }, onError: (e) {
        print(e.toString());
      });
    }
    i++;
  });
}
