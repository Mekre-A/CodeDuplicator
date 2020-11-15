import 'package:evd_retailer/Components/AgentRefillHistoryComponent/widgets/agent_refill_history_item.dart';
import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/AgentRefillHistoryProvider.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgentRefillHistory extends StatefulWidget{

  @override
  _AgentRefillHistoryState createState() => _AgentRefillHistoryState();
}

class _AgentRefillHistoryState extends State<AgentRefillHistory> {

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen: false);

    AgentRefillHistoryProvider agentRefillHistoryProvider = Provider.of<AgentRefillHistoryProvider>(context,listen: false);

    scrollController.addListener(() {

      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100){
        agentRefillHistoryProvider.getAgentRefillHistory(masterProvider,agentRefillHistoryProvider);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "agent.refillHistory")),
        centerTitle: true,
      ),
      body: SafeArea(
        child:RefreshIndicator(
          onRefresh: (()async{
            setState(() {
              agentRefillHistoryProvider.setPageToBeRequested = -1;
              agentRefillHistoryProvider.setAgentRefillHistoryForRefresh = [];
            });
          }),
          child: FutureBuilder(
            future: agentRefillHistoryProvider.getAgentRefillHistory(masterProvider,agentRefillHistoryProvider),// some future
            builder: ((BuildContext context, AsyncSnapshot<List> snapshot){
              if(snapshot.hasData && (snapshot.connectionState == ConnectionState.done)){
                if(agentRefillHistoryProvider.getReturnStatus == 301 || agentRefillHistoryProvider.getReturnStatus == 401){
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
                  return Consumer<AgentRefillHistoryProvider>(builder: ((context, provider,child){
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: provider.getIsLoading ?  provider.getAgentRefillHistoryData.length + 1 : provider.getAgentRefillHistoryData.length,
                      itemBuilder: ((BuildContext context, int index){
                        if(provider.getIsLoading){
                          if(provider.getAgentRefillHistoryData.length == index){
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(child: CircularProgressIndicator(),),
                            );
                          }
                          else{
                            return AgentRefillHistoryItem(snapshot.data[index]);
                          }
                        }
                        else{
                          return AgentRefillHistoryItem(snapshot.data[index]);
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