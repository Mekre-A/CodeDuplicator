import 'package:evd_retailer/Components/OrderRangeComponent/widgets/order_range_item.dart';
import 'package:evd_retailer/Models/GroupedPrintedCards.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/LocalCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/Validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class OrderRange extends StatefulWidget{

  OrderRange(this.cards);

  final GroupedPrintedCards cards;

  @override
  _OrderRangeState createState() => _OrderRangeState();
}

class _OrderRangeState extends State<OrderRange> {
  
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
    startingRangeController = TextEditingController(text: 
        "${widget.cards.getCards.last.getOrderId}");
    endingRangeController = TextEditingController(text: "${widget.cards.getCards.last.getOrderId}");
  }
  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);
    
    int startingRange = widget.cards.getCards.first.getOrderId;
    int endingRange = widget.cards.getCards.last.getOrderId;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.cards.getCardAmount} ${getTranslated(context, "orderRange.birrCards")}"),
        centerTitle: true,
        actions: <Widget>[
          RaisedButton(onPressed: (){
            showDialog(
                context: context,
                child: SimpleDialog(
                 title: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     Text(getTranslated(context, "orderRange.selectCardsBetween")),
                     Text("${widget.cards.getOrderRange}")
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
                            if(Validator.validateNumberIsBetweenRange(startingRangeController.text, startingRange,endingRange,context) != null){
                              showErrorMessage(Validator.validateNumberIsBetweenRange(startingRangeController.text, startingRange,endingRange,context));
                            }
                            else if(Validator.validateNumberIsBetweenRange(endingRangeController.text, startingRange ,endingRange,context) != null){
                              showErrorMessage(Validator.validateNumberIsBetweenRange(endingRangeController.text, startingRange,endingRange,context));
                            }
                            else{
                              LocalCalls.rePrintWithRange(widget.cards.getCards,int.parse(startingRangeController.text),int.parse(endingRangeController.text), masterProvider);
                              showSuccessMessage(context);
                              Navigator.pop(context);
                            }
                          }
                        },child: Text(getTranslated(context, "orderRange.print"),style: TextStyle(color: Colors.white),),color: provider.getConnectedToBluetooth ? Colors.green : Colors.grey ,),
                      );
                    }),)
                    
                  ],
                ));
          },child: Text(getTranslated(context, "orderRange.printByRange")),)
        ],
      ),
      
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: widget.cards.getCards.length,
            itemBuilder: ((BuildContext context, int index){
              return OrderRangeItem(widget.cards.getCards[index]);
            }),
          ),
        ),
      ),
    );
  }
}