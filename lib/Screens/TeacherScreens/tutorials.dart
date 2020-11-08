import 'package:Schools/Chat/CreateGroupUsersList.dart';
import 'package:Schools/plugins/url_launcher/url_launcher.dart';
import 'package:Schools/widgets/ClassTutorial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:toast/toast.dart';

class TutorialUpload extends StatefulWidget {
  final String schoolCode, classNumber, section, subject;
  TutorialUpload(this.schoolCode, this.classNumber, this.section, this.subject);
  @override
  _TutorialUploadState createState() =>
      new _TutorialUploadState(schoolCode, classNumber, section, subject);
}

class _TutorialUploadState extends State<TutorialUpload> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String schoolCode, classNumber, section, subject;
  FilePickerResult result;
  _TutorialUploadState(
      this.schoolCode, this.classNumber, this.section, this.subject);
  Map<PlatformFile, bool> showPath;
  List<Widget> list;
  List<PlatformFile> files;

  @override
  void initState() {
    super.initState();
    result = FilePickerResult([]);
    showPath = Map<PlatformFile, bool>();
    list = List<Widget>();
    files = List<PlatformFile>();
  }

  @override
  Widget build(BuildContext context) {
    list = List<Widget>();
    list.add(
      new Padding(
        padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new IconButton(
              tooltip: 'Select files',
              iconSize: 100,
              icon: Icon(
                Icons.folder_open_rounded,
                size: 100,
                color: Colors.black,
              ),
              onPressed: () async {
                final res = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  withData: true,
                );
                if (res != null) {
                  res.files.forEach((element) {
                    showPath[element] = false;
                    files.add(element);
                  });
                  setState(() {
                    result = res;
                  });
                }
              },
            ),
            SizedBox(
              width: 20,
            ),
            new IconButton(
              iconSize: 100,
              icon: Icon(
                Icons.upload_file,
                size: 100,
              ),
              color: Colors.black,
              tooltip: "Upload",
              onPressed: () async {
                if (result != null) {
                  files.forEach((element) async {
                    List<String> list = await UrlUtils.uploadFileToFirebase(
                        element,
                        "$schoolCode/$classNumber-$section-$subject/tutorials/",
                        context);
                    Firestore.instance
                        .collection('School')
                        .document(schoolCode)
                        .collection('Classes')
                        .document(classNumber + '_' + section + '_' + subject)
                        .collection('Tutorials')
                        .document(timeToString())
                        .setData({
                      'name': list[1],
                      'url': list[0],
                      'size': element.size.toString()
                    }).whenComplete(() {
                      Toast.show('${list[1]} Uploaded successfully', context);
                    }).catchError((e) {
                      print(e);
                      Toast.show('Some error occured', context);
                    });
                  });
                } else {
                  Toast.show(
                      'Select at least one file before uploading', context,
                      duration: 3);
                }
              },
            ),
          ],
        ),
      ),
    );
    if (result.count > 0 && list.length < 3) {
      list.add(ListTile(
          title: Column(
        children: [
          Text(
            'Details of picked files :',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      )));
    }
    files.forEach((element) {
      list.add(Card(
        child: ListTile(
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                files.remove(element);
              });
            },
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClassTutorial(
                title1: 'Name : ',
                title2: element.name.split('\\').last,
                size: 15,
                weight: FontWeight.normal,
                c1: Colors.black,
                c2: Colors.blue,
              ),
              ClassTutorial(
                title1: 'Size : ',
                title2: element.size.toString() + ' KB',
                size: 15,
                weight: FontWeight.normal,
                c1: Colors.black,
                c2: Colors.blue,
              ),
              kIsWeb
                  ? SizedBox()
                  : showPath[element]
                      ? ClassTutorial(
                        title1: 'Path : ',
                        title2: element.path,
                        size: 15,
                        weight: FontWeight.normal,
                        c1: Colors.black,
                        c2: Colors.blue,
                      )
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              showPath[element] = (!showPath[element]);
                            });
                          },
                          child: Text(
                            'Show Path',
                            style: TextStyle(
                                color: Colors.blue[800], fontSize: 15),
                          ),
                        )
            ],
          ),
        ),
      ));
    });
    result = FilePickerResult([]);
    print(list.length);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: AppBar(
          title: ClassTutorial(
            title1: 'Class',
            title2: 'Tutorials',
            size: 28,
            c1: Colors.black54,
            c2: Colors.black87,
          ),
          centerTitle: true,
          brightness: Brightness.light,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          //brightness: Brightness.li,
        ),
        key: _scaffoldKey,
        body: new Center(
            child: new Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: new SingleChildScrollView(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center, children: list),
          ),
        )),
      ),
    );
  }
}
