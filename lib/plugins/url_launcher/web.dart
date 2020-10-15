import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:Schools/Chat/CreateGroupUsersList.dart';
import 'package:Schools/Screens/service.dart';
import 'package:Schools/widgets/AlertDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';

class UrlUtils {
  UrlUtils._();
  static Future showProgress(fb.UploadTask task, BuildContext context) async {
    double val = 0;
    await showDialog(
        routeSettings: RouteSettings(name: 'dialog'),
        useRootNavigator: true,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StreamBuilder(
              stream: task.onStateChanged,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                }
                if (snapshot.hasData) {
                  fb.UploadTaskSnapshot snap = snapshot.data;
                  val = snap.bytesTransferred * 100.0 / snap.totalBytes;
                  print(snap.bytesTransferred);
                  print(snap.totalBytes);
                  print(val);
                }
                return AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(
                        value: val / 100.0,
                        backgroundColor: Colors.white,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 7),
                          child: Text('${val.round().toString()} % uploaded')),
                    ],
                  ),
                );
              });
        });
  }

  static Future<String> open(
      FilePickerResult result, String name, BuildContext context,
      {DocumentReference docRef, bool isTrue = true}) async {
    var ref = fb.storage().ref(name + result.files.first.name.split('/').last);
    String mimeType = mimeFromExtension(result.files.first.extension);
    fb.UploadTask task = ref.put(
        result.files.first.bytes, fb.UploadMetadata(contentType: mimeType));
    await showProgress(task, context);

    String str = (await ref.getDownloadURL()).toString();
    if (isTrue) await docRef.updateData({'Icon': str});
    return str;
  }

  static Future<void> uploadFiles(FilePickerResult result,
      CollectionReference docRef, String path, BuildContext context,
      {String name, String fromId, bool isTeacher}) async {
    result.files.forEach((element) async {
      List<String> str = await UrlUtils.uploadFileToFirebase(element, path, context);
      await docRef.document(timeToString()).setData({
        'text': str[1],
        'name': name,
        'fromId': fromId,
        'type': 'File',
        'isTeacher': isTeacher,
        'url': str[0],
        'date': DateTime.now().toIso8601String().toString(),
      });
    });
  }

  static Future<List<String>> uploadFileToFirebase(
      PlatformFile file, String path, BuildContext context) async {
    List<String> str = List<String>();
    String mimeType = mimeFromExtension(file.extension);
    fb.StorageReference ref =
        fb.storage().ref(path + file.name.split('/').last);

    var task = ref.put(file.bytes, fb.UploadMetadata(contentType: mimeType));
    await showProgress(task, context);
    str = [(await ref.getDownloadURL()).toString(), ref.name];
    return str;
  }

  static Future<void> deleteFile(String url) async {
    await fb.storage().refFromURL(url).delete();
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
