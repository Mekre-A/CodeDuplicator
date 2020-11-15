
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{


  static Future<bool> storeUserObject(String userObject) async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      return await preferences.setString("user", userObject);

  }

  static Future<String> getUserObject() async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if(preferences.containsKey("user")){
        return preferences.get("user");
      }
      else{
        return "";
      }

  }


  static Future<bool> logOut() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.clear();
  }

  static Future<bool> setShowOldBalance(bool status)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool("showOldBalance", status);
  }

  static Future<bool> showOldBalance()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if(preferences.containsKey("showOldBalance")){
      return preferences.getBool("showOldBalance");
    }
    else{
      return false;
    }
  }

  static Future<bool> isLocked()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey("lock")){
      return preferences.getBool("lock");
    }
    else{
      return false;
    }
  }

  static Future setLocked(bool value)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("lock", value);
  }

  static Future<bool> getForceSync()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey("forceSync")){
      return preferences.getBool("forceSync");
    }
    else{
      return false;
    }
  }

  static Future setForceSync(bool value)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("forceSync", value);
  }

  static Future<bool> isLanguageSet() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey("lang")){
      return true;
    }
    return false;
  }

  static Future<String> getSelectedLanguage() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey("lang")){
      return preferences.getString("lang");
    }
    else{
      return "";
    }
  }

  static Future<bool> setEnglishAsLanguage() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString("lang", "en");
  }

  static Future<bool> setAmharicAsLanguage() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString("lang", "am");
  }

  static Future<bool> saveBaseUrlAndApiKey(String baseUrlApiKey) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return await preferences.setString("baseUrlApiKey", baseUrlApiKey);
  }


  static Future<String> getBaseUrlAndApiKey()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey("baseUrlApiKey")){
      return preferences.getString("baseUrlApiKey");
    }
    else{
      return "";
    }
  }
}