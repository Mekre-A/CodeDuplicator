import 'package:evd_retailer/Components/AllComponent/all.dart';
import 'package:evd_retailer/Components/ChangePasswordComponent/change_password.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Providers/localization.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:evd_retailer/Services/Validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginBody extends StatefulWidget{

  LoginBodyState createState() => LoginBodyState();
}

class LoginBodyState extends State<LoginBody>{
  TextEditingController phoneController;
  TextEditingController passwordController;
  final formKey = GlobalKey<FormState>();


  @override
  void initState(){
    super.initState();
    phoneController = TextEditingController();
    passwordController = TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);
    LocalizationProvider localizationProvider = Provider.of<LocalizationProvider>(context,listen: false);

    SharedPref.isLanguageSet().then((value){
      if(!value){
        if(localizationProvider.getLocale.languageCode == "am"){
          SharedPref.setAmharicAsLanguage();
        }
        else{
          SharedPref.setEnglishAsLanguage();
        }
      }
    });


    return Column(

      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          children: <Widget>[
            Image.asset(
              "assets/images/login.png",
              scale: 1.4,
              fit: BoxFit.scaleDown,
            ),
            SizedBox(height: 10,),
            Text("Test Retailer",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
          ],
        ),

        Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.phone,
                  validator: (value){
                    return Validator.validatePhone(value,context);
                  },
                  controller: phoneController,
                  decoration: InputDecoration(
                      labelText: getTranslated(context, "LoginScreen.phoneNumber"),
                      prefixIcon: Icon(Icons.phone)

                  ),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.phone,
                  validator: (value){
                    return Validator.validatePassword(value,context);
                  },
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: getTranslated(context, "LoginScreen.password"),
                      prefixIcon: Icon(Icons.vpn_key)
                  ),
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Consumer<MasterProvider>(builder: ((context, provider,child){
                      if(provider.isLoggingIn){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(height: 10,),
                            Center(child: CircularProgressIndicator()),
                            Container(height: 10,),
                            Consumer<MasterProvider>(builder: ((context,provider,child){
                              if(provider.isDownloadingOnLogin){
                                return  Center(child: Text(getTranslated(context, "LoginScreen.pleaseBePatient"),style: TextStyle(fontWeight: FontWeight.bold),));
                              }
                              else{
                                return Container();
                              }
                            }),)

                          ],
                        );
                      }
                      else{
                        return Expanded(child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27.0)
                          ),
                          onPressed: () async{
                            if(!formKey.currentState.validate()){
                              return;
                            }
                            provider.setIsLoggingIn = true;


                            int apiCheck = await HttpCalls.getBaseUrlAndKey(masterProvider);


                            if(apiCheck == 200){

                            }
                            else if(apiCheck == 301){
                              Fluttertoast.showToast(
                                  msg: getTranslated(context, "LoginScreen.updateApp"),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return ;
                            }
                            else if(apiCheck == 500){
                              Fluttertoast.showToast(
                                  msg: getTranslated(context, "LoginScreen.oops"),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            }
                            else if(apiCheck == 1){
                              Fluttertoast.showToast(
                                  msg: getTranslated(context, "LoginScreen.dbError"),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            }
                            else if(apiCheck == -1){
                              Fluttertoast.showToast(
                                  msg: getTranslated(context, "LoginScreen.checkInternetConnection"),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            }

                            int status = await HttpCalls.login(phoneController.text, passwordController.text,masterProvider);


                            provider.setIsLoggingIn = false;
                            provider.setDownloadingOnLogin = false;

                            if(status == 200|| status == 204){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => All() ));
                            }
                            else if(status == 301){
                              Fluttertoast.showToast(
                                  msg: getTranslated(context, "LoginScreen.updateApp"),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            else if(status == 401){
                              Fluttertoast.showToast(
                                  msg: getTranslated(context, "LoginScreen.wrongUsernameOrPassword"),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }

                            else if(status == 500){
                              Fluttertoast.showToast(
                                  msg: getTranslated(context, "LoginScreen.oops"),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            else if(status == 1){
                              Fluttertoast.showToast(
                                  msg: getTranslated(context, "LoginScreen.dbError"),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            else if(status == -1){
                              Fluttertoast.showToast(
                                  msg: getTranslated(context, "LoginScreen.checkInternetConnection"),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },

                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(getTranslated(context, "LoginScreen.login"),style: TextStyle(fontSize: 24,color: Colors.white),),
                          ),

                        ));
                      }
                    }),)

                  ],
                ),
              ],
            ),
          ),
        ),

        Consumer<MasterProvider>(builder: ((context,provider,child){
          if(!provider.isLoggingIn){
            return InkWell(
              child: Text(getTranslated(context, "LoginScreen.change_password"),style: TextStyle(fontSize: 24,color: Colors.green),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
              }
              ,
            );
          }
          else{
            return Container();
          }
        }),),
        Text("v3.6.2",style:TextStyle(color: Colors.grey))
      ],
    );
  }
}