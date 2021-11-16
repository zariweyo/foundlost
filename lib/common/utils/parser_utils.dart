enum UtilsDynamicType{
  undefined,
  list,
  object
}


class EnumUtils {

  static String enumToString<T>(T enumItem, { String ifnot = "" }) {
    if(enumItem == null) return ifnot;
    return enumItem.toString().split('.')[1];
  }

  static T stringToEnum<T>(String name, List<T> values, { required T ifnot}) {
    for (T enumItem in values) {
      if(enumToString(enumItem) == name) return enumItem;
    }
    return ifnot;
  }
  
}

class DinamicUtils {
  static String dynamicToString(dynamic _str) {
    return _str ??= '';
  }

  static int dynamicToInt(dynamic _num) {
    String _st = _num.toString();
    int? _do = int.tryParse(_st);
    return _do ??= 0;
  }

  static bool dynamicToBool(dynamic _val, {bool ifNull = true}) {
    String _st = _val.toString();
    if (_st == "true") {
      return true;
    }

    if (_st == "false") {
      return false;
    }

    return ifNull;
  }

  static double dynamicToDouble(dynamic _num) {
    String _st = _num.toString();
    double? _do = double.tryParse(_st);
    return _do ??= 0.00;
  }

  static UtilsDynamicType getTypeofDynamic(dynamic _din){
    try{
      String _dinStr = _din.toString();
      if(_dinStr.isEmpty){
        return UtilsDynamicType.undefined;
      }

      String _initSt = _dinStr[0];
      if(_initSt=="["){
        return UtilsDynamicType.list;
      }

      if(_initSt=="{"){
        return UtilsDynamicType.object;
      }


      return UtilsDynamicType.undefined;
    }catch(err){
      return UtilsDynamicType.undefined;
    }
  }

  static List<Map<String,dynamic>> listToMap(List<dynamic>? _list, {bool withToMap = false}){
    List<Map<String,dynamic>> _mapList = [];
    if(_list!=null){
      for(dynamic _item in _list){
        _mapList.add(withToMap? _item.toMap(): _item);
      }
    }
    return _mapList;
  }

  static List<T> mapToList<T>(List<dynamic>? _mapList, {Function(Map<String,dynamic>)? fromMap}){
    List<T> _list = [];
    if(_mapList!=null){
      if(fromMap != null){
        for(Map<String,dynamic> _mapItem in _mapList){
          T _item = fromMap(_mapItem);
          _list.add(_item);
        }
      }else{
        for(T _item in _mapList){
          _list.add(_item);
        }
      }
    }
    return _list;
  }
}

