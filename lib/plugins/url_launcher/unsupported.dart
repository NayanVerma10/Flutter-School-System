import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UrlUtils {
  UrlUtils._();
  // static Future<void> open(
  //     FilePickerResult result, String name, BuildContext context,
  //     {DocumentReference docRef, bool isTrue = false}) {
  //   throw 'Platform Not Supported';
  // }

  // static Future<void> uploadFiles(FilePickerResult result,
  //     CollectionReference docRef, String path, BuildContext context,
  //     {String name, String fromId, bool isTeacher}) {
  //   throw 'Platform Not Supported';
  // }

  static Future<List<String>> uploadFileToFirebase(
      PlatformFile file, String path, BuildContext context, CollectionReference cr,
      Map<String, dynamic> m,
      String urlKey,
      String nameKey, {
    CollectionReference cr1,
    Map<String, dynamic> m1,
    String urlKey1,
    String nameKey1,
    DocumentReference dr2,
    Map<String, dynamic> m2,
    String urlKey2,
    String nameKey2,
    DocumentReference dr3,
    Map<String, dynamic> m3,
    String urlKey3,
    String nameKey3,
  }) {
    throw 'Platform Not Supported';
  }

  static Future<void> deleteFile(String url) {
    throw 'Platform Not Supported';
  }

  static Future<void> downloadAttendance(
      List<List<List<String>>> str, List<String> months, BuildContext context) {
    throw 'Platform Not Supported';
  }

  static Future<void> download(String url, String text, BuildContext context) {
    throw 'Platform Not Supported';
  }

  static Future<void> downloadGradesExcel(List<int> value, String name, BuildContext context) {
    throw 'Platform Not Supported';
  }
}