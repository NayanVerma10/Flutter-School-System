import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
class UrlUtils {
  UrlUtils._();
  static void open(Uint8List url, String name, {DocumentReference docRef}) {
    throw 'Platform Not Supported';
  }
  static void UploadFiles(FilePickerResult result, CollectionReference docRef, String path, {String name, String fromId, bool isTeacher}) {
    throw 'Platform Not Supported';
  }
}
