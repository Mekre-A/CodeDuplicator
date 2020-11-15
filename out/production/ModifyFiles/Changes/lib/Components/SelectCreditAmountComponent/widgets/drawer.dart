import 'package:evd_retailer/Components/AgentManagementComponent/agent_management.dart';
import 'package:evd_retailer/Components/BalanceHistoryComponent/balance_history.dart';
import 'package:evd_retailer/Components/ChangeLanguageComponent/change_language.dart';
import 'package:evd_retailer/Components/DownloadHistoryComponent/download_history.dart';
import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Components/PrintHistoryComponent/print_history.dart';
import 'package:evd_retailer/Components/ReportComponent/report.dart';
import 'package:evd_retailer/Components/ReprintComponent/reprint.dart';
import 'package:evd_retailer/Components/ReprintWithSerialComponent/reprint_with_serial.dart';
import 'package:evd_retailer/Components/TransactionHistoryComponent/transaction_history.dart';
import 'package:evd_retailer/Components/UssdReportComponent/ussd_history.dart';
import 'package:evd_retailer/Providers/BalanceHistoryProvider.dart';
import 'package:evd_retailer/Providers/DownloadHistoryProvider.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Providers/PrintHistoryProvider.dart';
import 'package:evd_retailer/Providers/ReportProvider.dart';
import 'package:evd_retailer/Providers/ReprintWithSerialProvider.dart';
import 'package:evd_retailer/Providers/TransactionHistoryProvider.dart';
import 'package:evd_retailer/Providers/UssdHistoryProvider.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EVDDrawer extends StatelessWidget{

  final formatCurrency = NumberFormat.simpleCurrency(decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen:false);
    return Drawer(
        child: ListView(
          children: <Widget>[
              DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: 80,
                          width: 250,
                          child: Image(
                              image: AssetImage('assets/images/login.png'),
                              fit: BoxFit.scaleDown
                          ),
                        ),
                      ),
                      Center(child: Text("${getTranslated(context, "MainScreen.name")}: ${masterProvider.getUser.userName}")),
                      Center(child: Text("${getTranslated(context, "MainScreen.current_balance")}: ${formatCurrency.format(int.parse(masterProvider.getUser.currentBalance)).substring(1)} ${getTranslated(context, "CardHistoryScreen.etb")}")),
                      Center(child: Text("${getTranslated(context, "MainScreen.version")}: 3.6.2"))
                    ],
                  ),

              ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(getTranslated(context, "MainScreen.home")),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.dialpad),
              title: Text(getTranslated(context, "MainScreen.ussdHistory")),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create:(BuildContext context) => UssdHistoryProvider(),child: UssdHistory(),)));
              },
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text(getTranslated(context, "MainScreen.balanceHistory")),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create:(BuildContext context) => BalanceHistoryProvider(),child: BalanceHistory(),)));
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text(getTranslated(context, "MainScreen.printHistory")),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create:(BuildContext context) => PrintHistoryProvider(),child: PrintHistory(),)));
              },
            ),
            ListTile(
              leading: Icon(Icons.print),
              title: Text(getTranslated(context, "MainScreen.rePrint")),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Reprint()));
              },
            ),
            ListTile(
              leading: Icon(Icons.print),
              title: Text(getTranslated(context, "reprintWithSerial.reprintWithSerial")),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create:(BuildContext context) => ReprintWithSerialProvider(),child: ReprintWithSerial(),)));
              },
            ),
            ListTile(
              leading: Icon(Icons.file_download),
              title: Text(getTranslated(context, "MainScreen.downloadHistory")),
              onTap: (){

                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create:(BuildContext context) => DownloadHistoryProvider(),child: DownloadHistory(),)));
              },
            ),
            ListTile(
              leading: Icon(Icons.compare_arrows),
              title: Text(getTranslated(context, "MainScreen.transactionHistory")),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create:(BuildContext context) => TransactionHistoryProvider(),child: TransactionHistory(),)));
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_chart),
              title: Text(getTranslated(context, "MainScreen.report")),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create:(BuildContext context) => ReportProvider(),child: Report(),)));
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(getTranslated(context, "agent.agentManagement")),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AgentManagement()));
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text(getTranslated(context,"MainScreen.language")),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeLanguage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text(getTranslated(context, "MainScreen.logOut")),
              onTap: ()async{
                await masterProvider.logOut();
                SharedPref.logOut();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()),(route) => false);
              },
            )
          ],
        ),
    );
  }
}