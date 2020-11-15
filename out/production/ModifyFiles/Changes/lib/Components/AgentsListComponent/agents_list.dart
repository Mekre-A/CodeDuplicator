import 'package:evd_retailer/Components/AgentActivationComponent/agent_activation.dart';
import 'package:evd_retailer/Components/AgentRefillBalanceComponent/agent_refill_balance.dart';
import 'package:evd_retailer/Components/AgentsListComponent/widgets/agent_list_item.dart';
import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/AgentsProvider.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgentsList extends StatefulWidget {
  @override
  _AgentsListState createState() => _AgentsListState();
}

class _AgentsListState extends State<AgentsList> {
  TextEditingController searchController;
  FocusNode searchFocus = FocusNode();
  AgentsProvider agentsProvider;
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();

    searchController.addListener(() {
      if (searchController.text == null ||
          searchController.text.trim().isEmpty) {
        agentsProvider.setSearchableAgents = agentsProvider.getAgents;
      } else {
        agentsProvider.setSearchableAgents = LocalCalls.getAgentBySearchChars(
            agentsProvider.getAgents, searchController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider =
        Provider.of<MasterProvider>(context, listen: false);
    agentsProvider = Provider.of<AgentsProvider>(context, listen: false);


    return Scaffold(
      appBar: AppBar(
        title: Consumer<AgentsProvider>(
          builder: ((context, provider, child) {
            return provider.getIsSearching
                ? TextFormField(
                    controller: searchController,
                    focusNode: searchFocus,
                    decoration: InputDecoration(
                      hintText: getTranslated(context, "agent.searchHere"),
                      hintStyle: TextStyle(color: Colors.white54),

                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    getTranslated(context, "agent.agents"),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
          }),
        ),

        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Consumer<AgentsProvider>(
                builder: ((context, provider, child) {
                  return provider.getIsSearching
                      ? IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            provider.setIsSearching = false;
                            agentsProvider.setSearchableAgents = agentsProvider.getAgents;
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            searchFocus.requestFocus();
                            provider.setIsSearching = true;
                          },
                        );
                }),
              ))
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: HttpCalls.getAgents(masterProvider, agentsProvider),
          builder: ((BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == 200) {
                return Consumer<AgentsProvider>(
                  builder: ((context, provider, child) {
                    if (provider.getAgents.isEmpty) {
                      return Center(
                          child:
                              Text(getTranslated(context, "agent.noAgents")));
                    } else {
                      if (provider.getSearchableAgents.length == 0) {
                        return Center(
                          child: Text(
                              getTranslated(context,"agent.noAgentFromSearch")),
                        );
                      }
                    }
                    return ListView.builder(
                      itemCount: provider.getSearchableAgents.length,
                      itemBuilder: ((BuildContext context, int index) {
                        return InkWell(
                          child: AgentListItem(provider.getSearchableAgents[index]),
                          onTap: () async {
                            if (provider.getSearchableAgents[index].status ==
                                "0") {
                              int code = 0;
                              code = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AgentActivation(
                                          provider.getSearchableAgents[index]
                                              .phone)));
                              if (code == 1) {
                                setState(() {});
                              }
                            } else {
                             Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AgentRefillBalance(
                                          provider.getSearchableAgents[index]
                                              .phone,provider.getSearchableAgents[index]
                                          .name,true)));
                            }
                          },
                        );
                      }),
                    );
                  }),
                );
              } else if (snapshot.data == -1) {
                return Center(
                    child: Text(getTranslated(
                        context, "agent.checkInternetConnection")));
              }
              else if(snapshot.data == 301 || snapshot.data == 401){
                Future.delayed(Duration(seconds: 0)).then((value)async{
                  await masterProvider.logOut();
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

              else if (snapshot.data == 500) {
                return Center(
                    child: Text(getTranslated(context, "agent.oops")));
              } else {
                return Center(
                    child:
                        Text(getTranslated(context, "agent.pleaseTryAgain")));
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ),
      ),
    );
  }
}
