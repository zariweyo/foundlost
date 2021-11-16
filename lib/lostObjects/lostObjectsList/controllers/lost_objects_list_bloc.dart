import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foundlost/common/index.dart';
import 'package:get_it/get_it.dart';
import 'dart:math' as Math;

enum LostObjectListEventType {
  insertNew, 
  search,
  delete,
  edit,
  view,
  getMore,
  refresh
}

enum LostObjectListActionType { 
  initial, 
  moreListSuccess,
  replaceListSuccess,
  addToListSuccess
}

class LostObjectListEvent {
  final LostObjectListEventType type;
  final dynamic data;
  LostObjectListEvent(this.type, this.data);
}

class LostObjectListAction {
  final LostObjectListActionType type;
  final dynamic data;
  LostObjectListAction(this.type, this.data);
}


class LostObjectListBloc extends Bloc<LostObjectListEvent, LostObjectListAction> {
  Respository<LostObject> repo = GetIt.I.get<Respository<LostObject>>();
  List<LostObject> listState = [];
  Object? lastFieldObject;
  String searched = "";
  late BuildContext context;

  LostObjectListBloc(LostObjectListAction initialState) : super(initialState){
      context = initialState.data;
      add(LostObjectListEvent(LostObjectListEventType.search,""));
  }

  @override
  Stream<LostObjectListAction> mapEventToState(LostObjectListEvent event) async* {
    switch (event.type) {
      case LostObjectListEventType.insertNew:
        insertNew();
        //yield LostObjectListAction(LostObjectListActionType.replaceListSuccess,listState);
        break;
      case LostObjectListEventType.edit:
        edit(event.data as LostObject);
        //yield LostObjectListAction(LostObjectListActionType.replaceListSuccess,listState);
        break;
      case LostObjectListEventType.view:
        view(event.data as LostObject);
        break;
      case LostObjectListEventType.search:
        searched = event.data as String;
        lastFieldObject = null;
        listState = await getListAsync();
        yield LostObjectListAction(LostObjectListActionType.replaceListSuccess,listState);
        break;
      case LostObjectListEventType.refresh:
        lastFieldObject = null;
        listState = await getListAsync();
        yield LostObjectListAction(LostObjectListActionType.replaceListSuccess,listState);
        break;
      case LostObjectListEventType.getMore:
        List<LostObject> moreList = await getListAsync();
        listState.addAll(moreList);
        yield LostObjectListAction(LostObjectListActionType.moreListSuccess,moreList);
        break;
      case LostObjectListEventType.delete:
        listState = delete(event.data as String);
        yield LostObjectListAction(LostObjectListActionType.replaceListSuccess,listState);
        break;
    }
  }

  Future<List<LostObject>> getListAsync() async{
    return repo.list(searched.split(" "),lastFieldObject).then((list){
      if(list.isNotEmpty) lastFieldObject = list.last.createDate.toUtc().toIso8601String();
      return list;
    });

  }

  delete(String id){
    repo.delete(id);
    return listState.where((element) => element.id != id).toList();
  }

  insertNew(){
    Navigator.pushNamed(context, '/newLostObject');
  }

  edit(LostObject lostObject){
    Navigator.pushNamed(context, '/newLostObject', arguments: lostObject);
  }

  view(LostObject lostObject){
    Navigator.pushNamed(context, '/viewLostObject', arguments: lostObject);
  }
}