import 'package:evd_retailer/Components/SettingsComponent/widgets/reset_order_id.dart';
import 'package:evd_retailer/Components/SettingsComponent/widgets/sync_and_confirm.dart';
import 'package:evd_retailer/Components/SettingsComponent/widgets/test_print.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget{

  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "SettingScreen.title")),
        centerTitle: true,
      ),
      body: SafeArea(
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              ResetOrderId(),
              Divider(),
              TestPrint(),
              Divider(),
              SyncAndConfirm(),
              Divider(),
            ],
          ),
        )
      ),
    );
  }
}