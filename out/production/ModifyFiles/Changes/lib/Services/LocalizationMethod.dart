import 'package:evd_retailer/Services/AppLocalizations.dart';
import 'package:flutter/material.dart';

String getTranslated(BuildContext context,String key){
  return AppLocalizations.of(context).translate(key);
}