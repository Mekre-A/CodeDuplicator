import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Providers/ReprintWithSerialProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:evd_retailer/Services/Validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ReprintWithSerial extends StatefulWidget {
  @override
  _ReprintWithSerialState createState() => _ReprintWithSerialState();
}

class _ReprintWithSerialState extends State<ReprintWithSerial> {
  TextEditingController startingController, endingController;

  @override
  void initState() {
    super.initState();
    startingController = TextEditingController();
    endingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    ReprintWithSerialProvider reprintWithSerialProvider =
        Provider.of<ReprintWithSerialProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "reprintWithSerial.reprintWithSerial")),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return Validator.validateSerialNumber(
                          startingController.text, context);
                    },
                    controller: startingController,
                    decoration: InputDecoration(
                        hintText: getTranslated(context, "reprintWithSerial.from"),

                    ),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return Validator.validateSerialNumber(
                          endingController.text, context);
                    },
                    controller: endingController,
                    decoration: InputDecoration(hintText: getTranslated(context, "reprintWithSerial.to")),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 40.0),
                    child: Row(
                      children: [
                        Expanded(child: Consumer<ReprintWithSerialProvider>(
                          builder: ((context, reprintSerialProvider, child) {
                            if (reprintSerialProvider.getIsFetchingOrPrinting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return Consumer<MasterProvider>(builder: ((context,masterProvider,child){
                              return RaisedButton(
                                color: masterProvider.getConnectedToBluetooth? Theme.of(context).buttonColor : Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(getTranslated(context, "reprintWithSerial.print"),
                                      style:
                                      TextStyle(color: Colors.white, fontSize: 20)),
                                ),
                                onPressed: () async {
                                  if(!masterProvider.getConnectedToBluetooth){
                                    Fluttertoast.showToast(
                                        msg: getTranslated(context, "reprintWithSerial.connectToThePrinterFirst"),
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    return;
                                  }

                                  if ((Validator.validateSerialNumber(
                                      startingController.text, context) !=
                                      null) ||
                                      (Validator.validateSerialNumber(
                                          endingController.text, context) !=
                                          null)) {
                                    return;
                                  }

                                  reprintSerialProvider.setIsFetchingOrPrinting =
                                  true;
                                  int status = await HttpCalls.getCardsBySerial(
                                      masterProvider,
                                      reprintSerialProvider,
                                      startingController.text,
                                      endingController.text);

                                  if (status == 200) {
                                    await LocalCalls.printBySerial(masterProvider, reprintSerialProvider.getNoSyncCards);
                                    reprintSerialProvider.setIsFetchingOrPrinting =
                                    false;
                                    reprintWithSerialProvider.setNoSyncCards = [];
                                  } else if (status == 204) {
                                    Fluttertoast.showToast(
                                        msg: getTranslated(context, "reprintWithSerial.outOfRange"),
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    reprintSerialProvider.setIsFetchingOrPrinting =
                                    false;
                                  } else if (status == 301 || status == 401) {
                                    reprintSerialProvider.setIsFetchingOrPrinting =
                                    false;
                                    await masterProvider.logOut();
                                    SharedPref.logOut();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Login()),
                                            (route) => false);
                                  }
                                    else if (status == 500) {
                                    Fluttertoast.showToast(
                                        msg: getTranslated(context, "reprintWithSerial.oops"),
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    reprintSerialProvider.setIsFetchingOrPrinting =
                                    false;
                                  }  else if (status == -1) {
                                    Fluttertoast.showToast(
                                        msg: getTranslated(context, "reprintWithSerial.checkInternetConnection"),
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    reprintSerialProvider.setIsFetchingOrPrinting =
                                    false;
                                  }
                                },
                              );
                            }),);

                          }),
                        )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
