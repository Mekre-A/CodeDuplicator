import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Providers/SellCardProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class DownloadCards extends StatefulWidget{

  final int amount;

  DownloadCards(this.amount);

  @override
  _DownloadCardsState createState() => _DownloadCardsState();
}

class _DownloadCardsState extends State<DownloadCards> {
  TextEditingController downloadController;
  FocusNode _downloadFocus = FocusNode();

  void listenToDownloadController(BuildContext context) {
    if (int.tryParse(downloadController.text) == null) {
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

  bool validateDownloadInput(MasterProvider masterProvider, String countString,
      SellCardProvider sellCardProvider, BuildContext context) {
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
    if (int.parse(masterProvider.getUser.currentBalance) <
        ((count) * widget.amount)) {
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
    } else if (masterProvider.getUser.offlineLimitBirr < masterProvider.getStockBalance + (count * widget.amount)
        ) {
      Fluttertoast.showToast(
          msg:
          "${getTranslated(context, "SendScreen.offlineLimitBirr")} ${masterProvider.getUser.offlineLimitBirr} ${getTranslated(context, "CardHistoryScreen.etb")}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 16.0);
      return false;
    } else if (masterProvider.getUser.offlineLimitCount < (count + masterProvider.getStockCount)) {
      Fluttertoast.showToast(
          msg:
          "${getTranslated(context, "SendScreen.storingLimit")} ${masterProvider.getUser.offlineLimitCount}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 16.0);
      return false;
    } else {
      sellCardProvider.setDownloadAmount = count;
      return true;
    }
  }

  @override
  void initState(){
    super.initState();
    downloadController = TextEditingController();
    downloadController.text = "1";
  }

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen:false);
    SellCardProvider sellCardProvider =
    Provider.of<SellCardProvider>(context, listen: false);
    downloadController.addListener(() => listenToDownloadController(context));

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Consumer<MasterProvider>(
              builder: ((context, provider, child) {
                if (provider.isDownloadingCards) {
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
                                text: " ${getTranslated(context, "SendScreen.birrCardDownload")}",
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
                        getTranslated(context, "SendScreen.pleaseWaitForDownloadingCards"),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  );
                }
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
                              text: " ${getTranslated(context, "SendScreen.birrCardDownload")}",
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
                                    downloadController.text) !=
                                    null) {
                                  sellCardProvider.setDownloadAmount =
                                      int.parse(
                                          downloadController.text);
                                }
                                if (masterProvider
                                    .getUser.offlineLimitBirr <
                                    widget.amount) {
                                } else if (sellCardProvider
                                    .getDownloadAmount -
                                    1 <
                                    1) {
                                  Fluttertoast.showToast(
                                      msg:
                                      getTranslated(context, "SendScreen.minimumIsOneDownloading"),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.black,
                                      fontSize: 16.0);
                                } else {
                                  sellCardProvider.setDownloadAmount =
                                      sellCardProvider
                                          .getDownloadAmount -
                                          1;
                                }
                              },
                            ),
                          ),
                        ),
                        Consumer<SellCardProvider>(
                          builder: ((child, provider, context) {
                            downloadController.text =
                                provider.getDownloadAmount.toString();
                            _downloadFocus.unfocus();
                            return Container(
                              width: 80,
                              height: 40,
                              child: Card(
                                  shape: Border.all(
                                      style: BorderStyle.none),
                                  margin: EdgeInsets.all(0.0),
                                  child: Center(
                                      child: Container(
                                        child: TextFormField(
                                          focusNode: _downloadFocus,
                                          controller: downloadController,
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

                                      )


                                  )),
                            );
                          }),
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
                                if (int.tryParse(
                                    downloadController.text) !=
                                    null) {
                                  sellCardProvider.setDownloadAmount =
                                      int.parse(
                                          downloadController.text);
                                }
                                if (masterProvider
                                    .getUser.offlineLimitBirr <
                                    widget.amount) {
                                } else if (int.parse(masterProvider
                                    .getUser.currentBalance) <
                                    ((sellCardProvider
                                        .getDownloadAmount +
                                        1) *
                                        widget.amount)) {
                                  Fluttertoast.showToast(
                                      msg:
                                      getTranslated(context, "SendScreen.balanceInsufficient"),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.black,
                                      fontSize: 16.0);
                                } else if (masterProvider
                                    .getUser.offlineLimitBirr <
                                    ((sellCardProvider
                                        .getDownloadAmount +
                                        1) *
                                        widget.amount)) {
                                  Fluttertoast.showToast(
                                      msg:
                                      "${getTranslated(context, "SendScreen.offlineLimitBirr")} ${masterProvider.getUser.offlineLimitBirr}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.black,
                                      fontSize: 16.0);
                                } else if (masterProvider
                                    .getUser.offlineLimitCount <
                                    sellCardProvider
                                        .getDownloadAmount +
                                        1) {
                                  Fluttertoast.showToast(
                                      msg:
                                      "${getTranslated(context, "SendScreen.storingLimit")} ${masterProvider.getUser.offlineLimitCount}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.black,
                                      fontSize: 16.0);
                                } else {
                                  sellCardProvider.setDownloadAmount =
                                      sellCardProvider
                                          .getDownloadAmount +
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                              onPressed: () async {
                                if (provider.getUser.offlineLimitBirr < widget.amount ||
                                    provider.isPrintingCards ||
                                    provider.isDownloadingCards ||
                                    provider.isReFillingCards

                                ) {
                                  return;
                                } else if (!validateDownloadInput(
                                    masterProvider,
                                    downloadController.text,
                                    sellCardProvider,
                                    context
                                )) {
                                  return;
                                }
                                masterProvider.setDownloadingCards = true;

                                int status =
                                await HttpCalls.downloadCards(
                                    sellCardProvider
                                        .getDownloadAmount,
                                    widget.amount,
                                    masterProvider);

                                masterProvider.setDownloadingCards = false;

                                if (status == 200) {
                                  Fluttertoast.showToast(
                                      msg:
                                      "${getTranslated(context, "SendScreen.successfullyBought")} (${sellCardProvider.getDownloadAmount}) , ${widget.amount} ${getTranslated(context, "SendScreen.birrCard")}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.black,
                                      fontSize: 16.0);
                                  Navigator.pop(context);
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
                                      msg:
                                      getTranslated(context, "SendScreen.dbError"),
                                      toastLength: Toast.LENGTH_SHORT,
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
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0),
                                child: Text(
                                  getTranslated(context, "SendScreen.download"),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                              ),
                              color: (masterProvider.getUser
                                  .offlineLimitBirr <
                                  widget.amount ||
                                  int.parse(masterProvider.getUser
                                      .currentBalance) <
                                      widget.amount)
                                  ? Colors.grey
                                  : Theme.of(context).buttonColor,
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
                  ],
                );
              }),
            )),
      ),
    );
  }
}