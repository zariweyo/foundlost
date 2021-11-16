import 'package:flutter/material.dart';
import 'package:foundlost/common/index.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';

class LostObjectFormPageData {
  final String titleKey;
  Widget formComponent;
  final LostObject? data;
  final bool Function() validation;

  PublishSubject<bool>? onChangeValue;

  LostObjectFormPageData({
    this.titleKey = "null",
    this.formComponent = const MEmpty(),
    required this.data,
    required this.validation,
  });

  setFormComponent(Widget fComponent){
    formComponent = fComponent;
  }
}

class LostObjectFormPageDataName extends LostObjectFormPageData{

  LostObjectFormPageDataName({
    required LostObject data
  }):super(
    titleKey: "lostobject_name",
    data: data,
    validation: () => data.name.length>3,
  ){
    onChangeValue = PublishSubject<bool>();
    super.setFormComponent(InputField(
      placeholderKey: "name",
      initialValue: data.name,
      onChange: (text){
        data.name = text;
        onChangeValue?.add(true);
      }
    ));
  }


}

class LostObjectFormPageDataDescription extends LostObjectFormPageData{

  LostObjectFormPageDataDescription({
    required LostObject data
  }):super(
    titleKey: "lostobject_description",
    data: data,
    validation: () => data.description.length>3
  ){
    onChangeValue = PublishSubject<bool>();
    super.setFormComponent(InputField(
      placeholderKey: "description",
      initialValue: data.description,
      onChange: (text){
        data.description = text;
        onChangeValue?.add(true);
      },
      area: true,
    ));
  }
}

class LostObjectFormPageDataType extends LostObjectFormPageData{

  LostObjectFormPageDataType({
    required LostObject data
  }):super(
    titleKey: "lostobject_type",
    data: data,
    validation: () => data.type != LostObjectType.none
  ){
    onChangeValue = PublishSubject<bool>();
    super.setFormComponent(SelectTileField<LostObjectType>(
      initialValue: data.type,
      values: const <LostObjectType,IconData>{
        LostObjectType.high: Icons.warning,
        LostObjectType.medium: Icons.error,
        LostObjectType.low: Icons.error_outline_outlined,
      },
      onChange: (type){
        data.type = type;
        onChangeValue?.add(true);
      },
    ));
  }
}

class LostObjectFormPageDataImage extends LostObjectFormPageData{

  LostObjectFormPageDataImage({
    required LostObject data,
    required List<SelectPhotoFieldImage> imagesFields
  }):super(
    titleKey: "lostobject_get_images",
    data: data,
    validation: () => true
  ){
    onChangeValue = PublishSubject<bool>();
    super.setFormComponent(SelectPhotoField(
      values: imagesFields,
      onChange: (type){
        
        onChangeValue?.add(true);
      },
    ));
  }
}

class LostObjectFormPageDataAddress extends LostObjectFormPageData{

  LostObjectFormPageDataAddress({
    required LostObject data
  }):super(
    titleKey: "lostobject_address",
    data: data,
    validation: () => data.address.isComplete()
  ){
    onChangeValue = PublishSubject<bool>();
    super.setFormComponent(GeoLocationField(
      initialValue: data.address.toString(),
      onChange: (geoLocationSelected){
        data.address = LostObjectAddress();
        if(geoLocationSelected.place?.locality != null) data.address.city = geoLocationSelected.place!.locality!;
        if(geoLocationSelected.place?.name != null) data.address.houseNr = geoLocationSelected.place!.name!;
        if(geoLocationSelected.place?.postalCode != null) data.address.zipcode = geoLocationSelected.place!.postalCode!;
        if(geoLocationSelected.place?.street != null) data.address.street = geoLocationSelected.place!.street!;
        if(geoLocationSelected.place?.country != null) data.address.country = geoLocationSelected.place!.country!;
        if(geoLocationSelected.location != null) {
          data.address.geoPoint = GeoFirePoint(geoLocationSelected.location!.latitude,geoLocationSelected.location!.longitude);
        }
        onChangeValue?.add(true);
      }
    ));
  }
}