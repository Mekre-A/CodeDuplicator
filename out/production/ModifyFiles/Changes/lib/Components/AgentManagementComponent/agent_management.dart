import 'package:evd_retailer/Components/AddAgentsComponent/add_agents.dart';
import 'package:evd_retailer/Components/AgentRefillBalanceComponent/agent_refill_balance.dart';
import 'package:evd_retailer/Components/AgentRefillHistoryComponent/agent_refill_history.dart';
import 'package:evd_retailer/Components/AgentsListComponent/agents_list.dart';
import 'package:evd_retailer/Providers/AgentRefillHistoryProvider.dart';
import 'package:evd_retailer/Providers/AgentsProvider.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgentManagement extends StatefulWidget{
  @override
  _AgentManagementState createState() => _AgentManagementState();
}

class _AgentManagementState extends State<AgentManagement> {


  List<Widget> pages = [
    AgentsList(),
    AddAgents(),
    AgentRefillBalance(null, null,false),
    ChangeNotifierProvider(create:(BuildContext context) => AgentRefillHistoryProvider(),child: AgentRefillHistory(),)

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Consumer<AgentsProvider>(builder: ((context,provider,child){
        return pages[provider.getCurrentPage];
      }),),
      bottomNavigationBar: Consumer<AgentsProvider>(builder: ((context,provider,child){
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: getTranslated(context, "agent.agents"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: getTranslated(context, "agent.addAgent"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money_rounded),
              label: getTranslated(context, "agent.refill"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: getTranslated(context, "agent.refillHistory"),
            ),
          ],
          currentIndex: provider.getCurrentPage,
          onTap: (int index){
            provider.setCurrentPage = index;
          },
        );
      }),)
    );
  }
}