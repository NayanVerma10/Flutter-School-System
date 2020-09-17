import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UrlUtils {
  UrlUtils._();
  static void open(Uint8List data, String name,
      {DocumentReference docRef}) async {
    var ref = FirebaseStorage.instance.ref().child(name);
    await ref.putData(data, StorageMetadata(contentType: 'images/')).onComplete;
    String str = (await ref.getDownloadURL()).toString();
    await docRef.updateData({'Icon': str});
    return;
  }
  static void UploadFiles(
      FilePickerResult result, CollectionReference docRef, String path,
      {String name, String fromId, bool isTeacher}) async {
    print("\nyes1\nyes1\nyes1\nyes1\n");
    
  }
}
