import 'dart:async';
import 'dart:io';
import 'package:Schools/ChatNecessary/URLLauncher.dart';
import 'package:Schools/Screens/TeacherScreens/attendance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mime_type/mime_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:path/path.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Map<PlatformFile, StorageUploadTask> m = Map<PlatformFile, StorageUploadTask>();
var icon = Icons.cancel;
int x = 0;

class UrlUtils {
  UrlUtils._();

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

    File file1 = File(file.path);
    String mimeType = mimeFromExtension(file.extension);
    StorageReference ref =
        FirebaseStorage.instance.ref().child(path + file.name);
    var task = ref.putFile(file1, StorageMetadata(contentType: mimeType));
    String name = file.name;
    double val = 0;

    AwesomeNotifications n = AwesomeNotifications();

    n.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        n.requestPermissionToSendNotifications();
      }
    });

    n.initialize('resource://drawable/logo', [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF000000),
          ledColor: Colors.white)
    ]);
    Toast.show('$name uploading....', context);
    task.events.listen((event) async {
      StorageTaskSnapshot snap = event.snapshot;
      val = snap.bytesTransferred * 100.0 / snap.totalByteCount;
      if (!task.isCanceled) {
        n.createNotification(
            content: NotificationContent(
                createdSource: NotificationSource.Local,
                notificationLayout: NotificationLayout.ProgressBar,
                id: x,
                progress: val.ceil(),
                channelKey: 'basic_channel',
                title: name,
                body: val.ceil().toString() + "%"),
            actionButtons: [
              NotificationActionButton(
                  enabled: true,
                  buttonType: ActionButtonType.Default,
                  label: 'Cancel',
                  key: "cancel")
            ]);
      } else {
        n.createNotification(
            content: NotificationContent(
                createdSource: NotificationSource.Local,
                notificationLayout: NotificationLayout.Default,
                id: x,
                channelKey: 'basic_channel',
                title: name,
                body: 'cancelled'));
      }
      if (task.isSuccessful && !task.isCanceled) {
        n.createNotification(
            content: NotificationContent(
                createdSource: NotificationSource.Local,
                notificationLayout: NotificationLayout.Default,
                id: x,
                channelKey: 'basic_channel',
                title: name,
                body: 'uploaded successfully.'));
        String url = (await ref.getDownloadURL()).toString();
        if (cr != null) {
          m[nameKey] = name;
          m[urlKey] = (await ref.getDownloadURL()).toString();
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
        Toast.show('$name uploaded successfully.', context);
      }
      try {
        n.actionStream.asBroadcastStream().listen((event) {
          task.cancel();
        });
      } catch (e) {}
    });
  }

  static Future<void> deleteFile(String url) async {
    await FirebaseStorage.instance.getReferenceFromUrl(url).then((value) async {
      print("here" + value.toString());
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
    SnackBar(
      duration: Duration(seconds: 5),
      content:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Saved at ${dir.path}'.length > 20
            ? 'Saved at ${dir.path}'.substring(0, 20) + "..."
            : 'Saved at ${dir.path}'),
        TextButton(
          child: Text("open", style: TextStyle(color: Colors.yellow)),
          onPressed: () async {
            await OpenFile.open(dir.path);
          },
        )
      ]),
    );
  }

  static Future<void> download(
      String url, String text, BuildContext context) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    try {
      await FlutterDownloader.initialize();
    } catch (e) {}
    try {
      final dir = await getExternalStorageDirectory();
      Toast.show("download started", context);
      FlutterDownloader.enqueue(
        url: url,
        savedDir: dir.path,
        fileName: text,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      ).whenComplete(() {
        Toast.show('$text Downloaded', context);
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<void> downloadGradesExcel(
      List<int> value, String name, BuildContext context) async {
    final path = (await getExternalStorageDirectory()).path + '/$name.xlsx';
    File(join(path))
      ..createSync(recursive: true)
      ..writeAsBytesSync(value);
    // Toast.show('Saved at $path', context, duration: 2);
    Scaffold.of(context).showSnackBar(SnackBar(
      action: SnackBarAction(
        label: "open",
        onPressed: () async {
            await OpenFile.open(path);
        },
        textColor: Colors.yellow,
      ),
      // width: MediaQuery.of(context).size.width,
      backgroundColor: Colors.black,
      duration: Duration(seconds: 5),
      content:
          Text(
              'Saved at $path',
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white)),
      onVisible: () {
        print("yesss");
      },
    ));
  }
}

// static Future showProgress(
//     StorageUploadTask task, BuildContext context) async {
//   double val = 0;
//   await showDialog(
//       routeSettings: RouteSettings(name: 'dialog'),
//       useRootNavigator: true,
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return StreamBuilder(
//             stream: task.events,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 Navigator.of(context, rootNavigator: true).pop('dialog');
//               }
//               if (snapshot.hasData) {
//                 StorageTaskEvent event = snapshot.data;
//                 StorageTaskSnapshot snap = event.snapshot;
//                 val = snap.bytesTransferred * 100.0 / snap.totalByteCount;
//                 if (event.type == StorageTaskEventType.success) {
//                   Navigator.of(context, rootNavigator: true).pop('dialog');
//                 }
//               }
//               return AlertDialog(
//                 content: Row(
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
//   uploadFileToFirebase(
//     result.files.first,
//     name + result.files.first.name,
//     context,
//     null,
//     null,
//     null,
//     null,
//     dr2: docRef,
//   );
//   File file = File(result.files.first.path);
//   String mimeType = mimeFromExtension(result.files.first.extension);
//   StorageReference ref =
//       FirebaseStorage.instance.ref().child(name + result.files.first.name);

//   StorageUploadTask task =
//       ref.putFile(file, StorageMetadata(contentType: mimeType));
//   await (UrlUtils.showProgress(task, context));
//   String str = (await ref.getDownloadURL()).toString();
//   if (isTrue) await docRef.update({'Icon': str});
//   return str;
// }

// static Future<void> uploadFiles(FilePickerResult result,
//     CollectionReference docRef, String path, BuildContext context,
//     {String name, String fromId, bool isTeacher}) async {
//   result.files.forEach((element) async {
//     List<String> str;
//     // await UrlUtils.uploadFileToFirebase(element, path, context);
//     await docRef.doc(timeToString()).set({
//       'text': str[1],
//       'name': name,
//       'fromId': fromId,
//       'type': 'File',
//       'isTeacher': isTeacher,
//       'url': str[0],
//       'date': DateTime.now().toIso8601String().toString(),
//     });
//   });
// }

// static Future<List<String>> uploadFileToFirebase(
//     PlatformFile file, String path, BuildContext context) async {
//   File file1 = File(file.path);
//   String mimeType = mimeFromExtension(file.extension);
//   StorageReference ref =
//       FirebaseStorage.instance.ref().child(path + file.name);
//   var task = ref.putFile(file1, StorageMetadata(contentType: mimeType));
//   await UrlUtils.showProgress(task, context);
//   return [(await ref.getDownloadURL()).toString(), await ref.getName()];
// }
