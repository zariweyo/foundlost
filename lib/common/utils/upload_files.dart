import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadFiles{

  Future<void> deleteImage(String pathImage) async {
    Completer<void> completer = Completer<void>();
    Reference refImage = FirebaseStorage.instance.ref();
    refImage.child(pathImage).delete()
    .then((value) => completer.complete())
    .onError((error, stackTrace) => completer.completeError(error??''));
    return completer.future;
  }

  Future<String> uploadImage(File image,String pathImage) async {

    Completer<String> completer = Completer<String>();

    Reference refImage = FirebaseStorage.instance.ref();
    UploadTask putFile =
        refImage.child(pathImage).putFile(image);

    putFile.whenComplete((){
      refImage.child(pathImage).getDownloadURL().then((_pathUrl){
        completer.complete(_pathUrl);
      }).catchError((err){
        log(err);
        completer.completeError(err);
      });
      
    })
    .catchError((err){
      completer.completeError(err);
    });

    return completer.future;
  }

}