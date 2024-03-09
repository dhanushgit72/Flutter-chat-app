import 'package:chat_app/themes/dark_mode.dart';
import 'package:chat_app/themes/light_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themedata=lightMode;
  ThemeData get themedata=>_themedata;
  bool get isDarkMode=> _themedata==darkMode;

  set themedata(ThemeData themeData){
    _themedata=themeData;
    notifyListeners();
  }
  void toggleTheme(){
    if(_themedata==lightMode){
      themedata=darkMode;
    }else{
      themedata=lightMode;
    }
  }
}