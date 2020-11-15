
import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Components/SelectCreditAmountComponent/select_credit_amount.dart';
import 'package:evd_retailer/Components/SettingsComponent/settings.dart';
import 'package:evd_retailer/Models/SyncCard.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Providers/SelectCreditAmountProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:evd_retailer/Services/Validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class All extends StatefulWidget {
  @override
  AllState createState() => AllState();
}

class AllState extends State<All> {
  int _currentIndex = 0;

  TextEditingController startingRangeController, endingRangeController;

  @override
  void initState() {
    super.initState();
  }

  showErrorMessage(String errorMessage) {
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  showSuccessMessage(BuildContext context) {
    Fluttertoast.showToast(
        msg: getTranslated(context, "all.successfullyReprinted"),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  List<Widget> pages = [
    ChangeNotifierProvider(
      create: (BuildContext context) => SelectCreditAmountProvider(),
      child: SelectCreditAmount(),
    ),
    Container(),
    Container(),
    Settings()
  ];

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider =
        Provider.of<MasterProvider>(context, listen: false);

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: getTranslated(context, "all.home"),
          ),
          BottomNavigationBarItem(
            icon: Consumer<MasterProvider>(builder: ((context,provider,child){
              if(provider.getUser.syncWarningLimit == null){
                Future.delayed(Duration(seconds: 0)).then((value){
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Login()));
                });
                return Icon(Icons.sync);
              }
              else if(provider.getTotalUnSyncedCards >= provider.getUser.syncWarningLimit){
                return Icon(Icons.sync,color: Colors.red,);
              }
              else{
                return Icon(Icons.sync);
              }
            }),),
              label: getTranslated(context, "all.sync")

          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.print), label: getTranslated(context, "all.quickPrint")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: getTranslated(context, "MainScreen.settings")),
        ],
        currentIndex: _currentIndex,
        onTap: (int value) {
          if(value == 3){
            setState(() {
              _currentIndex = 3;
            });
          }
          if (value == 1) {
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
                Navigator.popUntil(context, (route) => route.isFirst);
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
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                  },
                                  child: Text(
                                getTranslated(context, "all.close"),
                                style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.grey,
                                ),
                                FlatButton(
                                  onPressed: (){
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                    masterProvider.setIsSyncing = true;
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
                                    HttpCalls.getDownloadedCardsFromWeb(masterProvider,1).then((value){
                                      masterProvider.setIsSyncing = false;
                                      Navigator.popUntil(context, (route) => route.isFirst);
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
                                                      Navigator.popUntil(context, (route) => route.isFirst);
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
                                                      Navigator.popUntil(context, (route) => route.isFirst);
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
                Navigator.popUntil(context, (route) => route.isFirst);
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
            });
          } else if (value == 2) {
            showDialog(
                context: context,
                child: FutureBuilder(
                  future: LocalCalls.getAllPrintedCards(masterProvider),
                  builder:
                      ((BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.isEmpty) {
                        return SimpleDialog(
                          children: <Widget>[
                            Center(
                                child: Text(
                                    getTranslated(context, "all.noCardsToReprint")))
                          ],
                        );
                      }
                      List<SyncCard> arrangedCards =
                          LocalCalls.removeDuplicate(snapshot.data);
                      int startingRange = arrangedCards.first.getOrderId;
                      int endingRange = arrangedCards.last.getOrderId;
                      startingRangeController =
                          TextEditingController(text: "$endingRange");
                      endingRangeController =
                          TextEditingController(text: "$endingRange");
                      return SimpleDialog(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                                getTranslated(context, "all.selectCardsBetween")),
                            Text("$startingRange-$endingRange")
                          ],
                        ),
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(width:50,child: Text("${getTranslated(context, "all.from")} - ")),

                              Container(
                                width: 100,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: startingRangeController,
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(width:50,child: Text("${getTranslated(context, "all.to")} - ")),

                              Container(
                                width: 100,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: endingRangeController,
                                ),
                              )
                            ],
                          ),

                          Consumer<MasterProvider>(
                            builder: ((context, provider, child) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(20.0,20.0,20.0,0.0),
                                child: RaisedButton(
                                  onPressed: () {
                                    if (!provider.getConnectedToBluetooth) {
                                      showErrorMessage(
                                          getTranslated(context, "all.connectToBluetoothFirst"));
                                    } else {
                                      if (Validator
                                              .validateNumberIsBetweenRange(
                                                  startingRangeController.text,
                                                  startingRange,
                                                  endingRange,context) !=
                                          null) {
                                        showErrorMessage(Validator
                                            .validateNumberIsBetweenRange(
                                                startingRangeController.text,
                                                startingRange,
                                                endingRange,context));
                                      } else if (Validator
                                              .validateNumberIsBetweenRange(
                                                  endingRangeController.text,
                                                  startingRange,
                                                  endingRange,context) !=
                                          null) {
                                        showErrorMessage(Validator
                                            .validateNumberIsBetweenRange(
                                                endingRangeController.text,
                                                startingRange,
                                                endingRange,context));
                                      } else {
                                        LocalCalls.rePrintWithRange(
                                            arrangedCards,
                                            int.parse(
                                                startingRangeController.text),
                                            int.parse(
                                                endingRangeController.text),
                                            masterProvider);
                                        showSuccessMessage(context);
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  child: Text(
                                    getTranslated(context, "all.print"),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: provider.getConnectedToBluetooth
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              );
                            }),
                          )
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
                ));
          } else {
            setState(() {
              _currentIndex = value;
            });
          }
        },
      ),
    );
  }
}
