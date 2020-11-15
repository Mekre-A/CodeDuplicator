import 'package:evd_retailer/Models/ReportResponse.dart';
import 'package:flutter/material.dart';

class ReportProvider extends ChangeNotifier{

  bool _isSearching = false;
  bool get getIsSearching => _isSearching;
  set setIsSearching(bool status){
    _isSearching = status;
    notifyListeners();
  }

  List<Datum> _reports = [];
  List<Datum> get getReports => _reports;
  set setResponse(List<Datum> reports){
    _reports = reports;
  }
  void addTotalRow(List<Datum> reports){
    if(reports.isEmpty) return;
    int totalSum = 0;
    int totalQuantity = 0;
    reports.forEach((element) {
      totalSum += int.parse(element.sum);
      totalQuantity += int.parse(element.quantity);
    });
    _reports.add(Datum(amount: "Total",sum: totalSum.toString(), quantity: totalQuantity.toString(), faceValue: "0"));
  }



}