import 'dart:ui';

import 'file:///D:/Projects/Quantum/evd_retailer/lib/Components/SelectCreditAmountComponent/widgets/drawer.dart';
import 'package:evd_retailer/Components/ChangeLanguageComponent/change_language.dart';
import 'package:evd_retailer/Components/LockedComponent/locked.dart';
import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Components/SelectCreditAmountComponent/widgets/AmountOfCreditContainer.dart';
import 'package:evd_retailer/Components/SelectCreditAmountComponent/widgets/paired_devices_item.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/BluetoothPrinterConnection.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SelectCreditAmount extends StatefulWidget {
  SelectCreditAmountState createState() => SelectCreditAmountState();
}

class SelectCreditAmountState extends State<SelectCreditAmount> {

  bool showCircularProgress = false;
  final formatCurrency = NumberFormat.simpleCurrency(decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider =
        Provider.of<MasterProvider>(context, listen: false);


    BluetoothPrinterConnection.initPlatformState(masterProvider);




    return Scaffold(

      appBar: AppBar(
        title: Text(getTranslated(context, "MainScreen.title")),
        centerTitle: true,

        actions: <Widget>[
          IconButton(icon:Consumer<MasterProvider>(builder: ((context,provider,child) {
            if(provider.getConnectedToBluetooth){
              return Icon(Icons.bluetooth_connected);
            }
            else{
              return Icon(Icons.bluetooth);
            }
          }),),onPressed: () async{
            if(masterProvider.getConnectedToBluetooth){
              masterProvider.setConnectedToBluetooth = false;
              BluetoothPrinterConnection.disconnect();
              return;
            }

            showDialog(
              context: context,
              child: SimpleDialog(
                title: Column(
                  children: <Widget>[
                    Text(getTranslated(context, "MainScreen.gettingPairedDevices")),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: CircularProgressIndicator(),),
                    )
                  ],
                ),
              )
            );
            BluetoothPrinterConnection.getListOfPairedDevices().then((value){
              Navigator.pop(context);
              if(value.isNotEmpty){
                showDialog(
                  context: context,
                  child: SimpleDialog(
                    titlePadding: EdgeInsets.all(0.0),
                    title: Container(
                      margin: EdgeInsets.all(0.0),
                        height: 50,
                        color: Theme.of(context).primaryColor,
                        child: Center(child: Text(getTranslated(context, "MainScreen.pairedDevices"),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),))),
                    children: <Widget>[
                      Container(
                        height:300,
                        width: 100,
                        child: ListView.builder(
                          itemBuilder: ((BuildContext insideContext, int index){
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: InkWell(
                                  child: PairedDevicesItem(value[index].name, value[index].address),
                                  onTap: (){
                                    Navigator.pop(insideContext);
                                    BluetoothPrinterConnection.connectFromList(value[index],masterProvider,context);
                                  },
                              ),
                            );
                          }),
                          itemCount: value.length,
                        ),
                      )
                    ],
                  )
                );
              }
              else{
                showDialog(
                  context: context,
                  child: SimpleDialog(
                    title: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: Text(getTranslated(context, "MainScreen.turnOnBluetooth"),style: TextStyle(fontSize: 16),)),
                    ),
                  )
                );
              }
            }).catchError((onError){
              Navigator.pop(context);
              showDialog(
                  context: context,
                  child: SimpleDialog(
                    title: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: Text(getTranslated(context, "MainScreen.turnOnBluetooth"))),
                    ),
                  )
              );
            });

          },),

          PopupMenuButton<String>(
            onSelected: (String value)async{
              if(value == "changeLanguage"){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeLanguage()));
              }
              else if(value == "Lock"){
                await SharedPref.setLocked(true);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Locked()), (route) => false);
              }
              else{
              await masterProvider.logOut();
              SharedPref.logOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()),(route) => false);
              }
            },
            itemBuilder: (BuildContext context){
              return [
                PopupMenuItem<String>(
                  child:Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0),
                    child: Text(getTranslated(context, "MainScreen.changeLanguage")),
                  ),
                  value: "changeLanguage",
                ),
                PopupMenuItem<String>(
                  child:Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0),
                    child: Text(getTranslated(context, "MainScreen.lock")),
                  ),
                  value: "Lock",
                ),
                PopupMenuItem<String>(
                  child:Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0),
                    child: Text(getTranslated(context, "locked.logOut")),
                  ),
                  value: "Logout",
                )
              ];
            },
          )

        ],
      ),
      drawer: SafeArea(child: EVDDrawer()),
      body: SafeArea(
          child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Consumer<MasterProvider>(
                  builder: ((context, provider, child) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: provider.getConnectedToBluetooth ? Text(getTranslated(context, "bluetoothService.connected"),style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xff52C22B)),) :Text(getTranslated(context, "all.pleaseConnectToBluetooth"),style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xffEF5B5A)))
                    );
                  }),
                ),
              ),
            ),
          ),
            Padding(
              padding: const EdgeInsets.only(top:20,bottom: 40.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),

                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Consumer<MasterProvider>(builder: ((context,provider,child){
                            return Expanded(
                                child: AmountOfCreditContainer(
                                  color: Colors.pink[400],
                                  amount: 5,
                                  stock: provider.getDownloadedCardsByIdentifier(5)?.length,
                                ));
                          }),),
                          SizedBox(
                            width: 20.0,
                          ),
                          Consumer<MasterProvider>(builder: ((context,provider,child){
                          return Expanded(
                              child: AmountOfCreditContainer(
                                color: Colors.yellow,
                                amount: 10,
                                stock: provider.getDownloadedCardsByIdentifier(10)?.length,
                              ));
                          }),),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Consumer<MasterProvider>(builder: ((context,provider,child){
                            return Expanded(
                                child: AmountOfCreditContainer(
                                  color: Colors.purple,
                                  amount: 15,
                                  stock: masterProvider.getDownloadedCardsByIdentifier(15)?.length,
                                ));
                          }),),
                          SizedBox(
                            width: 20.0,
                          ),
                          Consumer<MasterProvider>(builder: ((context,provider,child){
                            return Expanded(
                                child: AmountOfCreditContainer(
                                  color: Colors.lightBlueAccent,
                                  amount: 25,
                                  stock: provider.getDownloadedCardsByIdentifier(25)?.length,
                                ));
                          }),)

                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Consumer<MasterProvider>(builder: ((context,provider,child){
                            return Expanded(
                                child: AmountOfCreditContainer(
                                  color: Colors.orange,
                                  amount: 50,
                                  stock: provider.getDownloadedCardsByIdentifier(50)?.length,
                                ));
                          }),),

                          SizedBox(
                            width: 20.0,
                          ),
                          Consumer<MasterProvider>(builder: ((context,provider,child){
                            return Expanded(
                                child: AmountOfCreditContainer(
                                  color: Colors.blue[900],
                                  amount: 100,
                                  stock: provider.getDownloadedCardsByIdentifier(100)?.length,
                                ));
                          }),)

                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Consumer<MasterProvider>(builder: ((context,provider,child){
                            return Expanded(
                                child: AmountOfCreditContainer(
                                  color: Colors.pink[400],
                                  amount: 250,
                                  stock: provider.getDownloadedCardsByIdentifier(250)?.length,
                                ));
                          }),),

                          SizedBox(
                            width: 20.0,
                          ),
                          Consumer<MasterProvider>(builder: ((context,provider,child){
                            return Expanded(
                                child: AmountOfCreditContainer(
                                  color: Colors.green,
                                  amount: 500,
                                  stock: provider.getDownloadedCardsByIdentifier(500)?.length,
                                ));
                          }),)

                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Consumer<MasterProvider>(builder: ((context,provider,child){
                            return Expanded(
                                child: AmountOfCreditContainer(
                                  color: Colors.purple,
                                  amount: 1000,
                                  stock: provider.getDownloadedCardsByIdentifier(1000)?.length,
                                ));
                          }),)

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Card(
              margin: EdgeInsets.all(0.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Consumer<MasterProvider>(builder: ((context,provider,child){
                      if(provider.getStockBalance == 0){
                        return Container();
                      }
                      return RichText(
                        text: TextSpan(
                            text: "${getTranslated(context, "MainScreen.stock")} ${getTranslated(context, "MainScreen.current_balance")} ",
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                            children: [
                              TextSpan(
                                  text: "${formatCurrency.format(provider.getStockBalance).substring(1)} ",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: getTranslated(context, "CardHistoryScreen.etb"),
                                style: TextStyle(color: Colors.black),
                              )
                            ]),
                      );
                    }),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Consumer<MasterProvider>(builder: ((context,provider,child){
                          return RichText(
                            text: TextSpan(
                                text: " " + getTranslated(context, "MainScreen.current_balance") + " ",
                                style: TextStyle(color: Colors.grey, fontSize: 20),
                                children: [

                                  TextSpan(
                                      text: "${formatCurrency.format(int.parse(provider.getUser.currentBalance)).substring(1)} ",
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text: getTranslated(context, "CardHistoryScreen.etb"),
                                    style: TextStyle(color: Colors.black),
                                  )
                                ]),
                          );
                        }),),

                        showCircularProgress ? Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(height:20,width:20,child: CircularProgressIndicator(strokeWidth: 0.6)),
                        ) :
                        IconButton(
                            icon: Icon(
                              Icons.refresh,
                            ),
                            onPressed: () async{
                              setState(() {
                                showCircularProgress = true;
                              });
                              int status = await HttpCalls.updateBalance(masterProvider);
                              setState(() {
                                showCircularProgress = false;
                              });

                              if(status == 401 || status == 301){
                                await masterProvider.logOut();
                                SharedPref.logOut();
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()),(route) => false);
                              }
                              else if(status == 200){
                                SharedPref.setShowOldBalance(false);
                                masterProvider.setShowOldBalance = false;
                              }
                              else{
                                if(status == -1){
                                  // no internet detected
                                }
                                SharedPref.setShowOldBalance(true);
                                masterProvider.setShowOldBalance = true;
                              }
                            })
                      ],
                    ),
                    Consumer<MasterProvider>(builder: ((context,provider,child){
                      if(provider.showOldBalance) return Padding(
                        padding: const EdgeInsets.only(bottom:10.0),
                        child: Text(getTranslated(context, "MainScreen.old_balance"),style: TextStyle(color: Colors.grey,fontSize: 15),),
                      ) ;
                      else return Container();

                    }),)
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
