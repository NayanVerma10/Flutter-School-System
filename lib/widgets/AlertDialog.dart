import 'package:flutter/material.dart';

showLoaderDialog(BuildContext context, String text) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text(text)),
      ],
    ),
  );
  showDialog(
    routeSettings: RouteSettings(name: 'Loading'),
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
