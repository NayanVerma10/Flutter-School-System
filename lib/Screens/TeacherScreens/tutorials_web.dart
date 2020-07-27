// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:Schools/widgets/ClassTutorial.dart';
import 'package:file_picker_web/file_picker_web.dart';
import 'package:flutter/material.dart';


class TutorialUpload extends StatefulWidget {

  @override
  _TutorialUploadState createState() => new _TutorialUploadState();
}

class _TutorialUploadState extends State<TutorialUpload> {
  List<File> _files = [];

  void _pickFiles() async {
    _files = await FilePicker.getMultiFile() ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: ClassTutorial(),
          centerTitle: true,
          brightness: Brightness.light,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
//brightness: Brightness.li,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: _files.isNotEmpty
                    ? ListView.separated(
                  itemBuilder: (BuildContext context, int index) =>
                      Text(_files[index].name),
                  itemCount: _files.length,
                  separatorBuilder: (_, __) => const Divider(
                    thickness: 5.0,
                  ),
                )
                    : Center(
                  child: Text(
                    'Pick some files',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: RaisedButton(
                  onPressed: _pickFiles,
                  child: Text('Pick Files For Tutorial'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RaisedButton(
                  onPressed: null,
                  child: Text('Publish for the batch'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RaisedButton(
                  onPressed: null,
                  child: Text('View Class Tutorials'),
                ),
              ),

            ],

          ),

        ),

      ),

    );
  }
}