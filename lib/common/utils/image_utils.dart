import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:foundlost/common/models/error.dart';
import 'package:foundlost/common/services/images_service.dart';
import 'package:foundlost/common/services/translate_service.dart';
import 'package:get_it/get_it.dart';

class ImageUtils {
  static bool imageIsCDN(Uri uri){
    if(!uri.hasScheme){
      return false;
    }
    return uri.scheme.substring(0,4).toLowerCase()=="http";
  }

  static Future<String> pathFileLoadFromStorage(Reference imageReference, bool cached) {
    ImagesService imagesService = GetIt.I.get<ImagesService>();
    TranslateService translateService = GetIt.I.get<TranslateService>();

    Completer<String> completer = Completer<String>();
    if(imageReference.fullPath==""){
      completer.completeError(GenericError(code:"IM230",message:translateService.translate("Error_storage_path_is_empty"),origin: ImageUtils));
      return completer.future;
    }
    if (imagesService.imagesPaths[imageReference.fullPath] != null) {
      completer.complete(imagesService.imagesPaths[imageReference.fullPath]);
    } else {
        imageReference.getDownloadURL().then((_pathImage) {
          if (_pathImage != "") {
            if (cached) imagesService.imagesPaths[imageReference.fullPath] = _pathImage;
            completer.complete(_pathImage);
          }
        }).catchError((onError) {
          if(onError.code=="object-not-found"){
            completer.complete("");
          }else{
            completer.completeError(onError);
          }
        });
      
    }
    return completer.future;
  }
}