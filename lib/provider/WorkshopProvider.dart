import 'package:flutter/material.dart';

class WorkshopProvider extends ChangeNotifier{
  String _subvalue = '';
  String get subValue => _subvalue;

  void setSubValue(String value){
    _subvalue = value;
    notifyListeners();
  }
}