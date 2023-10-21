import 'package:flutter/material.dart';

class ChassisControllerProvider with ChangeNotifier{
  final TextEditingController _controller = TextEditingController();

  TextEditingController get controller => _controller;

  setChassisController(String text){
    _controller.text = text;
    notifyListeners();
  }
}