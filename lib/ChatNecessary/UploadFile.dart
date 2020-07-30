/*
  This file is very important 

  The contents of this files need to change in order to deploy as an app or website


*/

import 'package:file_picker/file_picker.dart';
import 'dart:io' show File;
import 'package:firebase_storage/firebase_storage.dart';

// import 'package:file_picker_web/file_picker_web.dart';
// import 'package:universal_html/html.dart' show File;
// import 'package:firebase/firebase.dart' as fb;


Future<List<File>> attachment() async {
  List<File> files;
  files = await FilePicker.getMultiFile();
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

// Future<List<String>> uploadToFirebase(String path, File file) async {
//   //This is for WEB
//   fb.StorageReference storageRef = fb.storage().ref(path + file.name);
//   fb.UploadTaskSnapshot uploadTaskSnapshot = await storageRef.put(file).future;

//   Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
//   return [imageUri.toString(), file.name];
// }
