import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/Validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePassword extends StatefulWidget{

  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword>{


  TextEditingController phoneController, otpController, passwordController, reTypePasswordController;
  bool otpReceived = false;
  bool showCircularProgress = false;

  final formKey = GlobalKey<FormState>();



  @override
  void initState(){
    super.initState();
    phoneController = TextEditingController();
    otpController = TextEditingController();
    passwordController = TextEditingController();
    reTypePasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "PasswordScreen.title"),style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: otpReceived ?
              Column(
                children: <Widget>[
                  SizedBox(height: 30,),
                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: otpController,
                          validator: (value){
                            return Validator.validatePassword(value,context,isOtp: true);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.vpn_key),
                              labelText: getTranslated(context, "changePassword.code")

                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: passwordController,
                          obscureText: true,
                          validator: (value){
                            return Validator.validatePassword(value,context);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.vpn_key),
                              labelText: getTranslated(context, "changePassword.password")

                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: reTypePasswordController,
                          obscureText: true,
                          validator: (value){
                            return Validator.validateConfirmationPassword(passwordController.text ,value,context);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.vpn_key),
                              labelText: getTranslated(context, "changePassword.reTypePassword")

                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 50,),
                  Row(
                    children: <Widget>[
                      Expanded(child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27.0)
                        ),
                        onPressed: () async{
                          if(!formKey.currentState.validate()){
                            return;
                          }
                          setState(() {
                            showCircularProgress = true;
                          });
                          int status = await HttpCalls.changePassword(otpController.text, phoneController.text, passwordController.text);
                          if(status == 200){
                            Fluttertoast.showToast(
                                msg: getTranslated(context, "changePassword.passwordSuccessfullyChanged"),
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                          else if(status == -1){
                            Fluttertoast.showToast(
                                msg: getTranslated(context, "changePassword.pleaseConnectToTheInternet"),
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.black,
                                fontSize: 16.0);
                          }
                          else{
                          }
                          setState(() {
                            if(status == 200) otpReceived = false;
                            showCircularProgress = false;

                          });
                          if(status == 200) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(getTranslated(context, "PasswordScreen.submit"),style: TextStyle(fontSize: 24,color: Colors.white),),
                        ),


                      ))
                    ],
                  ),
                  showCircularProgress ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()),
                  ) : Container(height: 50.0,)
                ],
              )

              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10,),
              Text(getTranslated(context, "PasswordScreen.text"),style: TextStyle(color: Colors.grey),),
              SizedBox(height: 30,),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
                validator: (value){
                  return Validator.validatePhone(value,context);
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: getTranslated(context, "changePassword.phoneNumber")

                ),
              ),
              SizedBox(height: 50,),
              Row(
                children: <Widget>[
                  Expanded(child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27.0)
                    ),
                    onPressed: () async{
                      if(Validator.validatePhone(phoneController.text,context) != null){
                        return;
                      }
                      setState(() {
                        showCircularProgress = true;
                      });
                      int status = await HttpCalls.getOtp(phoneController.text);
                      if(status == 200){
                        Fluttertoast.showToast(
                            msg: getTranslated(context, "changePassword.weHaveSentOTP"),
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                      else if(status == -1){
                        // no internet
                      }
                      else{
                        Fluttertoast.showToast(
                            msg: getTranslated(context, "changePassword.pleaseTryAgain"),
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.black,
                            fontSize: 16.0);
                      }
                      setState(() {
                        showCircularProgress = false;
                        if(status == 200) otpReceived = true;

                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(getTranslated(context, "PasswordScreen.get_code"),style: TextStyle(fontSize: 24,color: Colors.white),),
                    ),

                  ))
                ],
              ),
              showCircularProgress ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(child: CircularProgressIndicator()),
              ) : Container(height: 20.0,)
            ],
          ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose(){
    phoneController.dispose();
    otpController.dispose();
    passwordController.dispose();
    reTypePasswordController.dispose();
    super.dispose();
  }
}