import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:foundlost/common/repositories/lost_object_repository.dart';
import 'package:foundlost/common/services/auth_service.dart';
import 'package:foundlost/common/services/geolocation_service.dart';
import 'package:foundlost/common/services/images_service.dart';
import 'package:get_it/get_it.dart';

import 'common/models/lost_object.dart';
import 'common/services/translate_service.dart';

class StartApp {

  static Future<FirebaseApp> registers(BuildContext context) async {
    final _firebaseInitialization = await Firebase.initializeApp();
    GetIt.I.registerSingleton<AuthService>(AuthServiceImpl());
    GetIt.I.registerSingleton<ImagesService>(ImagesServiceImpl());
    GetIt.I.registerSingleton<TranslateService>(TranslateServiceImpl());
    GetIt.I.registerSingleton<GeolocationService>(GeolocationServiceImpl());
    GetIt.I.registerFactory<Respository<LostObject>>(() => LostObjectRepository());

    await GetIt.I.get<AuthService>().init();

    return _firebaseInitialization;
  }

  static initContext(BuildContext context){
    GetIt.I.get<TranslateService>().initContext(context);
  }
}