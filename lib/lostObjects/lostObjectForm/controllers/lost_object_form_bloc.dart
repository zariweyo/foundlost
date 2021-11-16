import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foundlost/common/index.dart';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:foundlost/lostObjects/lostObjectForm/views/index.dart';
import 'package:uuid/uuid.dart';


enum LostObjectFormEventType {
  initialForm,
  nextForm,
  backForm,
  lostObjectLoaded
}

enum LostObjectFormActionType { 
  initial,
  nextFormSuccess,
  loadingForm
}

class LostObjectFormEvent {
  final LostObjectFormEventType type;
  final dynamic data;
  LostObjectFormEvent(this.type, this.data);
}

class LostObjectFormAction {
  final LostObjectFormActionType type;
  final dynamic data;
  LostObjectFormAction(this.type, this.data);
}

class LostObjectFormBloc extends Bloc<LostObjectFormEvent, LostObjectFormAction> {

  static const int maxImages= 4;

  Respository<LostObject> repo = GetIt.I.get<Respository<LostObject>>();
  AuthService authService = GetIt.I.get<AuthService>();
  late BuildContext context;
  UploadFiles uploadFilesUtil = UploadFiles();

  int formIndex = 0;
  LostObject? dataForm;
  List<SelectPhotoFieldImage> imagesFields = [];
  List<LostObjectFormPageData> formList = [];

  LostObjectFormBloc(LostObjectFormAction initialState) : super(initialState){
    context = initialState.data;
    add(LostObjectFormEvent(LostObjectFormEventType.initialForm,LostObjectFormPageData(
      data: dataForm,
      validation: () => false
    )));
  }

  @override
  Stream<LostObjectFormAction> mapEventToState(LostObjectFormEvent event) async* {
    switch (event.type) {
      case LostObjectFormEventType.initialForm:
        yield LostObjectFormAction(LostObjectFormActionType.loadingForm,{});
        loadDataForm();
        break;
      case LostObjectFormEventType.lostObjectLoaded:
        loadListForms();
        loadImagesFields();
        yield LostObjectFormAction(LostObjectFormActionType.nextFormSuccess,formList[0]);
        break;
      case LostObjectFormEventType.nextForm:
        LostObjectFormPageData? lostObjectFormPageData = getFormAndIncrementIndex();
        if(lostObjectFormPageData!=null){
          yield LostObjectFormAction(LostObjectFormActionType.nextFormSuccess,lostObjectFormPageData);
        }
        break;
      case LostObjectFormEventType.backForm:
        LostObjectFormPageData? lostObjectFormPageData = getFormAndDecrementIndex();
        if(lostObjectFormPageData!=null){
          yield LostObjectFormAction(LostObjectFormActionType.nextFormSuccess,lostObjectFormPageData);
        }
        break;

    }
  }

  LostObjectFormPageData? getFormAndIncrementIndex(){
    if(formList.length>formIndex && formIndex<formList.length-1){
      loadListForms();
      formIndex++;
      return formList[formIndex];
    }
    saveData().then((value) => Navigator.of(context).pop(dataForm));
    return null;
  }

  LostObjectFormPageData? getFormAndDecrementIndex(){
    if(formIndex>0){
      loadListForms();
      return formList[--formIndex];
    }
    Navigator.of(context).pop();
    return null;
  }

  Future<void> saveData() async{
    if(dataForm == null) return;
    bool isEdit = dataForm!.id.isNotEmpty;
    if(!isEdit) dataForm!.id = const Uuid().v1();
    if(!isEdit) dataForm!.owner = authService.uid;

    String pathImages = "/images/${dataForm!.owner}/";

    for (var imageField in imagesFields) {
      switch(imageField.action){
        
        case SelectPhotoFieldImageAction.empty:
          break;
        case SelectPhotoFieldImageAction.current:
          break;
        case SelectPhotoFieldImageAction.upload:
          File imgFile = File(imageField.path);
          String imgPath = await uploadFilesUtil.uploadImage(imgFile, pathImages + const Uuid().v4());
          dataForm!.images.add(imgPath);
          break;
        case SelectPhotoFieldImageAction.delete:
          await uploadFilesUtil.deleteImage(imageField.path);
          dataForm!.images = dataForm!.images.where((element) => element!=imageField.path).toList();
          break;
      }
    }
    if(isEdit){
      await repo.update(dataForm!);
    }else{
      await repo.create(dataForm!);
    }
  }

  loadDataForm(){
    if(ModalRoute.of(context)!.settings.arguments != null){
      dataForm = ModalRoute.of(context)!.settings.arguments as LostObject;
    }else{
      dataForm = LostObject();
    }
    add(LostObjectFormEvent(LostObjectFormEventType.lostObjectLoaded,null));

  }

  loadListForms(){
    formList = [];
    formList.add(LostObjectFormPageDataAddress(
      data: dataForm!
    ));
    formList.add(LostObjectFormPageDataImage(
      data: dataForm!,
      imagesFields: imagesFields
    ));
    formList.add(LostObjectFormPageDataType(
      data: dataForm!
    ));
    formList.add(LostObjectFormPageDataName(
      data: dataForm!
    ));
    formList.add(LostObjectFormPageDataDescription(
      data: dataForm!
    ));
  }

  loadImagesFields(){
    for (var element in dataForm!.images) {
      imagesFields.add(SelectPhotoFieldImage(
        path: element,
        action: SelectPhotoFieldImageAction.current
      ));
    }

    for(int i=0; i < maxImages - dataForm!.images.length; i++){
      imagesFields.add(SelectPhotoFieldImage(
        path: "",
        action: SelectPhotoFieldImageAction.empty
      ));
    }
  }

}