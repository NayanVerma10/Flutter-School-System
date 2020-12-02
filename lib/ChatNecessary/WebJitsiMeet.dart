import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' show IFrameElement;
import 'dart:ui' as ui;

class WebJitsiMeet extends StatelessWidget {
  String className;
  String meetId;
  WebJitsiMeet(this.meetId, this.className);

  @override
  Widget build(BuildContext context) {
    print(meetId);

    // ignore:undefined_prefixed_name
    // ui.platformViewRegistry.registerViewFactory(
    //     'hello-world-html',
    //     (int viewId) => IFrameElement()
    //       ..allow = "camera *;microphone *"
    //       ..width = '640'
    //       ..height = '360'
    //       ..src = 'https://meet.jit.si/' + meetId
    //       ..style.border = 'none');

    return Scaffold(
      appBar: AppBar(
        title: Text(className + ' Discussions'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body: Builder(
          builder: (context) => HtmlElementView(viewType: 'hello-world-html')),
    );
  }
}
