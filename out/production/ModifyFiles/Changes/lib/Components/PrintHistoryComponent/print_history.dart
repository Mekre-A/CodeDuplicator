import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Components/PrintHistoryComponent/widgets/print_history_item.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Providers/PrintHistoryProvider.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrintHistory extends StatefulWidget{

  @override
  _PrintHistoryState createState() => _PrintHistoryState();
}

class _PrintHistoryState extends State<PrintHistory> {
  ScrollController scrollController = ScrollController();

  @override
  void initState(){
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);
    PrintHistoryProvider printHistoryProvider = Provider.of<PrintHistoryProvider>(context,listen: false);

    scrollController.addListener(() {

      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100){
            printHistoryProvider.getPrintHistory(masterProvider,printHistoryProvider);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "printHistory.printHistory")),
        centerTitle: true,
      ),
      body: SafeArea(
        child:RefreshIndicator(
          onRefresh: (()async{
            setState(() {
              printHistoryProvider.setPageToBeRequested = -1;
              printHistoryProvider.setPrintHistoryForRefresh = [];
            });
          }),
          child: FutureBuilder(
            future: printHistoryProvider.getPrintHistory(masterProvider,printHistoryProvider),// some future
            builder: ((BuildContext context, AsyncSnapshot<List> snapshot){
              if(snapshot.hasData && (snapshot.connectionState == ConnectionState.done)){
                if(printHistoryProvider.getReturnStatus == 301 || printHistoryProvider.getReturnStatus == 401){
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
                  return Consumer<PrintHistoryProvider>(builder: ((context, provider,child){
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: provider.getIsLoading ?  provider.getPrintHistoryData.length + 1 : provider.getPrintHistoryData.length,
                      itemBuilder: ((BuildContext context, int index){
                        if(provider.getIsLoading){
                          if(provider.getPrintHistoryData.length == index){
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(child: CircularProgressIndicator(),),
                            );
                          }
                          else{
                            return PrintHistoryItem(snapshot.data[index]);
                          }
                        }
                        else{
                          return PrintHistoryItem(snapshot.data[index]);
                        }
                      }),
                    );
                  }),);
                }
                else{
                  return Center(child: Text(getTranslated(context, "printHistory.youDontHaveAnyCards")),);
                }
              }
              else{
                return Consumer<MasterProvider>(builder: ((context,provider,child){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: provider.getIsAllSyncing ? Text(getTranslated(context, "printHistory.pleaseWaitAsWeSync"),
                          textAlign: TextAlign.center,):Text(getTranslated(context, "printHistory.printHistoryIsBeingFetched"),
                          textAlign: TextAlign.center,)
                      ),
                      SizedBox(height: 5.0,),
                      Center(child:CircularProgressIndicator())
                    ],
                  );
                }),);
              }
            }),
          ),
        )
      ),

    );
  }
}