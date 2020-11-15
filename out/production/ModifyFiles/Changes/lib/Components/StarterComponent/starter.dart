import 'dart:convert';

import 'package:evd_retailer/Components/AllComponent/all.dart';
import 'package:evd_retailer/Components/ForceSyncComponent/force_sync.dart';
import 'package:evd_retailer/Components/LanguageSelectionComponent/language_selection.dart';
import 'package:evd_retailer/Components/LockedComponent/locked.dart';
import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Models/LoginResponse.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Providers/localization.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:evd_retailer/Services/SqlDatabase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Starter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider =
        Provider.of<MasterProvider>(context, listen: false);
    LocalizationProvider localizationProvider = Provider.of<LocalizationProvider>(context,listen:false);

    SqlDatabase sqlDatabase = SqlDatabase();

    SharedPref.isLanguageSet().then((value){
      if(value){
        SharedPref.getSelectedLanguage().then((value){
            if(value == "en"){
              localizationProvider.setEnglishLocale();
            }
            else if(value == "am"){
              localizationProvider.setAmharicLocale();
            }
            SharedPref.getUserObject().then((value) async{
              if (value == "") {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              } else {
                if((await SharedPref.getBaseUrlAndApiKey()) != ""){
                  Map<String,String> baseUrlAndKey = Map.castFrom(jsonDecode(await SharedPref.getBaseUrlAndApiKey()));
                  HttpCalls.constants["baseUrl"] = baseUrlAndKey["baseUrl"];
                  HttpCalls.constants["key"] = baseUrlAndKey["apiKey"];
                }
                else{
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Login()));
                }

                masterProvider.setUser = User.fromJson(jsonDecode(value));
                if(masterProvider.getUser.syncWarningLimit == null || masterProvider.getUser.syncMaxLimit == null){
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Login()));
                }

                SharedPref.showOldBalance().then((value) {
                  masterProvider.setShowOldBalance = value;

                  sqlDatabase.openDB(masterProvider.getUser.userId).then((value)async{
                    if(value){
                      masterProvider.setPassKey = await sqlDatabase.getPassKey();
                      // delete cards if they have been synced and their date has passed

                      List<Map> countAndDate = await sqlDatabase.getItemsFromDeleteLog();
                      List<String> datesToBeDeleted = [];
                      if(countAndDate.isNotEmpty){
                        int count = 0;
                        while(true){
                          String date = countAndDate[count]['date'];
                          if(DateTime.now().difference(DateTime.parse(date)) >= Duration(days:masterProvider.getUser.historyMaxDays)){
                              datesToBeDeleted.add(date);
                          }
                          count+=1;
                          if(count == countAndDate.length){
                            break;
                          }
                        }
                      }

                      await sqlDatabase.deleteItemsFromDeleteLogAndSyncTable(datesToBeDeleted);

                      sqlDatabase.getAllConfirmedData().then((value)async{
                        masterProvider.setDownloadCards = value;
                        if((await SharedPref.isLocked())){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Locked()));
                        }
                        else{
                          bool forceSync = await  SharedPref.getForceSync();
                          if(forceSync){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ForceSync()));
                          }
                          else{
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => All()));
                          }
                        }

                      }).catchError((onError){
                        print(onError);
                      });
                    }

                  }).catchError((onError){
                    print(onError);
                  });

                }).catchError((onError){
                  masterProvider.setShowOldBalance = false;
                  sqlDatabase.openDB(masterProvider.getUser.userId).then((value)async{
                    sqlDatabase.getAllConfirmedData().then((value)async{
                      masterProvider.setDownloadCards = value;
                      if((await SharedPref.isLocked())){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Locked()));
                      }
                      else{
                        bool forceSync = await  SharedPref.getForceSync();
                        if(forceSync){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ForceSync()));
                        }
                        else{
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => All()));
                        }
                      }

                    }).catchError((onError){
                      print(onError);
                    });
                  }).catchError((onError){
                    print(onError);
                  });
                });

              }
            }).catchError((onError){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            });

        });
      }
      else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LanguageSelection()));
      }
    }).catchError((onError){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    });


    return Scaffold(

      body: Stack(
        children: <Widget>[
          Image.asset(
              "assets/images/starter.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 50.0,
            child:Center(child: CircularProgressIndicator()) ,
          )

        ],
      ),
    );
  }
}
