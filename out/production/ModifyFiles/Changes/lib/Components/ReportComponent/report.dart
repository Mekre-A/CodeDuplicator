import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Providers/ReportProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Report extends StatefulWidget{

  ReportState createState() => ReportState();
}

class ReportState extends State<Report>{

  TextEditingController startDateController, endDateController;
  final formatCurrency = NumberFormat.simpleCurrency(decimalDigits: 0);


  @override
  void initState(){
    super.initState();

    startDateController = TextEditingController();
    startDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    endDateController = TextEditingController();
    endDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);
    ReportProvider reportProvider = Provider.of<ReportProvider>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context,"report.report")),
        centerTitle: true,
      ),
      body: SafeArea(
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.symmetric(horizontal:30.0,vertical:10.0),
                child: TextFormField(

                  readOnly: true,
                  onTap: (){
                    showDatePicker(
                        context: context,
                        initialDate: DateTime.parse(startDateController.text),
                        firstDate: DateTime.now().subtract(Duration(days: 365)),
                        lastDate: DateTime.now(),
                        builder: (BuildContext context, Widget child){
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(primary: Theme.of(context).primaryColor),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                              child:child
                          );
                        }
                    ).then((value){
                      if(value != null){
                        if(DateTime.parse(endDateController.text).difference(value) < Duration(days: 0)){
                          Fluttertoast.showToast(
                            msg: getTranslated(context, "report.startDateBeforeEndDate"),
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.black,
                          );
                        }
                        else{
                        startDateController.text = DateFormat('yyyy-MM-dd').format(value);
                        }
                      }
                    });
                  },
                  controller: startDateController,
                  decoration: InputDecoration(
                    suffixText: getTranslated(context,"report.startDate"),
                    border: OutlineInputBorder()
                  ),

                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal:30.0,vertical:10.0),
              child: TextFormField(
                readOnly: true,
                onTap: (){
                  showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(endDateController.text),
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now(),
                      builder: (BuildContext context, Widget child){
                        return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(primary: Theme.of(context).primaryColor),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child:child
                        );
                      }
                  ).then((value){
                    if(value != null){
                      if(value.difference(DateTime.parse(startDateController.text)) < Duration(days: 0)){
                        Fluttertoast.showToast(
                          msg: getTranslated(context, "report.endDateAfterStartDate"),
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.black,
                        );

                      }
                      else{
                        endDateController.text = DateFormat('yyyy-MM-dd').format(value);
                      }
                    }
                  });
                },
                controller: endDateController,
                decoration: InputDecoration(
                    suffixText: getTranslated(context, "report.endDate"),
                    border: OutlineInputBorder()
                ),
              ),
            ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:10.0, horizontal: 70),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Consumer<ReportProvider>(builder: (context,provider,child){
                        if(provider.getIsSearching){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        return RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          onPressed: ()async{
                              provider.setIsSearching = true;

                              int status = await HttpCalls.getReport(reportProvider, masterProvider, startDateController.text, endDateController.text);

                              if(status != 200) provider.setResponse = [];

                              provider.setIsSearching = false;

                              if(status == 200){

                              }
                              else if(status == 301 || status == 401){
                                await masterProvider.logOut();
                                SharedPref.logOut();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Login()),
                                        (route) => false);
                              }

                              else if(status == 500){
                                Fluttertoast.showToast(
                                    msg: getTranslated(context, "report.oopps"),
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                              else if(status == -1){
                                Fluttertoast.showToast(
                                    msg: getTranslated(context, "report.checkConnection"),
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(getTranslated(context, "report.search"),style: TextStyle(color: Colors.white),),
                          ),
                        );
                       },)
                    ),
                  ],
                ),
              ),
              Consumer<ReportProvider>(builder: ((context,provider,child){
                if(!provider.getIsSearching && provider.getReports.isNotEmpty){
                  return DataTable(
                      columns: [
                        DataColumn(label: Text(getTranslated(context, "report.amount"))),
                        DataColumn(label: Text(getTranslated(context, "report.quantity"))),
                        DataColumn(label: Text(getTranslated(context, "report.sum")))
                      ],
                      rows:reportProvider.getReports.map((e) =>
                          DataRow(
                              cells: [
                                DataCell(Center(child: Text(e.amount))),
                                DataCell(Center(child: Text(formatCurrency.format(int.parse(e.quantity)).substring(1)))),
                                DataCell(Center(child: Text("${formatCurrency.format(int.parse(e.sum)).substring(1)} ${getTranslated(context, "CardHistoryScreen.etb")}")))
                              ]
                          )
                      ).toList()
                  );
                }
                else{
                  return Container();
                }
              }),)

            ],
          ),
        )
      ),
    );
  }
}