import 'package:evd_retailer/Components/ForceSyncComponent/force_sync.dart';
import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Providers/SellCardProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PrintCards extends StatefulWidget{
  final int amount;

  PrintCards(this.amount);

  @override
  _PrintCardsState createState() => _PrintCardsState();
}

class _PrintCardsState extends State<PrintCards> {
  FocusNode _batchFocus = FocusNode();
  TextEditingController batchController;

  void listenToBatchController(BuildContext context) {
    if (int.tryParse(batchController.text) == null) {
      Fluttertoast.showToast(
          msg: getTranslated(context, "SendScreen.onlyNumber"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  bool validateBatchInput(MasterProvider masterProvider, String countString,
      SellCardProvider sellCardProvider,BuildContext context) {
    int count;
    if (int.tryParse(countString) == null) {
      Fluttertoast.showToast(
          msg: getTranslated(context, "SendScreen.onlyNumber"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 16.0);
      return false;
    } else {
      count = int.parse(countString);
    }
    if ((int.parse(masterProvider.getUser.currentBalance) < ((sellCardProvider.getBatchAmount) * widget.amount))
        && ((!masterProvider.getDownloadedCards.containsKey("${widget.amount}")) || (( masterProvider.getDownloadedCards.containsKey("${widget.amount}")) && (masterProvider.getDownloadedCards["${widget.amount}"].isEmpty || masterProvider.getDownloadedCards["${widget.amount}"].length < sellCardProvider.getBatchAmount )) )
    ) {
      Fluttertoast.showToast(
          msg:
          getTranslated(context, "SendScreen.balanceInsufficient"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 16.0);
      return false;
    } else if (count > masterProvider.getUser.maxPrintCount) {
      Fluttertoast.showToast(
          msg:
          "${getTranslated(context, "SendScreen.printingLimit")} ${masterProvider.getUser.maxPrintCount}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 16.0);
      return false;
    } else {
      sellCardProvider.setBatchAmount = count;
      return true;
    }
  }

  @override
  void initState(){
    super.initState();
    batchController = TextEditingController();
    batchController.text = "1";
  }
  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen:false);
    SellCardProvider sellCardProvider =
    Provider.of<SellCardProvider>(context, listen: false);
    batchController.addListener(() => listenToBatchController(context));
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Consumer<MasterProvider>(
              builder: ((context, provider, child) {
                if (provider.isPrintingCards) {
                  return Column(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                            text: "${widget.amount}",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                " ${getTranslated(context, "SendScreen.print_title")}",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                      Container(
                        height: 10.0,
                      ),
                      Center(child: CircularProgressIndicator()),
                      Container(
                        height: 10.0,
                      ),
                      Text(
                        getTranslated(context, "SendScreen.pleaseWaitForPrintingCards"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                            text: "${widget.amount}",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                " ${getTranslated(context, "SendScreen.print_title")}",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 40,
                            child: Card(
                              color: Theme.of(context).buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(0.0),
                                    bottomRight: Radius.circular(0.0),
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0)),
                              ),
                              margin: EdgeInsets.all(0.0),
                              child: IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  if (int.tryParse(
                                      batchController.text) !=
                                      null) {
                                    sellCardProvider.setBatchAmount =
                                        int.parse(
                                            batchController.text);
                                  }

                                  if (sellCardProvider
                                      .getBatchAmount -
                                      1 <
                                      1) {
                                    Fluttertoast.showToast(
                                        msg:
                                        getTranslated(context, "SendScreen.minimumIsOne"),
                                        toastLength:
                                        Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.black,
                                        fontSize: 16.0);
                                  } else {
                                    sellCardProvider.setBatchAmount =
                                        sellCardProvider
                                            .getBatchAmount -
                                            1;
                                  }
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 40,
                            child: Card(
                                shape: Border.all(
                                    style: BorderStyle.none),
                                margin: EdgeInsets.all(0.0),
                                child: Center(
                                    child: Consumer<SellCardProvider>(
                                      builder:
                                      ((child, provider, context) {
                                        batchController.text = provider
                                            .getBatchAmount
                                            .toString();
                                        _batchFocus.unfocus();
                                        return Container(
                                          child: TextFormField(

                                            focusNode: _batchFocus,
                                            controller: batchController,
                                            readOnly: false,
                                            textAlign: TextAlign.center,
                                            keyboardType:
                                            TextInputType.number,
                                            decoration: InputDecoration(
                                                border: InputBorder.none
                                            ),

                                          ),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(width: 0.2),
                                                  bottom: BorderSide(width: 0.2)

                                              )
                                          ),
                                        );
                                      }),
                                    ))),
                          ),
                          Container(
                            width: 80,
                            height: 40,
                            child: Card(
                              color: Theme.of(context).buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                    topLeft: Radius.circular(0.0),
                                    bottomLeft: Radius.circular(0.0)),
                              ),
                              margin: EdgeInsets.all(0.0),
                              child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  if (int.tryParse(batchController.text) !=null) {
                                    sellCardProvider.setBatchAmount =int.parse(batchController.text);
                                  }
                                  if ((int.parse(provider.getUser.currentBalance) < ((sellCardProvider.getBatchAmount + 1) * widget.amount))
                                      && ((!provider.getDownloadedCards.containsKey("${widget.amount}")) || (( provider.getDownloadedCards.containsKey("${widget.amount}")) && (provider.getDownloadedCards["${widget.amount}"].isEmpty || provider.getDownloadedCards["${widget.amount}"].length < (sellCardProvider.getBatchAmount + 1) )) )
                                  ) {
                                    Fluttertoast.showToast(
                                        msg:
                                        getTranslated(context, "SendScreen.balanceInsufficient"),
                                        toastLength:
                                        Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.black,
                                        fontSize: 16.0);
                                  } else if (sellCardProvider
                                      .getBatchAmount +
                                      1 >
                                      masterProvider
                                          .getUser.maxPrintCount) {
                                    Fluttertoast.showToast(
                                        msg:
                                        "${getTranslated(context, "SendScreen.printingLimit")} ${masterProvider.getUser.maxPrintCount}",
                                        toastLength:
                                        Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.black,
                                        fontSize: 16.0);
                                  } else {
                                    sellCardProvider.setBatchAmount =
                                        sellCardProvider
                                            .getBatchAmount +
                                            1;
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: RaisedButton(
                                  onPressed: () async {
                                    if (!provider.getConnectedToBluetooth ||
                                        provider.isPrintingCards ||
                                        provider.isDownloadingCards ||
                                        provider.isReFillingCards
                                    ) {
                                      return;
                                    } else if (!validateBatchInput(
                                        provider,
                                        batchController.text,
                                        sellCardProvider,
                                        context
                                    )) {
                                      return;
                                    }

                                    provider.setPrintingCards = true;

                                    int status = await HttpCalls
                                        .getBatchDownloads(
                                        widget.amount,
                                        provider,
                                        sellCardProvider
                                            .getBatchAmount);

                                        if(provider.getTotalUnSyncedCards >= provider.getUser.syncMaxLimit) {
                                          await SharedPref.setForceSync(true);
                                        }

                                    provider.setPrintingCards = false;

                                    if (status == 200) {
                                      Fluttertoast.showToast(
                                          msg:
                                          getTranslated(context, "SendScreen.successfullyProcessed"),
                                          toastLength:
                                          Toast.LENGTH_SHORT,
                                          gravity:
                                          ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                          Colors.green,
                                          textColor: Colors.black,
                                          fontSize: 16.0);
                                      sellCardProvider.setBatchAmount = 1;
                                      if(provider.getTotalUnSyncedCards >= provider.getUser.syncMaxLimit){
                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> ForceSync()), (route) => false);
                                      }
                                      // Navigator.pop(context);

                                    } else if (status == 204) {
                                      Fluttertoast.showToast(
                                          msg:
                                          getTranslated(context, "SendScreen.noCardsAvailable"),
                                          toastLength:
                                          Toast.LENGTH_LONG,
                                          gravity:
                                          ToastGravity.CENTER,
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
                                          toastLength:
                                          Toast.LENGTH_LONG,
                                          gravity:
                                          ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else if (status == 1) {
                                      Fluttertoast.showToast(
                                          msg:
                                          getTranslated(context, "SendScreen.dbError"),
                                          toastLength:
                                          Toast.LENGTH_LONG,
                                          gravity:
                                          ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else if (status == -1) {
                                      Fluttertoast.showToast(
                                          msg:
                                          getTranslated(context,"SendScreen.checkInternetConnection"),
                                          toastLength:
                                          Toast.LENGTH_LONG,
                                          gravity:
                                          ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  },
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Text(
                                      getTranslated(context,
                                          "SendScreen.print_button"),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20),
                                    ),
                                  ),
                                  color: provider
                                      .getConnectedToBluetooth
                                      ? Theme.of(context).buttonColor
                                      : Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight:
                                        Radius.circular(8.0),
                                        bottomRight:
                                        Radius.circular(8.0),
                                        topLeft: Radius.circular(8.0),
                                        bottomLeft:
                                        Radius.circular(8.0)),
                                  ))),
                        ],
                      ),
                    ],
                  );
                }
              }),
            )),
      ),
    );
  }
}