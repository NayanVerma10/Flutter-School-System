import 'dart:html' as html;
import 'package:Schools/Chat/CreateGroupUsersList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:mime_type/mime_type.dart';

class UrlUtils {
  UrlUtils._();
  static void open(FilePickerResult result, String name,
      {DocumentReference docRef}) async {
    var ref = fb.storage().ref(name + result.files.first.name.split('/').last);
    String mimeType = mimeFromExtension(result.files.first.extension);
    await ref
        .put(result.files.first.bytes,
            fb.UploadMetadata(contentType: mimeType))
        .future;
    String str = (await ref.getDownloadURL()).toString();
    await docRef.updateData({'Icon': str});
    return;
  }

  static void uploadFiles(
      FilePickerResult result, CollectionReference docRef, String path,
      {String name, String fromId, bool isTeacher}) async {
    result.files.forEach((element) async {
      String mimeType = mimeFromExtension(element.extension);
      fb.StorageReference ref =
          fb.storage().ref(path + element.name.split('/').last);

      await ref.put(element.bytes, fb.UploadMetadata(contentType: mimeType)).future;
      await docRef.document(timeToString()).setData({
        'text': element.name.split('/').last,
        'name': name,
        'fromId': fromId,
        'type': 'File',
        'isTeacher': isTeacher,
        'url': (await ref.getDownloadURL()).toString(),
        'date': DateTime.now().toIso8601String().toString(),
      });
    });
  }

  static Future<void> deleteFile(String url) async {
    await fb.storage().refFromURL(url).delete();
  }
}
