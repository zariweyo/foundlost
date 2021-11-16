import 'package:foundlost/common/utils/base_model.dart';
import 'package:foundlost/common/utils/parser_utils.dart';
import 'package:foundlost/common/utils/search_map_utils.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

enum LostObjectType {
  high,
  medium,
  low,
  none
}

class LostObject implements BaseModel{
  String id = "";
  LostObjectType type = LostObjectType.none;
  String name = "";
  String owner = "";
  String description = "";
  List<String> images = [];
  DateTime createDate = DateTime.now(); 
  DateTime updateDate = DateTime.now(); 
  DateTime lostDate = DateTime.now();
  LostObjectAddress address = LostObjectAddress();

  LostObject():super();

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': EnumUtils.enumToString(type),
      'name': name,
      'owner': owner,
      'description': description,
      'images': images,
      'lostDate': lostDate.toUtc().toIso8601String(),
      'createDate': createDate.toUtc().toIso8601String(),
      'updateDate': updateDate.toUtc().toIso8601String(),
      'keywords': SearchMapsUtils.generateKeywords([name,description]),
      'address': address.toMap(),
    };
  }

  factory LostObject.fromMap(Map<String, dynamic> data) {
    LostObject lostObjet = LostObject();
    if(data['id']!=null) lostObjet.id = DinamicUtils.dynamicToString(data['id']);
    if(data['type']!=null) lostObjet.type = EnumUtils.stringToEnum<LostObjectType>(data['type'], LostObjectType.values, ifnot: LostObjectType.none);
    if(data['name']!=null) lostObjet.name = DinamicUtils.dynamicToString(data['name']);
    if(data['owner']!=null) lostObjet.owner = DinamicUtils.dynamicToString(data['owner']);
    if(data['description']!=null) lostObjet.description = DinamicUtils.dynamicToString(data['description']);
    if(data['lostDate']!=null) lostObjet.lostDate = DateTime.parse(data['lostDate']);
    if(data['createDate']!=null) lostObjet.createDate = DateTime.parse(data['createDate']);
    if(data['updateDate']!=null) lostObjet.updateDate = DateTime.parse(data['updateDate']);
    if(data['images']!=null) lostObjet.images = DinamicUtils.mapToList<String>(data['images']);
    if(data['address']!=null) lostObjet.address = LostObjectAddress.fromMap(data['address']);
    return lostObjet;
  }

}

class LostObjectAddress implements BaseModel{
  String city = "";
  String street = "";
  String zipcode = "";
  String houseNr = "";
  String country = "";
  GeoFirePoint geoPoint = Geoflutterfire().point(latitude: 0, longitude: 0);

  LostObjectAddress():super();

  @override
  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'street': street,
      'zipcode': zipcode,
      'houseNr': houseNr,
      'country': country,
      'geoPoint': geoPoint.data
    };
  }

  factory LostObjectAddress.fromMap(Map<String, dynamic> data) {
    LostObjectAddress lostObjectAddress = LostObjectAddress();
    if(data['city']!=null) lostObjectAddress.city = DinamicUtils.dynamicToString(data['city']);
    if(data['street']!=null) lostObjectAddress.street = DinamicUtils.dynamicToString(data['street']);
    if(data['zipcode']!=null) lostObjectAddress.zipcode = DinamicUtils.dynamicToString(data['zipcode']);
    if(data['houseNr']!=null) lostObjectAddress.houseNr = DinamicUtils.dynamicToString(data['houseNr']);
    if(data['country']!=null) lostObjectAddress.country = DinamicUtils.dynamicToString(data['country']);
    if(data['geoPoint']!=null && data['geoPoint']['geopoint']!=null) lostObjectAddress.geoPoint = Geoflutterfire().point(latitude: data['geoPoint']['geopoint'].latitude, longitude: data['geoPoint']['geopoint'].longitude);
    return lostObjectAddress;
  }

  @override
  String toString(){
    String addressStr = "";
    if(street.isNotEmpty) addressStr += street + " ";
    if(houseNr.isNotEmpty) addressStr += houseNr + ", ";
    if(zipcode.isNotEmpty) addressStr += zipcode + " ";
    if(city.isNotEmpty) addressStr += city + " ";
    if(country.isNotEmpty) addressStr += " (" + country + ")";
    return addressStr;
  }

  isComplete(){
    if(geoPoint.latitude != 0 && geoPoint.longitude != 0 && city.isNotEmpty){
      return true;
    }

    return false;
  }
}