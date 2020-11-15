import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/AgentsProvider.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:evd_retailer/Services/Validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AgentActivation extends StatefulWidget{

  final String phoneNumber;

  AgentActivation(this.phoneNumber);

  @override
  _AgentActivationState createState() => _AgentActivationState();
}

class _AgentActivationState extends State<AgentActivation> {
  TextEditingController otpController;
  @override
  void initState(){
    super.initState();
    otpController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "agent.activation")),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: otpController,
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          hintText: getTranslated(context, "agent.otp"),
                          border: OutlineInputBorder()
                      ),

                      validator: (value){
                        return Validator.validatePassword(value, context,isOtp: true);
                      },
                    ),

                    SizedBox(height: 30,),
                    Consumer<AgentsProvider>(builder: ((context,provider,child){
                      if(provider.getIsFillingOTP){
                        return CircularProgressIndicator();
                      }
                      if(provider.getIsManuallyRequestingActivation){
                        return Container();
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              onPressed: ()async{
                                if(Validator.validatePassword(otpController.text, context,isOtp: true) != null){
                                  return;
                                }
                                provider.setIsFillingOTP =  true;
                                int code = await HttpCalls.activateAgent(masterProvider, otpController.text,widget.phoneNumber );
                                provider.setIsFillingOTP =  false;
                                if(code == 200){
                                  Fluttertoast.showToast(
                                      msg: getTranslated(context, "agent.successfullyRegistered"),
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Navigator.pop(context, 1);
                                }
                                else if (code == 301 || code == 401) {

                                  await masterProvider.logOut();
                                  SharedPref.logOut();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Login()),
                                          (route) => false);
                                }
                                else if(code == 400){
                                  Fluttertoast.showToast(
                                      msg: getTranslated(context,"agent.wrongOTP"),
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                                else if(code == 500){
                                  Fluttertoast.showToast(
                                      msg: getTranslated(context, "agent.oops"),
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                                else if(code == -1){
                                  Fluttertoast.showToast(
                                      msg: getTranslated(context, "agent.checkInternetConnection"),
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }


                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(getTranslated(context, "agent.activate"),style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50,),
            Consumer<AgentsProvider>(builder: ((context,provider,child){
              if(provider.getIsFillingOTP){
                return Container();
              }
              if(provider.getIsManuallyRequestingActivation){
                return CircularProgressIndicator();
              }
              return Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      onPressed: ()async{
                        provider.setManuallyRequestingActivation =  true;
                        int code = await HttpCalls.resendOTP(masterProvider,widget.phoneNumber);
                        provider.setManuallyRequestingActivation =  false;
                        if(code == 200){
                          Fluttertoast.showToast(
                              msg: getTranslated(context, "agent.successfullyResentOTP"),
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        else if (code == 301 || code == 401) {

                          await masterProvider.logOut();
                          SharedPref.logOut();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Login()),
                                  (route) => false);
                        }
                        else if(code == 400){
                          Fluttertoast.showToast(
                              msg: getTranslated(context,"agent.wrongOTP"),
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        else if(code == 500){
                          Fluttertoast.showToast(
                              msg: getTranslated(context, "agent.oops"),
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        else if(code == -1){
                          Fluttertoast.showToast(
                              msg: getTranslated(context, "agent.checkInternetConnection"),
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }


                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(getTranslated(context, "agent.resendOTP"),style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                ],
              );
            }),),

          ],
        ),
      ),
    );
  }
}