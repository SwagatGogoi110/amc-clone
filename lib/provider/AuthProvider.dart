import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier{
  String? jwtToken;

  void setJwtToken(String token){
    jwtToken = token;
    notifyListeners();
  }

  void clearJwtToken(){
    jwtToken = null;
    notifyListeners();
  }
}