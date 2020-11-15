import 'package:evd_retailer/Providers/localization.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeLanguage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    LocalizationProvider localizationProvider = Provider.of<LocalizationProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "SettingScreen.language")),
      ),
        body:SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left:10.0),
            child: Column(
              children: <Widget>[
                Consumer<LocalizationProvider>(builder: ((context,provider,child){
                  return ListTile(
                    title: Text("አማርኛ"),
                    trailing: provider.getLocale.languageCode == "am" ? Icon(Icons.radio_button_checked) : Icon(Icons.radio_button_unchecked),
                    onTap: (){
                      SharedPref.setAmharicAsLanguage();
                      localizationProvider.setAmharicLocale();
                    },
                  );
                }),),

                Divider(),


                Consumer<LocalizationProvider>(builder: ((context,provider,child){
                  return ListTile(
                    title: Text("English"),
                    trailing: provider.getLocale.languageCode == "en" ? Icon(Icons.radio_button_checked) : Icon(Icons.radio_button_unchecked),
                    onTap: (){
                      SharedPref.setEnglishAsLanguage();
                      localizationProvider.setEnglishLocale();
                    },
                  );
                }),),
              ],
            ),
          ),
        )
    );
  }
}