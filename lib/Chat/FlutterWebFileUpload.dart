import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:firebase/firebase.dart' as fb;
import 'package:path/path.dart' as Path;

html.File pickedFile;
String name;
Image image;
var bytes;

Future<Image> FlutterWebFileUpload() async {
  final mediaInfo = await ImagePickerWeb.getImageInfo;
  String mimeType = mime(Path.basename(mediaInfo.fileName));
  bytes = mediaInfo.data;
  print(mimeType);
  pickedFile =
      html.File(mediaInfo.data, mediaInfo.fileName, {'type': mimeType});
  name = pickedFile.name;
  image = Image.memory(mediaInfo.data);
  return image;
}

Future<Uri> uploadImageFile({String imageName}) async {
  fb.StorageReference storageRef = fb.storage().ref('$imageName' + name);
  fb.UploadTaskSnapshot uploadTaskSnapshot =
      await storageRef.put(bytes).future;
  Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
  return imageUri;
}
