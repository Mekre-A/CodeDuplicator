import 'dart:ui';

import 'package:evd_retailer/Models/AgentsResponse.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';

class AgentListItem extends StatelessWidget {
  AgentListItem(this.agent);
  final formatCurrency = NumberFormat.simpleCurrency(decimalDigits: 0);
  final Agent agent;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${formatCurrency
                    .format(int.parse(agent.currentBalance))
                    .substring(1)} ${getTranslated(context, "CardHistoryScreen.etb")}",style: TextStyle(fontWeight: FontWeight.bold),),
                InkWell(
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.green,
                        ),
                        Text(agent.phone,style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    onTap: () {
                      FlutterPhoneDirectCaller.callNumber(agent.phone);
                    }),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                agent.status == "0"
                    ? Text(
                  getTranslated(context, "agent.notActive"),
                  style: TextStyle(color: Colors.red),
                )
                    : Text(
                  getTranslated(context, "agent.active"),
                  style: TextStyle(color: Colors.green),
                ),
                Text(agent.name),
              ],
            )
          ]),
        ));
  }
}
