import 'package:flutter/material.dart';
import 'package:Schools/plugins/url_launcher/url_launcher.dart';

// import 'package:universal_html/html.dart' as html;

Future<bool> downloadFile(String url, String text, BuildContext context) async {

  UrlUtils.download(url,text,context);

  return true;
}
