
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/material.dart';

class Validator{

 static String validatePhone(String value,BuildContext context){
    if(!value.startsWith('09')){
      return getTranslated(context, "validator.phoneNumberMustStartWith");
    }
    if(int.tryParse(value) == null){
      return getTranslated(context, "validator.onlyNumber");
    }
    if(value.length != 10){
      return getTranslated(context,"validator.phoneNumberShouldBe10Digits");
    }
    return null;
  }

  static String validatePassword(String value,BuildContext context, {bool isOtp = false}){
   if(isOtp){
     if (value.trim().isEmpty) {
       return getTranslated(context, "validator.enterOTP");
     }
     if(value.length < 4){
       return getTranslated(context, "validator.OTPFourLetters");
     }
   }
   else{
     if (value.trim().isEmpty) {
       return getTranslated(context, "validator.enterPassword");
     }
     if(value.length < 4){
       return getTranslated(context, "validator.passwordFourLetters");
     }
   }

    return null;

  }

  static String validateConfirmationPassword(String newPassword,String confirmNewPassword,BuildContext context){
   if(newPassword != confirmNewPassword){
     return getTranslated(context, "validator.passwordMustBeTheSame");
   }
   return null;
  }

 static String validateNumberIsBetweenRange(String value, int startingRange, int endingRange,BuildContext context){
   if(int.tryParse(value) == null){
     return getTranslated(context, "validator.onlyNumber");
   }
   if(int.parse(value) < startingRange){
     return "${getTranslated(context, "validator.shouldntBeBelow")} $startingRange";
   }
   if(int.parse(value) > endingRange){
     return "${getTranslated(context, "validator.shouldntBeAbove")} $endingRange";
   }
   return null;
 }

 static String validateSerialNumber(String serialNumber, BuildContext context){
   if(serialNumber.trim().isEmpty){
     return getTranslated(context, "reprintWithSerial.pleaseEnterASerialNumber");
   }
   if(serialNumber.contains(" ")){
     return getTranslated(context, "reprintWithSerial.onlyNumber");
   }
   if(serialNumber.length != 13){
     return getTranslated(context, "reprintWithSerial.lengthShouldBe13");
   }
   if(int.tryParse(serialNumber.substring(0, (serialNumber.length~/2))) == null){
     return getTranslated(context, "reprintWithSerial.onlyNumber");
   }
   if(int.tryParse(serialNumber.substring((serialNumber.length~/2), serialNumber.length)) == null){
     return getTranslated(context, "reprintWithSerial.onlyNumber");
   }

   return null;
 }

 static String validateName(String name, BuildContext context){
   if (name.trim().isEmpty) {
     return "Please enter your name";
   }
   return null;
 }

 static String validateBalance(String balance, BuildContext context){
   if (balance.trim().isEmpty) {
     return "Please enter an amount";
   }
   if(int.tryParse(balance) == null){
     return "Please enter a valid amount";
   }
   return null;
 }

 static String validateRemark(String name, BuildContext context){
   if (name.trim().isEmpty) {
     return "Please enter your remark";
   }
   return null;
 }

}