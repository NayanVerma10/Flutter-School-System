import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
class UrlUtils {
  UrlUtils._();
  static void open(FilePickerResult result, String name, {DocumentReference docRef}) {
    throw 'Platform Not Supported';
  }
  static void uploadFiles(FilePickerResult result, CollectionReference docRef, String path, {String name, String fromId, bool isTeacher}) {
    throw 'Platform Not Supported';
  }
  static void deleteFile(String url) {
    throw 'Platform Not Supported';
  }
}
