import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
class UrlUtils {
  UrlUtils._();
  static Future<void> open(FilePickerResult result, String name, BuildContext context, {DocumentReference docRef}) {
    throw 'Platform Not Supported';
  }
  static Future<void> uploadFiles(FilePickerResult result, CollectionReference docRef, String path, BuildContext context, {String name, String fromId, bool isTeacher}) {
    throw 'Platform Not Supported';
  }
  static Future<void> deleteFile(String url) {
    throw 'Platform Not Supported';
  }
  static Future<void> downloadAttendance(List<List<List<String>>> str, List<String> months, BuildContext context) {
    throw 'Platform Not Supported';
  }
  static Future<void> download(String url, String text, BuildContext context){
    throw 'Platform Not Supported';
  }
}
