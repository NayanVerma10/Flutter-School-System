import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mime_type/mime_type.dart';
import 'package:Schools/Chat/CreateGroupUsersList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

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

  static Future<void> downloadAttendance(List<List<List<String>>> str,
      List<String> months, BuildContext context) async {
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
    final path = await getExternalStorageDirectory();
    Directory dir =
        await Directory(path.path + '/Attendance').create(recursive: true);
    for (int i = 0; i < s.length; i++) {
      if (s[i].isNotEmpty) {
        File file = File(dir.path + '/${months.first}.csv');
        months.removeAt(0);
        await file.writeAsString(s[i]);
      }
    }
    Toast.show('Saved at ${dir.path}', context, duration: 2);
  }

  static void download(String url, String text, BuildContext context) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    try {
      await FlutterDownloader.initialize();
    } catch (e) {}
    final dir = await getExternalStorageDirectory();
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir.path,
      fileName: text,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }
}
