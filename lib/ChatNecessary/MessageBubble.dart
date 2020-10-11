import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

import './DownloadFile.dart';
import './URLLauncher.dart';

class Message extends StatelessWidget {
  final String from;
  final String text;
  final String fromId;
  final String date;
  final bool isTeacher;
  final String fileURL;
  final String type;
  final bool me;
  final double pad;

  const Message(
      {Key key,
      @required this.from,
      @required this.type,
      @required this.text,
      @required this.me,
      @required this.isTeacher,
      @required this.fileURL,
      @required this.date,
      @required this.fromId,
      @required this.pad})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            from,
            style: TextStyle(
              fontSize: 8,
              fontWeight: isTeacher ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Bubble(
            color:
                Colors.white, //me ? Colors.green[100] : Colors.deepPurple[100],
            nip: me ? BubbleNip.rightTop : BubbleNip.leftTop,
            nipWidth: 12,
            elevation: 2,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: (MediaQuery.of(context).size.width - (2 * pad)) * 0.7,
              ),
              padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
              child: Column(
                crossAxisAlignment:
                    me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  type == 'File'
                      ? fileWidget(context)
                      : Text(
                          text,
                        ),
                  Text(
                    date.split('T')[0] +
                        ' ' +
                        date.split('T')[1].substring(0, 5),
                    style: TextStyle(fontSize: 6),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  fileWidget(BuildContext context) {
    String fileExtention = text.split('.').last;
    List<String> imageExtensions = [
      'jpg',
      'jpeg',
      'jpe',
      'jif',
      'jfif',
      'jfi',
      'png',
      'gif',
      'webp',
      'tiff',
      'tif ',
    ];

    return Column(
      children: [
        imageExtensions.contains(fileExtention)
            ? Column(
                children: [
                  Image.network(
                    fileURL,
                    key: UniqueKey(),
                    scale: 0.2,
                  ),
                  ListTile(
                    onTap: () {
                      URLLauncher(fileURL);
                    },
                    title: Text(
                      text,
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.file_download),
                      onPressed: () async {
                        await downloadFile(fileURL, text, context);
                      },
                    ),
                  )
                ],
              )
            : ListTile(
                onTap: () {
                  URLLauncher(fileURL);
                },
                title: Text(
                  text,
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Offstage(
                      offstage: false,
                      child: IconButton(
                        icon: const Icon(Icons.file_download),
                        onPressed: () async {
                          await downloadFile(fileURL, text, context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
