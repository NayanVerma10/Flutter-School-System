/*
  This file is very important 

  The contents of this files need to change in order to deploy as an app or website


*/

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

//  import 'package:file_picker_web/file_picker_web.dart';
//  import 'package:http/http.dart';
//  import 'package:universal_html/html.dart';
//  import 'package:firebase/firebase.dart' as fb;

Future<List<File>> attachment() async {
  List<File> files;
  files = (await FilePicker.platform.pickFiles(allowMultiple: true)).files.cast();
  return files;
}

Future<List<String>> uploadToFirebase(String path, File file) async {
  // This is for MOBILE
  String downloadURL;
  String fileName;

  StorageReference storageRef =
      FirebaseStorage.instance.ref().child(path + file.path.split('/').last);
  final StorageUploadTask uploadTask = storageRef.putFile(
    file,
    StorageMetadata(
      contentType: 'type',
    ),
  );
  await uploadTask.onComplete.then((value) async {
    downloadURL = (await value.ref.getDownloadURL()).toString();
    fileName = await value.ref.getName();
  });
  print(downloadURL);
  return [downloadURL, fileName];
}

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

Future<void> readCSVTeacher(File file, String schoolCode) async {
  Stream<List> inputStream = file.openRead();

  inputStream
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(new LineSplitter()) // Convert stream to individual lines.
      .listen((String line) {
    // Process results.

    List row = line.split(','); // split by comma
    print(row);

    String firstName = row[0];
    String lastName = row[1];
    String mobile = row[2];
    String address = row[3];
    String designation = row[4];
    String dob = row[5];
    String email = row[6];
    String gender = row[7];
    String location = row[8];
    String password = row[9];
    String qualification = row[10];
    print(schoolCode);

    print(
        '$firstName, $lastName, $mobile,$address,$designation,$dob,$email,$gender,$location,$password,$qualification');
    Firestore.instance
        .collection("School")
        .document(schoolCode)
        .collection("Teachers")
        .document()
        .setData({
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
    }, merge: true).then((_) {
      print("success!");
    });
  }, onDone: () {
    print('File is now closed.');
  }, onError: (e) {
    print(e.toString());
  });
}

Future<void> readCSVStudents(File file, String schoolCode) async {
  Stream<List> inputStream = file.openRead();

  inputStream
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(new LineSplitter()) // Convert stream to individual lines.
      .listen((String line) {
    // Process results.

    List row = line.split(','); // split by comma

    String firstName = row[0];
    String lastName = row[1];
    String address = row[2];
    String classNo = row[3];
    String section = row[4];
    String rollNo = row[5];
    String email = row[6];
    String dob = row[7];
    String gender = row[8];
    String fathersName = row[9];
    String mothersName = row[10];
    String mobile = row[11];
    String password = row[12];

    print(
        '$firstName, $lastName,$address, $classNo,$section,$rollNo,$email,$dob,$gender,$fathersName,$mothersName,$mobile,$password');
    Firestore.instance
        .collection("Schools")
        .document(schoolCode)
        .collection("Students")
        .document(mobile)
        .setData({
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
    }, merge: true).then((_) {
      print("success!");
    });
  }, onDone: () {
    print('File is now closed.');
  }, onError: (e) {
    print(e.toString());
  });
}
