import 'package:evd_retailer/Components/BalanceHistoryComponent/widgets/balance_history_item.dart';
import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/BalanceHistoryProvider.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BalanceHistory extends StatefulWidget{

  @override
  _BalanceHistoryState createState() => _BalanceHistoryState();
}

class _BalanceHistoryState extends State<BalanceHistory> {

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);

    BalanceHistoryProvider balanceHistoryProvider = Provider.of<BalanceHistoryProvider>(context,listen: false);

    scrollController.addListener(() {

      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100){
        balanceHistoryProvider.getBalanceHistory(masterProvider,balanceHistoryProvider);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "balanceHistory.balanceHistory")),
        centerTitle: true,
      ),
      body: SafeArea(
        child:RefreshIndicator(
          onRefresh: (()async{
            setState(() {
            balanceHistoryProvider.setPageToBeRequested = -1;
            balanceHistoryProvider.setBalanceHistoryForRefresh = [];
            });
          }),
          child: FutureBuilder(
            future: balanceHistoryProvider.getBalanceHistory(masterProvider,balanceHistoryProvider),// some future
            builder: ((BuildContext context, AsyncSnapshot<List> snapshot){
              if(snapshot.hasData && (snapshot.connectionState == ConnectionState.done)){
                if(balanceHistoryProvider.getReturnStatus == 301 || balanceHistoryProvider.getReturnStatus == 401){
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
                  return Consumer<BalanceHistoryProvider>(builder: ((context, provider,child){
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: provider.getIsLoading ?  provider.getBalanceHistoryData.length + 1 : provider.getBalanceHistoryData.length,
                      itemBuilder: ((BuildContext context, int index){
                        if(provider.getIsLoading){
                          if(provider.getBalanceHistoryData.length == index){
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(child: CircularProgressIndicator(),),
                            );
                          }
                          else{
                            return BalanceHistoryItem(snapshot.data[index]);
                          }
                        }
                        else{
                          return BalanceHistoryItem(snapshot.data[index]);
                        }
                      }),
                    );
                  }),);
                }
                else{
                  return Center(child: Text(getTranslated(context, "balanceHistory.youDontHaveAnyCards")),);
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