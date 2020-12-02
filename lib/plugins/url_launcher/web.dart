import 'dart:convert';
import 'dart:html' as html;
// import 'package:bot_toast/bot_toast.dart';
import 'package:Schools/Chat/CreateGroupUsersList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pl_notifications/pl_notifications.dart';

int x = 0;

class UrlUtils {
  // UrlUtils._();

  static Future<void> uploadFileToFirebase(
    PlatformFile file,
    String path,
    BuildContext context,
    CollectionReference cr,
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
  }) async {
    x++;
    String name = file.name.split('/').last;
    var ref = fb.storage().ref(path + name);
    String mimeType = mimeFromExtension(file.extension);
    fb.UploadTask task =
        ref.put(file.bytes, fb.UploadMetadata(contentType: mimeType));
    double val = 0.0;
    task.onStateChanged.listen((event) async {
      print(event.state.toString());
      if (event.state == fb.TaskState.RUNNING) {
        val = event.bytesTransferred * 100.0 / event.totalBytes;
        print(event.bytesTransferred);
        print(event.totalBytes);
        print(val);
      }
      if (event.state == fb.TaskState.SUCCESS) {
        print("yes");
        String url = (await ref.getDownloadURL()).toString();
        if (cr != null) {
          m[nameKey] = name;
          m[urlKey] = url;
          await cr.doc(timeToString()).set(m);
        }
        if (cr1 != null) {
          m1[nameKey1] = name;
          m1[urlKey1] = url;
          await cr1.doc(timeToString()).set(m1);
        }
        if (dr2 != null) {
          m2[nameKey1] = name;
          m2[urlKey1] = url;
          await dr2.set(m2);
        }
        if (dr3 != null) {
          m3[nameKey1] = name;
          m3[urlKey1] = url;
          await dr3.set(m3);
        }
      }
      showSimpleNotification(
        Text("uploading $name", style: TextStyle(color: Colors.black),), 
        subtitle: 
          LinearProgressIndicator(
                  value: val / 100.0,
                  valueColor: AlwaysStoppedAnimation(Colors.black),
                  backgroundColor: Colors.black26,
          ),
        trailing: Text('${val.round().toString()}%', style: TextStyle(color: Colors.black),),
        position:NotificationPosition.bottom,
        duration: Duration(seconds: 5),
        background: Colors.white,
        contentPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width/2)
      );
    //   PlNotifications.showMessage(
    //       context,
    //       Padding(
    //         padding: const EdgeInsets.fromLTRB(10, 20, 30, 0),
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [Text(name), Text('${val.round().toString()}%')],
    //         ),
    //       ),
    //       subtitle: Row(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           SizedBox(
    //             width: MediaQuery.of(context).size.width / 2,
    //             height: 3,
    //             child: LinearProgressIndicator(
    //               value: val / 100.0,
    //               valueColor: AlwaysStoppedAnimation(Colors.black),
    //               backgroundColor: Colors.black26,
    //             ),
    //           ),
    //           IconButton(
    //             alignment: Alignment.topCenter,
    //             splashRadius: 5,
    //             padding: EdgeInsets.zero,
    //             iconSize: 15,
    //             tooltip: 'Cancel',
    //             icon: Icon(
    //               Icons.cancel_rounded,
    //               size: 15,
    //             ),
    //             onPressed: task.snapshot.state == fb.TaskState.SUCCESS
    //                 ? null
    //                 : () {
    //                     task.cancel();
    //                     print("cancelled");
    //                   },
    //           )
    //         ],
    //       ),
    //       icon: Image.asset('assets/AppIcon/Logo.png'));
    });
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

        html.AnchorElement(
          href: html.Url.createObjectUrlFromBlob(blob).toString(),
        )
          ..setAttribute("download", "${months.first}.csv")
          ..click();
        months.removeAt(0);
      }
    }
  }

  static Future<void> download(
      String url, String text, BuildContext context) async {
    html.AnchorElement(href: url)
      ..setAttribute("download", text)
      ..target = '_blank'
      ..click();
  }

  static Future<void> downloadGradesExcel(
      List<int> value, String name, BuildContext context) async {
    final _base64 = base64Encode(value);
    final anchor = html.AnchorElement(
        href:
            'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$_base64')
      ..target = 'blank';
    anchor.download = name + '.xlsx';
    html.document.body.append(anchor);
    anchor.click();
    anchor.remove();
  }
}
// static Future showProgress(fb.UploadTask task, BuildContext context) async {
//   double val = 0;
//   await showDialog(
//       routeSettings: RouteSettings(name: 'dialog'),
//       useRootNavigator: true,
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return StreamBuilder(
//             stream: task.onStateChanged,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 Navigator.of(context, rootNavigator: true).pop('dialog');
//               }
//               if (snapshot.hasData) {
//                 fb.UploadTaskSnapshot snap = snapshot.data;
//                 val = snap.bytesTransferred * 100.0 / snap.totalBytes;
//                 print(snap.bytesTransferred);
//                 print(snap.totalBytes);
//                 print(val);
//               }
//               return AlertDialog(
//                 content: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CircularProgressIndicator(
//                       value: val / 100.0,
//                       valueColor: AlwaysStoppedAnimation(Colors.black),
//                       backgroundColor: Colors.black26,
//                     ),
//                     Container(
//                         margin: EdgeInsets.only(left: 7),
//                         child: Text('${val.round().toString()}% uploaded')),
//                   ],
//                 ),
//               );
//             });
//       });
// }

// static Future<String> open(
//     FilePickerResult result, String name, BuildContext context,
//     {DocumentReference docRef, bool isTrue = true}) async {
//   var ref = fb.storage().ref(name + result.files.first.name.split('/').last);
//   String mimeType = mimeFromExtension(result.files.first.extension);
//   fb.UploadTask task = ref.put(
//       result.files.first.bytes, fb.UploadMetadata(contentType: mimeType));
//   await showProgress(task, context);

//   String str = (await ref.getDownloadURL()).toString();
//   if (isTrue) await docRef.update({'Icon': str});
//   return str;
// }

// static Future<void> uploadFiles(FilePickerResult result,
//     CollectionReference docRef, String path, BuildContext context,
//     {String name, String fromId, bool isTeacher}) async {
//   // result.files.forEach((element) async {
//   //   List<String> str =
//   //       await UrlUtils.uploadFileToFirebase(element, path, context);
//   //   await docRef.doc(timeToString()).set({
//   //     'text': str[1],
//   //     'name': name,
//   //     'fromId': fromId,
//   //     'type': 'File',
//   //     'isTeacher': isTeacher,
//   //     'url': str[0],
//   //     'date': DateTime.now().toIso8601String().toString(),
//   //   });
//   // });
// }
// static Future<List<String>> uploadFileToFirebase(
//     PlatformFile file, String path, BuildContext context) async {
//   List<String> str = List<String>();
//   String mimeType = mimeFromExtension(file.extension);
//   fb.StorageReference ref =
//       fb.storage().ref(path + file.name.split('/').last);

//   var task = ref.put(file.bytes, fb.UploadMetadata(contentType: mimeType));
//   try {
//     await showProgress(task, context);
//   } catch (e) {
//     print(e);
//   }
//   await Future.delayed(const Duration(milliseconds: 1000), () {});
//   str = [(await ref.getDownloadURL()).toString(), ref.name];
//   return str;
// }
