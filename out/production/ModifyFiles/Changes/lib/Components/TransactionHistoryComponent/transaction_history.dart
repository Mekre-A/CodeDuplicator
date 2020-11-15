import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Components/TransactionHistoryComponent/widgets/transaction_history_item.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Providers/TransactionHistoryProvider.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionHistory extends StatefulWidget{

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  ScrollController scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);
    TransactionHistoryProvider transactionHistoryProvider = Provider.of<TransactionHistoryProvider>(context,listen: false);

    scrollController.addListener(() {

      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100){
        transactionHistoryProvider.getTransactionHistory(masterProvider, transactionHistoryProvider);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context,"transactionHistory.transactionHistory")),
        centerTitle: true,
      ),
      body: SafeArea(
        child:RefreshIndicator(
          onRefresh: (()async{
            setState(() {
              transactionHistoryProvider.setPageToBeRequested = -1;
              transactionHistoryProvider.setTransactionHistoryForRefresh = [];
            });
          }),
          child: FutureBuilder(
            future: transactionHistoryProvider.getTransactionHistory(masterProvider,transactionHistoryProvider),// some future
            builder: ((BuildContext context, AsyncSnapshot<List> snapshot){
              if(snapshot.hasData && (snapshot.connectionState == ConnectionState.done)){
                if(transactionHistoryProvider.getReturnStatus == 301 || transactionHistoryProvider.getReturnStatus == 401){
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
                  return Consumer<TransactionHistoryProvider>(builder: ((context, provider,child){
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: provider.getIsLoading ?  provider.getTransactionHistoryData.length + 1 : provider.getTransactionHistoryData.length,
                      itemBuilder: ((BuildContext context, int index){
                        if(provider.getIsLoading){
                          if(provider.getTransactionHistoryData.length == index){
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(child: CircularProgressIndicator(),),
                            );
                          }
                          else{
                            return TransactionHistoryItem(snapshot.data[index]);
                          }
                        }
                        else{
                          return TransactionHistoryItem(snapshot.data[index]);
                        }
                      }),
                    );
                  }),);
                }
                else{
                  return Center(child: Text(getTranslated(context,"transactionHistory.noCardsInTransactionHistory")),);
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