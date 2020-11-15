import 'package:evd_retailer/Components/SellMobileCard/widgets/download_cards.dart';
import 'package:evd_retailer/Components/SellMobileCard/widgets/print_cards.dart';
import 'package:evd_retailer/Components/SellMobileCard/widgets/refill_number.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SellMobileCard extends StatelessWidget {
  final int amount;

  SellMobileCard({@required this.amount});
  final formatCurrency = NumberFormat.simpleCurrency(decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "SendScreen.title")),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
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
                        child: RichText(
                          text: TextSpan(
                              text: " " +
                                  getTranslated(
                                      context, "MainScreen.current_balance") +
                                  " ",
                              style: TextStyle(color: Colors.grey, fontSize: 24),
                              children: [
                                TextSpan(
                                    text:
                                    "${formatCurrency.format(int.parse(provider.getUser.currentBalance)).substring(1)} ",
                                    style: provider.isPrintingCards ? TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold) : TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold)) ,
                                TextSpan(
                                  text: getTranslated(
                                      context, "CardHistoryScreen.etb"),
                                  style: TextStyle(color: Colors.black),
                                )
                              ]),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    PrintCards(amount),
                    RefillNumber(amount),
                    DownloadCards(amount),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
