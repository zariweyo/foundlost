import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foundlost/common/models/lost_object.dart';
import 'package:foundlost/common/services/auth_service.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get_it/get_it.dart';

abstract class Respository<T> {
  Future<void> create(T lostObject);
  Future<void> update(T lostObject);
  Future<void> delete(String id);
  Future<List<T>> list(List<String> keywords, Object? start);
}

class LostObjectRepository extends Respository<LostObject> {
  static const String _docBase = "/lostObjects/";

  @override
  Future<void> create(LostObject lostObject){
    lostObject.owner = GetIt.I.get<AuthService>().uid;
    
    return FirebaseFirestore.instance
      .collection(_docBase)
      .doc(lostObject.id.toString())
      .set(lostObject.toMap());
  }

  @override
  Future<void> update(LostObject lostObject){
    return FirebaseFirestore.instance
      .collection(_docBase)
      .doc(lostObject.id.toString())
      .update(lostObject.toMap());
  }

  @override
  Future<void> delete(String id){
    return FirebaseFirestore.instance
      .collection(_docBase)
      .doc(id.toString())
      .delete();
  }

  @override
  Future<List<LostObject>> list(List<String> keywords, Object? start){
    List<String> keywordsClean = keywords.where((element) => element.length>1).toList();
    Completer<List<LostObject>> completer = Completer<List<LostObject>>();
    Query<Map<String, dynamic>> _param = FirebaseFirestore.instance
      .collection(_docBase);
    if(keywordsClean.isNotEmpty){
      _param = _param.where('keywords',arrayContainsAny: keywordsClean);
    }
    _param = _param
    .orderBy('createDate',descending: true)
    .limit(5);
    
    if(start != null){
      _param = _param.startAfter([start]);
    }
    
    _param.get().then((qSnap){
        List<LostObject> listData = [];
        for (var dSnap in qSnap.docs) {
          listData.add(LostObject.fromMap(dSnap.data()));
        }
        completer.complete(listData);
      });

    return completer.future;
  }

  /* @override
  Future<List<LostObject>> list(List<String> keywords, Object? start){
    List<String> keywordsClean = keywords.where((element) => element.length>1).toList();
    Completer<List<LostObject>> completer = Completer<List<LostObject>>();
    Query<Map<String, dynamic>> _param = FirebaseFirestore.instance
      .collection(_docBase);
    if(keywordsClean.isNotEmpty){
      _param = _param.where('keywords',arrayContainsAny: keywordsClean);
    }


    GeoFirePoint center = Geoflutterfire().point(latitude: -5.92512, longitude: 37.4212);
    double radius = 50;
    String field = 'address.geoPoint';

    Stream<List<DocumentSnapshot>> stream = Geoflutterfire().collection(collectionRef: _param)
                                        .within(center: center, radius: radius, field: field);
    
    StreamSubscription? suscription;
    suscription = stream.listen((docs){
        List<LostObject> listData = [];
        for (var dSnap in docs) {
          listData.add(LostObject.fromMap(dSnap.data() as Map<String,dynamic>));
        }
        completer.complete(listData);
        suscription?.cancel();
    });

    return completer.future;
  } */
}