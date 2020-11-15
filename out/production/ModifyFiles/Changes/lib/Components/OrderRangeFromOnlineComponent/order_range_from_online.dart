import 'package:evd_retailer/Components/OrderRangeFromOnlineComponent/widgets/order_range_item.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Providers/OrderRangeFromOnlineProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/Validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class OrderRangeFromOnline extends StatefulWidget{

  final int groupId;

  final String orderRange;

  final String cardAmount;

  OrderRangeFromOnline(this.groupId,this.orderRange, this.cardAmount);

  @override
  _OrderRangeFromOnlineState createState() => _OrderRangeFromOnlineState();
}

class _OrderRangeFromOnlineState extends State<OrderRangeFromOnline> {
  showErrorMessage(String errorMessage){
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  showSuccessMessage(BuildContext context){
    Fluttertoast.showToast(
        msg: getTranslated(context, "orderRange.successfullyReprinted"),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  TextEditingController startingRangeController, endingRangeController;

  @override
  void initState(){
    super.initState();
    startingRangeController = TextEditingController();
    endingRangeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    OrderRangeFromOnlineProvider orderRangeFromOnlineProvider = Provider.of<OrderRangeFromOnlineProvider>(context,listen: false);
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.cardAmount} ${getTranslated(context, "orderRange.birrCards")}"),
        centerTitle: true,
        actions: <Widget>[
          Consumer<OrderRangeFromOnlineProvider>(builder: ((context,orderProvider,child){
            if(orderProvider.getOrderRangeData.isEmpty){
              return Container();
            }
            startingRangeController.text = orderProvider.getOrderRangeData.last.getOrderId.toString();
            endingRangeController.text = orderProvider.getOrderRangeData.last.getOrderId.toString();
            return RaisedButton(onPressed: (){
              showDialog(
                  context: context,
                  child: SimpleDialog(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(getTranslated(context, "orderRange.selectCardsBetween")),
                        Text("${widget.orderRange}")
                      ],
                    ),
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(width:50,child: Text("${getTranslated(context, "orderRange.from")} - ")),

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
                          Container(width:50,child: Text("${getTranslated(context, "orderRange.to")} - ")),

                          Container(
                            width: 100,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: endingRangeController,
                            ),
                          )
                        ],
                      ),

                      Consumer<MasterProvider>(builder: ((context,provider,child){
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20.0,20.0,20.0,0.0),
                          child: RaisedButton(onPressed: (){
                            if(!provider.getConnectedToBluetooth){
                              showErrorMessage(getTranslated(context, "orderRange.connectToBluetoothDeviceFirst"));
                            }
                            else{
                              if(Validator.validateNumberIsBetweenRange(startingRangeController.text, orderProvider.getOrderRangeData.first.getOrderId,orderProvider.getOrderRangeData.last.getOrderId,context) != null){
                                showErrorMessage(Validator.validateNumberIsBetweenRange(startingRangeController.text,  orderProvider.getOrderRangeData.first.getOrderId,orderProvider.getOrderRangeData.last.getOrderId,context));
                              }
                              else if(Validator.validateNumberIsBetweenRange(endingRangeController.text,  orderProvider.getOrderRangeData.first.getOrderId,orderProvider.getOrderRangeData.last.getOrderId,context) != null){
                                showErrorMessage(Validator.validateNumberIsBetweenRange(endingRangeController.text,  orderProvider.getOrderRangeData.first.getOrderId,orderProvider.getOrderRangeData.last.getOrderId,context));
                              }
                              else{
                                LocalCalls.rePrintWithRange(orderRangeFromOnlineProvider.getOrderRangeData,int.parse(startingRangeController.text),int.parse(endingRangeController.text), masterProvider);
                                showSuccessMessage(context);
                                Navigator.pop(context);
                              }
                            }
                          },child: Text(getTranslated(context, "orderRange.print"),style: TextStyle(color: Colors.white),),color: provider.getConnectedToBluetooth ? Colors.green : Colors.grey ,),
                        );
                      }),)
                    ],
                  ));
            },child: Text(getTranslated(context, "orderRange.printByRange")),);
          }),)

        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: HttpCalls.getOrderRangeFromOnline(masterProvider, widget.groupId, orderRangeFromOnlineProvider),
          builder: ((BuildContext context,AsyncSnapshot<int> snapshot){
            if(snapshot.hasData){
              if(snapshot.data == 200){
                return Consumer<OrderRangeFromOnlineProvider>(builder: ((context,provider,child){
                  if(widget.groupId < 0){
                    Future.delayed(Duration(seconds: 1)).then((value){
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          child:SimpleDialog(
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
                          )
                      );
                      if(masterProvider.getIsSyncing){
                        return;
                      }
                      else{
                        masterProvider.setIsSyncing = true;
                      }
                      LocalCalls.saveLostCardsDuringPrinting(provider.getOrderRangeData, masterProvider).then((value)async{
                        if(value){
                          await HttpCalls.syncCardsBehindTheScenes(masterProvider).then((value) {
                            masterProvider.setIsSyncing = false;
                            if (value == 200 || value == 204) {
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
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  getTranslated(context, "all.close"),
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                color: Colors.green,
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ));
                            } else {
                              Navigator.pop(context);
                              Navigator.pop(context);
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
                        }
                        else{
                          Navigator.pop(context);
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              child: SimpleDialog(
                                children: <Widget>[
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(getTranslated(context, "all.noCardsToReprint")),
                                    ),
                                  ),
                                ],
                              ));
                        }
                      });
                    });
                    return Center(child: CircularProgressIndicator(),);
                  }

                  return ListView.builder(
                    itemCount: provider.getOrderRangeData.length,
                    itemBuilder: ((BuildContext context,int index){
                      return OrderRangeItem(provider.getOrderRangeData[index]);
                    }),
                  );
                }),);
              }
              else if(snapshot.data == -1){
                return Center(child:Text(getTranslated(context, "orderRangeFromOnline.pleaseConnectToTheInternet")));
              }
              else{
                return Center(child:Text(getTranslated(context, "orderRangeFromOnline.oops")));
              }
            }
            else{
              return Center(child: CircularProgressIndicator(),);
            }
          }),
        ),
      ),


    );
  }
}