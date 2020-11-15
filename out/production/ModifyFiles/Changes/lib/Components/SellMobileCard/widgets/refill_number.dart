import 'package:evd_retailer/Components/ForceSyncComponent/force_sync.dart';
import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:evd_retailer/Services/Validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RefillNumber extends StatefulWidget{
  final int amount;

  RefillNumber(this.amount);

  @override
  _RefillNumberState createState() => _RefillNumberState();
}

class _RefillNumberState extends State<RefillNumber> {

  TextEditingController phoneController;
  FocusNode _focus = FocusNode();

  bool autovalidate = false;

  void hasFocus() {
    setState(() {
      autovalidate = true;
    });
  }

  @override
  void initState(){
    super.initState();
    phoneController = TextEditingController();
    _focus.addListener(hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen:false);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Consumer<MasterProvider>(
              builder: ((context, provider, child) {
                if (provider.isReFillingCards) {
                  return Column(
                    children: <Widget>[
                      Center(child: CircularProgressIndicator()),
                      Container(
                        height: 10.0,
                      ),
                      Text(
                        getTranslated(context, "SendScreen.pleaseWaitForRefillingCards"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  );
                }
                return Column(
                  children: <Widget>[
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      focusNode: _focus,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return Validator.validatePhone(value,context);
                      },
                      decoration:
                      InputDecoration(labelText: getTranslated(context, "SendScreen.phoneNumber")),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                              onPressed: () async {
                                if (Validator.validatePhone(phoneController.text,context) != null ||
                                    provider.isPrintingCards ||
                                    provider.isDownloadingCards ||
                                    provider.isReFillingCards ||
                                    (int.parse(provider.getUser.currentBalance) < widget.amount &&
                                        ((!provider.getDownloadedCards.containsKey("${widget.amount}")) || ( provider.getDownloadedCards.containsKey("${widget.amount}") && provider.getDownloadedCards["${widget.amount}"].isEmpty))

                                    )
                                ) {
                                  return;
                                }
                                provider.setReFillingCards = true;
                                
                                int status =
                                await HttpCalls.refillWithNumber(
                                    phoneController.text,
                                    masterProvider,
                                    widget.amount);

                                if(provider.getTotalUnSyncedCards >= 5000) {
                                  await SharedPref.setForceSync(true);
                                }
                                provider.setReFillingCards = false;
                                if (status == 200) {
                                  Fluttertoast.showToast(
                                      msg: getTranslated(context, "SendScreen.successfullyProcessed"),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.black,
                                      fontSize: 16.0);
                                  if(provider.getTotalUnSyncedCards >= 5000){
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> ForceSync()), (route) => false);
                                  }
                                  else{
                                    Navigator.pop(context);
                                  }
                                } else if (status == 204) {
                                  Fluttertoast.showToast(
                                      msg:
                                      getTranslated(context, "SendScreen.noCardsAvailable"),
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else if (status == 401 ||
                                    status == 301) {
                                  await masterProvider.logOut();
                                  SharedPref.logOut();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Login()),
                                          (route) => false);
                                } else if (status == 500) {
                                  Fluttertoast.showToast(
                                      msg:
                                      getTranslated(context, "SendScreen.oops"),
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else if (status == 1) {
                                  Fluttertoast.showToast(
                                      msg: getTranslated(context, "SendScreen.dbError"),
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else if (status == -1) {
                                  Fluttertoast.showToast(
                                      msg:
                                      getTranslated(context, "SendScreen.checkInternetConnection"),
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else if (status == 3) {
                                  Fluttertoast.showToast(
                                      msg:
                                      getTranslated(context, "SendScreen.allowPermissionToUseMethod"),
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0),
                                child: Text(
                                  getTranslated(context,
                                      "SendScreen.refill_airtime"),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0)),
                              )),
                        )
                      ],
                    ),
                    Consumer<MasterProvider>(
                      builder: ((context, provider, child) {
                        if (provider.isReFillingCards) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Container();
                        }
                      }),
                    )
                  ],
                );
              }),
            )),
      ),
    );
  }
}