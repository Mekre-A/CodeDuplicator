import 'package:evd_retailer/Components/OrderRangeFromOnlineComponent/order_range_from_online.dart';
import 'package:evd_retailer/Models/PrintHistoryResponse.dart';
import 'package:evd_retailer/Providers/OrderRangeFromOnlineProvider.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PrintHistoryItem extends StatelessWidget{

  PrintHistoryItem(this.result);

  final formatCurrency = NumberFormat.simpleCurrency();

  final Result result;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.all(0.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:15.0,vertical:5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(result.printId,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: int.parse(result.groupId) < 0 ? Color(0xffF2C500) : Colors.black),),
                  Text(result.printRange.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: int.parse(result.groupId) < 0 ? Color(0xffF2C500) : Colors.black),),
                ],
              ),
              Container(height: 3,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    text:TextSpan(
                      text:"${getTranslated(context, "printHistory.cardAmount")}: ",
                      style: TextStyle(color: Colors.grey[800]),
                      children:[
                        TextSpan(
                        text:"${result.cardAmount}",
                        style:TextStyle(color: Colors.grey[800],fontWeight:FontWeight.bold),
              )
                        ]
                    )
                  ),
                  Container(height: 3,),
                  RichText(
                      text:TextSpan(
                          text:"${getTranslated(context,"printHistory.quantity")}: ",
                          style: TextStyle(color: Colors.grey[800]),
                          children:[
                            TextSpan(
                              text:"${result.printQuantity}",
                              style:TextStyle(color: Colors.grey[800],fontWeight:FontWeight.bold),
                            )
                          ]
                      )
                  ),

                ],
              ),
              Container(height: 3,),
              Text("${getTranslated(context, "printHistory.printedDate")}: ${DateFormat("yyyy-MM-dd").add_jm().format(result.printedDate)}",style: TextStyle(color: Colors.grey[600]),),
              Divider(color: Colors.grey,)
            ],
          ),
        ),
      ),
      onTap: (){
          Navigator.push(context, MaterialPageRoute( builder:(context) => ChangeNotifierProvider(create: (BuildContext context) => OrderRangeFromOnlineProvider(), child: OrderRangeFromOnline(int.parse(result.groupId), result.printRange, result.cardAmount),)));
      },
    );
  }
}