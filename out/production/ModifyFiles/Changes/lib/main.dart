

import 'package:evd_retailer/Components/StarterComponent/starter.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Providers/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'Services/AppLocalizations.dart';



void main() {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => MasterProvider(),
        ),
        ChangeNotifierProvider(create: (BuildContext context) => LocalizationProvider(),
        )
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


 @override
 void initState(){
    super.initState();
 }

  @override
  Widget build(BuildContext context) {

    return Consumer<LocalizationProvider>(builder:(context,provider,child){
      return MaterialApp(
      title: 'EVD Retailer',

      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primaryColor: Color(0xffFA8072),
        buttonColor: Color(0xff8B0000), // secondary
        errorColor: Color(0xffFA8072	),
        textSelectionColor:Color(0xff8B0000),  // secondary
        indicatorColor: Color(0xffFA8072	),
        accentColor:Color(0xffFA8072	),


        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      locale: provider.getLocale,
      supportedLocales: [
        Locale('en','US'),
        Locale('am','ET'),

      ],
      localizationsDelegates: [
        // this will be our own localization delegates
        AppLocalizations.delegate,
        //changes texts that are assigned by flutter to selected languages
        GlobalMaterialLocalizations.delegate,
        //Changes text direction from ltr to rtl
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocals){
        for (var supportedLocal in supportedLocals){
          if(supportedLocal.languageCode == locale.languageCode && supportedLocal.countryCode == locale.countryCode){
            return supportedLocal;
          }
        }
        return supportedLocals.first;
      },
      home: Starter(),
      );
    });

  }
}

