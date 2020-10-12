import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:Schools/Chat/CreateGroupUsersList.dart';
import 'package:Schools/Screens/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';

class UrlUtils {
  UrlUtils._();
  static void open(FilePickerResult result, String name,
      {DocumentReference docRef}) async {
    var ref = fb.storage().ref(name + result.files.first.name.split('/').last);
    String mimeType = mimeFromExtension(result.files.first.extension);
    await ref
        .put(result.files.first.bytes, fb.UploadMetadata(contentType: mimeType))
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

      await ref
          .put(element.bytes, fb.UploadMetadata(contentType: mimeType))
          .future;
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

  static Future<void> downloadAttendance(
      List<List<List<String>>> str, List<String> months, BuildContext context) async {
    List<String> s = List<String>();
    int i = 0;
    str.forEach((str1) {
      s.add('');
      str1.forEach((element) {
        element.forEach((data) {
          s[i] = s[i] + data + ", ";
        });
        s[i] += "\n";
      });
      i++;
    });
    for (int i = 0; i < s.length; i++) {
      if (s[i].isNotEmpty) {
        var blob = html.Blob([s[i]], 'text/csv', 'native');

        var anchorElement = html.AnchorElement(
          href: html.Url.createObjectUrlFromBlob(blob).toString(),
        )
          ..setAttribute("download", "${months.first}.csv")
          ..click();
        months.removeAt(0);
      }
    }
  }

  static Future<void> download(String url, String text, BuildContext context) {
    html.AnchorElement anchorElement = new html.AnchorElement(href: url)
      ..setAttribute("download", text)
      ..target = '_blank'
      ..click();
  }
}
