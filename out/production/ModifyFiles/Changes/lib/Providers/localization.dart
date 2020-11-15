import 'package:flutter/material.dart';

class LocalizationProvider extends ChangeNotifier{


  Locale _locale = Locale('en','US');
  Locale get getLocale => _locale;
  void setAmharicLocale(){
    // if we don't make this conditional check,
    // the app will get into an endless loop rebuilding the MyApp Widget over and over again as
    // it changes the value of the _locale variable
    if(_locale.languageCode == 'am'){
      _locale = Locale('am','ET');
    }
    else{
      _locale = Locale('am','ET');
      notifyListeners();
    }

  }
  void setEnglishLocale(){
    // if we don't make this conditional check,
    // the app will get into an endless loop rebuilding the MyApp Widget over and over again as
    // it changes the value of the _locale variable
    if(_locale.languageCode == 'en'){
      _locale = Locale('en','US');
    }
    else{
      _locale = Locale('en','US');
      notifyListeners();
    }

  }

}