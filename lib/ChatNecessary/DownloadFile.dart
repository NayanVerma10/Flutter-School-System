import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:universal_html/html.dart' as html;

Future<bool> downloadFile(String url, String text, BuildContext context) async {
  Dio dio = Dio();
  try {
    if (!kIsWeb) {
      // This Code will run on mobile

      var dirs = await getExternalStorageDirectories();
      var dir = dirs[0];
      print(dir.path);
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      await dio.download(url, "/storage/emulated/0/MySchools/$text",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
      });
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('$text downloaded')));
      print("Download completed");
    } else {
      // This Code will run on web

      html.AnchorElement anchorElement = new html.AnchorElement(href: url)
         ..setAttribute("download", text)
         ..target='_blank'
         ..click();

    }
  } catch (e) {
    print(e);
  }
  return true;
}
