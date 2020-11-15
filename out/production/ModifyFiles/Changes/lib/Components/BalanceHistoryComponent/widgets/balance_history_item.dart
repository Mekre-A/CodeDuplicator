
import 'package:evd_retailer/Models/BalanceHistoryResponse.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceHistoryItem extends StatelessWidget{

  BalanceHistoryItem(this.result);

  final Result result;

  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.all(0.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:15.0,vertical:5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                int.parse(result.amount) < 0 ? Text(formatCurrency.format(int.parse(result.amount)).replaceRange(1, 2, "") + " ETB",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Color(0xffEF5B5A)),):
                Text(formatCurrency.format(int.parse(result.amount)).substring(1) + " ETB",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                Text(DateFormat("yyyy-MM-dd").add_jm().format(result.refillDate),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              ],
            ),
            Container(height: 3,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("${getTranslated(context, "balanceHistory.balanceBefore")}: ${formatCurrency.format(int.parse(result.balanceBefore)).substring(1)} ETB",style: TextStyle(color: Colors.grey[600]),),
                Text("${getTranslated(context, "balanceHistory.by")} ${result.refilledBy}",style: TextStyle(color: Colors.grey[600]),),
              ],
            ),
            Container(height: 3,),
            Text("${getTranslated(context, "balanceHistory.closingBalance")}: ${formatCurrency.format(int.parse(result.endingBalance)).substring(1)} ETB",style: TextStyle(color: Colors.grey[600]),),
            Container(height: 3,),
            Text("${getTranslated(context, "balanceHistory.remark")}: ${result.remark}",style: TextStyle(color: Colors.grey[600]),),
            Divider(color: Colors.grey,)
          ],
        ),
      ),
    );
  }
}