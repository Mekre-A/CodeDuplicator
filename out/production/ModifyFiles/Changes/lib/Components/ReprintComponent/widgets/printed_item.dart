import 'package:evd_retailer/Components/OrderRangeComponent/order_range.dart';
import 'package:evd_retailer/Models/GroupedPrintedCards.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrintedItem extends StatelessWidget{
 PrintedItem(this.groupedCards);

 final GroupedPrintedCards groupedCards;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(getTranslated(context, "rePrint.orderRange"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Text("${groupedCards.getOrderRange}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                ],
              ),
              Container(height: 3.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(getTranslated(context, "rePrint.cardAmount")),
                  Text("${groupedCards.getCardAmount}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold))
                ],
              ),
              Container(height: 3.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(getTranslated(context, "rePrint.date")),
                  Text("${DateFormat("yyyy-MM-dd").add_jm().format(DateTime.parse(groupedCards.getPrintedDate))}"),
                ],
              ),


            ],
          ),
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderRange(groupedCards)));
      },
    );
  }
}