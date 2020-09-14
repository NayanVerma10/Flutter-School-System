import 'dart:html' as html;
import 'dart:typed_data';
import 'package:Schools/Chat/CreateGroupUsersList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase/firebase.dart' as fb;

class UrlUtils {
  UrlUtils._();
  static void open(Uint8List data, String name,
      {DocumentReference docRef}) async {
    var ref = fb.storage().ref(name);
    await ref.put(data, fb.UploadMetadata(contentType: 'images/')).future;
    String str = (await ref.getDownloadURL()).toString();
    await docRef.updateData({'Icon': str});
    return;
  }

  static void UploadFiles(
      FilePickerResult result, CollectionReference docRef, String path,
      {String name, String fromId, bool isTeacher}) async {
    List<String> urls = List<String>();

    result.files.forEach((element) async {
      html.File file = html.File(element.bytes, element.name);

      fb.StorageReference ref =
          fb.storage().ref(path + timeToString() + ".txt");

      await ref.put(file, fb.UploadMetadata(contentType: 'type')).future;
      await docRef.document(timeToString()).setData({
        'text': element.path.split('\\').last,
        'name': name,
        'fromId': fromId,
        'type': 'File',
        'isTeacher': isTeacher,
        'url': (await ref.getDownloadURL()).toString(),
        'date': DateTime.now().toIso8601String().toString(),
      });
    });
  }
}
