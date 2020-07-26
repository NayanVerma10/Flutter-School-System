import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';


Future<List<File>> attachment() async {
  List<File> files;
  files = await FilePicker.getMultiFile();
  return files;
}

Future<List<String>> uploadToFirebase(String path,File file) async {
    String downloadURL;
    String fileName;

    StorageReference storageRef =
        FirebaseStorage.instance.ref().child(path + file.path.split('/').last);
    final StorageUploadTask uploadTask = storageRef.putFile(
      file,
      StorageMetadata(
        contentType: 'type',
      ),
    );
    await uploadTask.onComplete.then((value) async {
      downloadURL= (await value.ref.getDownloadURL()).toString();
      fileName=await value.ref.getName();
    });
    print(downloadURL);
    return [downloadURL,fileName];
  }



  
