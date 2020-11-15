import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/localization.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSelection extends StatelessWidget{


  @override
  Widget build(BuildContext context) {

    LocalizationProvider localizationProvider = Provider.of<LocalizationProvider>(context,listen:false);
    return Scaffold(
      body:Center(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            color: Theme.of(context).buttonColor,
            child: InkWell(
              child: Center(child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("አማርኛ",style: TextStyle(fontSize: 20,color: Colors.white)),
              )),
              onTap: (){
                SharedPref.setAmharicAsLanguage().then((value){
                  if(value) {
                    localizationProvider.setAmharicLocale();
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => Login()));
                  }
                  else{
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => Login()));
                  }
                }).catchError((onError){
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Login()));
                });
              },
            ),
          ),
          SizedBox(height: 30,),
          Card(
            color: Theme.of(context).buttonColor,
            child: InkWell(
              child: Center(child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("English",style: TextStyle(fontSize: 20,color: Colors.white),),
              )),
              onTap: (){
                SharedPref.setEnglishAsLanguage().then((value){
                  if(value) {
                    localizationProvider.setEnglishLocale();
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => Login()));
                  }
                  else{
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => Login()));
                  }
                }).catchError((onError){
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Login()));
                });
              },
            ),
          ),

        ],
      ))
    );
  }

}