import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foundlost/common/index.dart';
import 'package:get_it/get_it.dart';


enum LostObjectDetailEventType {
  loadDetail,
  backDetail,
  edit,
  delete
}

enum LostObjectDetailActionType { 
  initial
}

class LostObjectDetailEvent {
  final LostObjectDetailEventType type;
  final dynamic data;
  LostObjectDetailEvent(this.type, this.data);
}

class LostObjectDetailAction {
  final LostObjectDetailActionType type;
  final dynamic data;
  LostObjectDetailAction(this.type, this.data);
}

class LostObjectDetailBloc extends Bloc<LostObjectDetailEvent, LostObjectDetailAction> {

  static const int maxImages= 2;

  Respository<LostObject> repo = GetIt.I.get<Respository<LostObject>>();
  AuthService authService = GetIt.I.get<AuthService>();
  late BuildContext context;
  UploadFiles uploadFilesUtil = UploadFiles();
  
  LostObject lostObject = LostObject();
  List<SelectPhotoFieldImage> imagesFields = [];

  LostObjectDetailBloc(LostObjectDetailAction initialState) : super(initialState){
    context = initialState.data;
    loadDataDetail();
    
  }

  @override
  Stream<LostObjectDetailAction> mapEventToState(LostObjectDetailEvent event) async* {
    switch (event.type) {
      case LostObjectDetailEventType.loadDetail:
        yield LostObjectDetailAction(LostObjectDetailActionType.initial,event.data);
        break;

      case LostObjectDetailEventType.backDetail:
        Navigator.of(context).pop();
        break;
      case LostObjectDetailEventType.edit:
        edit();
        break;
      case LostObjectDetailEventType.delete:
        delete();
        break;
    }
  }

  loadDataDetail(){
    if(ModalRoute.of(context)!.settings.arguments != null){
      lostObject = ModalRoute.of(context)!.settings.arguments as LostObject;
      add(LostObjectDetailEvent(LostObjectDetailEventType.loadDetail,lostObject));
    }
  }

  edit(){
    Navigator.pushNamed(context, '/newLostObject', arguments: lostObject).then((_lostObjectReturn){
      if(_lostObjectReturn!=null){
        add(LostObjectDetailEvent(LostObjectDetailEventType.loadDetail,_lostObjectReturn));
      }
    });
  }

  delete(){
    repo.delete(lostObject.id).then((value){
      Navigator.of(context).pop();
    });
  }
}