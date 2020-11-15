
import 'package:evd_retailer/Models/DownloadHistoryResponse.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DownloadHistoryItem extends StatelessWidget{

  DownloadHistoryItem(this.result);

  final Result result;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.all(0.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(result.downloadId, style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),

              ],
            ),
            Container(height: 3,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: "${getTranslated(context, "downloadHistory.cardAmount")}: ",
                    style: TextStyle(color: Colors.grey[600]),
                    children: [TextSpan(
                        text: "${result.cardAmount}",
                        style: TextStyle(
                            color:  Colors.grey[600],
                            fontWeight: FontWeight.bold)),]
                  ),

                ),
                Container(height: 3,),
                RichText(
                  text: TextSpan(
                      text: "${getTranslated(context, "downloadHistory.quantity")}: ",
                      style: TextStyle(color: Colors.grey[600]),
                      children: [TextSpan(
                          text: "${result.downloadQuantity}",
                          style: TextStyle(
                              color:  Colors.grey[600],
                              fontWeight: FontWeight.bold)),]
                  ),

                ),

              ],
            ),
            Container(height: 3,),
            Text("${getTranslated(context, "downloadHistory.downloadedDate")}: ${DateFormat("yyyy-MM-dd").add_jm().format(result.downloadedCardCreatedDate)}",style: TextStyle(color: Colors.grey[600]),),
            Divider(color: Colors.grey,)
          ],
        ),
      ),
    );
  }
}