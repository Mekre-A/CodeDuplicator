import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Components/UssdReportComponent/widgets/ussd_history_item.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Providers/UssdHistoryProvider.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UssdHistory extends StatefulWidget{

  @override
  _UssdHistoryState createState() => _UssdHistoryState();
}

class _UssdHistoryState extends State<UssdHistory> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);
    UssdHistoryProvider ussdHistoryProvider = Provider.of<UssdHistoryProvider>(context,listen: false);

    scrollController.addListener(() {

      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100){
        ussdHistoryProvider.getUssdHistory(masterProvider,ussdHistoryProvider);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "ussdHistory.ussdHistory")),
        centerTitle: true,
      ),
      body: SafeArea(
          child:RefreshIndicator(
            onRefresh: (()async{
              setState(() {
                ussdHistoryProvider.setPageToBeRequested = -1;
                ussdHistoryProvider.setUssdHistoryForRefresh = [];
              });
            }),
            child: FutureBuilder(
              future: ussdHistoryProvider.getUssdHistory(masterProvider,ussdHistoryProvider),// some future
              builder: ((BuildContext context, AsyncSnapshot<List> snapshot){
                if(snapshot.hasData && (snapshot.connectionState == ConnectionState.done)){
                  if(ussdHistoryProvider.getReturnStatus == 301 || ussdHistoryProvider.getReturnStatus == 401){
                    Future.delayed(Duration(seconds: 0)).then((value){
                      masterProvider.logOut();
                      SharedPref.logOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Login()),
                              (route) => false);
                    });
                    return Container();

                  }
                  else if(snapshot.data.isNotEmpty){
                    return Consumer<UssdHistoryProvider>(builder: ((context, provider,child){
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: provider.getIsLoading ?  provider.getUssdHistoryData.length + 1 : provider.getUssdHistoryData.length,
                        itemBuilder: ((BuildContext context, int index){
                          if(provider.getIsLoading){
                            if(provider.getUssdHistoryData.length == index){
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(child: CircularProgressIndicator(),),
                              );
                            }
                            else{
                              return UssdHistoryItem(snapshot.data[index]);
                            }
                          }
                          else{
                            return UssdHistoryItem(snapshot.data[index]);
                          }
                        }),
                      );
                    }),);
                  }
                  else{
                    return Center(child: Text(getTranslated(context, "ussdHistory.noCardsInUssdHistory")),);
                  }
                }
                else{
                  return Center(child:CircularProgressIndicator());
                }


              }),
            ),
          )
      ),

    );
  }
}