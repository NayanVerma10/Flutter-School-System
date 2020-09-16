import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'package:Schools/Chat/CreateGroupUsersList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UrlUtils {
  UrlUtils._();
  static void open(FilePickerResult result, String name,
      {DocumentReference docRef}) async {
    File file = File(result.files.first.path);
    String mimeType = mimeFromExtension(result.files.first.extension);
    // print("mime \n"+mimeType);
    // print("ext\n"+result.files.first.extension);
    // print("name\n"+result.files.first.name);
    // print("path\n"+result.files.first.path);
    StorageReference ref =
        FirebaseStorage.instance.ref().child(name + result.files.first.name);

    await ref.putFile(file, StorageMetadata(contentType: mimeType)).onComplete;
    String str = (await ref.getDownloadURL()).toString();
    await docRef.updateData({'Icon': str});
    return;
  }

  static void uploadFiles(
      FilePickerResult result, CollectionReference docRef, String path,
      {String name, String fromId, bool isTeacher}) async {
    result.files.forEach((element) async {
      File file = File(element.path);
      String mimeType = mimeFromExtension(element.extension);
      StorageReference ref =
          FirebaseStorage.instance.ref().child(path + element.name);

      await ref
          .putFile(file, StorageMetadata(contentType: mimeType))
          .onComplete;
      await docRef.document(timeToString()).setData({
        'text': element.name,
        'name': name,
        'fromId': fromId,
        'type': 'File',
        'isTeacher': isTeacher,
        'url': (await ref.getDownloadURL()).toString(),
        'date': DateTime.now().toIso8601String().toString(),
      });
    });
  }

  static void deleteFile(String url) {
    FirebaseStorage.instance.getReferenceFromUrl(url).then((value) async {
      //print(value.toString());
      await value.delete();
    });
  }
}
