import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SyncAndConfirm extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context, listen: false);
    return ListTile(
      title: Text(getTranslated(context, "SettingScreen.syncAndConfirm"),style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xffF2C500)),),
      onTap: (){
        showDialog(
            context: context,
            barrierDismissible: false,
            child: SimpleDialog(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            getTranslated(context, "all.syncingInProgress")),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Center(child: CircularProgressIndicator())
                  ],
                ),
              ],
            ));
        if(masterProvider.getIsSyncing){
          return;
        }
        else{
          masterProvider.setIsSyncing = true;
        }
        HttpCalls.syncCardsBehindTheScenes(masterProvider).then((value) {
          masterProvider.setIsSyncing = false;
          if (value == 200 || value == 204) {
            Navigator.pop(context);
            showDialog(
                context: context,
                barrierDismissible: false,
                child: SimpleDialog(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(getTranslated(context, "all.allDataIsSynced")),
                          ),
                        ),
                        Container(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                getTranslated(context, "all.close"),
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.grey,
                            ),
                            FlatButton(
                              onPressed: (){
                                masterProvider.setIsSyncing = true;
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    child: SimpleDialog(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(
                                                    getTranslated(context, "all.confirmingInProgress")),
                                              ),
                                            ),
                                            Container(
                                              height: 10,
                                            ),
                                            Center(child: CircularProgressIndicator())
                                          ],
                                        ),
                                      ],
                                    ));
                                HttpCalls.getDownloadedCardsFromWeb(masterProvider,0).then((value){
                                  masterProvider.setIsSyncing = false;
                                  Navigator.pop(context);
                                  print(value);
                                  if(value != 200 && value != 204){
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        child: SimpleDialog(
                                          children: <Widget>[
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(getTranslated(context, "all.confirmingFailed")),
                                              ),
                                            ),
                                            Center(
                                              child: FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  getTranslated(context, "all.close"),
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ));
                                  }
                                  else{
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        child: SimpleDialog(
                                          children: <Widget>[
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(getTranslated(context, "all.allDataIsConfirmed")),
                                              ),
                                            ),
                                            Center(
                                              child: FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  getTranslated(context, "all.close"),
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ));
                                  }
                                });
                              },
                              child: Text(
                                getTranslated(context, "all.confirmCards"),
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.green,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ));
          } else if(value == 301 || value == 401){
            masterProvider.logOut();
            SharedPref.logOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Login()),
                    (route) => false);
          }
          else {
            Navigator.pop(context);
            showDialog(
                context: context,
                barrierDismissible: false,
                child: SimpleDialog(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(getTranslated(context, "all.syncingFailed")),
                      ),
                    ),
                  ],
                ));
          }
        }).catchError((onError){
          masterProvider.setIsSyncing = false;
          Navigator.pop(context);
          showDialog(
              context: context,
              barrierDismissible: false,
              child: SimpleDialog(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(getTranslated(context, "all.syncingFailed")),
                    ),
                  ),
                ],
              ));
        });
      },
    );
  }
}