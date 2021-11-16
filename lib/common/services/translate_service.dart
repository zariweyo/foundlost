import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

abstract class TranslateService {
  String translate(String key);
  void initContext(BuildContext _context);
}


class TranslateServiceImpl extends  TranslateService{

  late BuildContext context;
  
  TranslateServiceImpl();

  @override
  void initContext(BuildContext _context){
    context = _context;
  }

  @override
  String translate(String key){
    return FlutterI18n.translate(context, key);
  }
}