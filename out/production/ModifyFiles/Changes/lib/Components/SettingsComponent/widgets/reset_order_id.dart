import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/LocalCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ResetOrderId extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context, listen: false);
    return ListTile(
      title: Text(getTranslated(context, "SettingScreen.resetOrderId")),
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
                            "${getTranslated(context, "SettingScreen.areYouSure")} ?"),
                      ),
                    ),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FlatButton(
                          child:Text(getTranslated(context, "SettingScreen.cancel"),style: TextStyle(color: Colors.white),),
                          color:Colors.red,
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child:Text(getTranslated(context, "SettingScreen.reset"),style: TextStyle(color: Colors.white)),
                          color:Colors.green,
                          onPressed: (){
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
                                                getTranslated(context, "SettingScreen.resettingInProgress")),
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
                            LocalCalls.resetOrderId(masterProvider).then((value)async{
                              Navigator.pop(context);
                              if(value == 200){
                                Fluttertoast.showToast(
                                    msg: getTranslated(context, "SettingScreen.resettingSuccessful"),
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                              else if (value == 401 ||
                                  value == 301) {
                                await masterProvider.logOut();
                                SharedPref.logOut();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Login()),
                                        (route) => false);
                              }
                              else if(value == -1){
                                Fluttertoast.showToast(
                                    msg: getTranslated(context, "SettingScreen.pleaseConnectToTheInternet"),
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                              else if(value == 1){
                                Fluttertoast.showToast(
                                    msg: getTranslated(context, "SettingScreen.localIssue"),
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                              else{
                                Fluttertoast.showToast(
                                    msg: getTranslated(context, "SettingScreen.resettingFailed"),
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            });
                          },
                        )
                      ],
                    )
                  ],
                ),
              ],
            ));
      },
    );
  }
}