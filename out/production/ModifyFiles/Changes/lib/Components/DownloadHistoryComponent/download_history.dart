import 'package:evd_retailer/Components/DownloadHistoryComponent/widgets/download_history_item.dart';
import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/DownloadHistoryProvider.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DownloadHistory extends StatefulWidget{

  @override
  _DownloadHistoryState createState() => _DownloadHistoryState();
}

class _DownloadHistoryState extends State<DownloadHistory> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);
    DownloadHistoryProvider downloadHistoryProvider = Provider.of<DownloadHistoryProvider>(context,listen: false);

    scrollController.addListener(() {

      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100){
        downloadHistoryProvider.getDownloadHistory(masterProvider,downloadHistoryProvider);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "downloadHistory.downloadHistory")),
        centerTitle: true,
      ),
      body: SafeArea(
        child:RefreshIndicator(
          onRefresh: (()async{
            setState(() {
              downloadHistoryProvider.setPageToBeRequested = -1;
              downloadHistoryProvider.setDownloadHistoryForRefresh = [];
            });
          }),
          child: FutureBuilder(
            future: downloadHistoryProvider.getDownloadHistory(masterProvider,downloadHistoryProvider),// some future
            builder: ((BuildContext context, AsyncSnapshot<List> snapshot){
              if(snapshot.hasData && (snapshot.connectionState == ConnectionState.done)){
                if(downloadHistoryProvider.getReturnStatus == 301 || downloadHistoryProvider.getReturnStatus == 401){
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
                  return Consumer<DownloadHistoryProvider>(builder: ((context, provider,child){
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: provider.getIsLoading ?  provider.getDownloadHistoryData.length + 1 : provider.getDownloadHistoryData.length,
                      itemBuilder: ((BuildContext context, int index){
                        if(provider.getIsLoading){
                          if(provider.getDownloadHistoryData.length == index){
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(child: CircularProgressIndicator(),),
                            );
                          }
                          else{
                            return DownloadHistoryItem(snapshot.data[index]);
                          }
                        }
                        else{
                          return DownloadHistoryItem(snapshot.data[index]);
                        }
                      }),
                    );
                  }),);
                }
                else{
                  return Center(child: Text(getTranslated(context, "downloadHistory.youDontHaveAnyCards")),);
                }
              }
              else{
                return Center(child:CircularProgressIndicator());
              }


            }),
        )
        )
      ),

    );
  }
}