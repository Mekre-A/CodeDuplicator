import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/AgentsProvider.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:evd_retailer/Services/Validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AgentRefillBalance extends StatefulWidget {
  AgentRefillBalance(this.agentPhone, this.agentName,this.fromAgentsList);

  final String agentPhone;
  final String agentName;
  final bool fromAgentsList;

  @override
  _AgentRefillBalanceState createState() => _AgentRefillBalanceState();
}

class _AgentRefillBalanceState extends State<AgentRefillBalance> {
  TextEditingController agentBalanceController,
      remarkController,
      agentPhoneNumberController;


  @override
  void initState() {
    super.initState();
    agentBalanceController = TextEditingController();
    agentPhoneNumberController = TextEditingController();
    if (widget.agentPhone != null) {
      agentPhoneNumberController.text = widget.agentPhone;
    }

    remarkController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider =
        Provider.of<MasterProvider>(context, listen: false);
    AgentsProvider agentsProvider =
        Provider.of<AgentsProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "agent.refillAgentBalance")),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Consumer<AgentsProvider>(
                      builder: ((context, provider, child) {
                        if (provider.getToBeRefilledAgentName == "") {
                          if (widget.agentName == null) {
                            return Container();
                          } else {
                            return Text(
                              widget.agentName,
                              style: TextStyle(color: Colors.grey),
                            );
                          }
                        } else {
                          return Text(
                            provider.getToBeRefilledAgentName,
                            style: TextStyle(color: Colors.grey),
                          );
                        }
                      }),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: agentPhoneNumberController,
                  keyboardType: TextInputType.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: getTranslated(context, "agent.phoneNumber"),
                  ),
                  validator: (value) {
                    print("Getting called");
                    if (Validator.validatePhone(value, context) == null) {
                      Future.delayed(Duration(seconds: 0)).then((onValue) {
                        agentsProvider.setToBeRefilledAgentName =
                            LocalCalls.getAgentNameFromPhone(
                                agentsProvider.getAgents, value);
                      });
                    } else {
                      Future.delayed(Duration(seconds: 0)).then((onValue) {
                        agentsProvider.setToBeRefilledAgentName = "";
                      });
                    }
                    return Validator.validatePhone(value, context);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: agentBalanceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: getTranslated(context, "agent.balance"),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return Validator.validateBalance(value, context);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: remarkController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: getTranslated(context, "agent.remark"),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Consumer<AgentsProvider>(
                  builder: ((context, provider, child) {
                    if (provider.getIsRefillingBalance) {
                      return CircularProgressIndicator();
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () async {
                              if (Validator.validateBalance(
                                          agentBalanceController.text, context) !=
                                      null ||
                                  Validator.validatePhone(
                                          agentPhoneNumberController.text,
                                          context) !=
                                      null) {
                                return;
                              }
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  child: SimpleDialog(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(
                                                "${getTranslated(context, "agent.areYouSureYouWantToRefill")} ${agentBalanceController.text} ${getTranslated(context, "agent.birrTo")} ${agentPhoneNumberController.text}",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              FlatButton(
                                                color: Colors.red,
                                                child: Text(
                                                  getTranslated(
                                                      context, "agent.cancel"),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              FlatButton(
                                                color: Colors.green,
                                                child: Text(
                                                  getTranslated(
                                                      context, "agent.refill"),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  provider.setIsRefillingBalance =
                                                      true;
                                                  int code = await HttpCalls
                                                      .refillAgentBalance(
                                                          masterProvider,
                                                          agentBalanceController
                                                              .text,
                                                          agentPhoneNumberController
                                                              .text,
                                                          remarkController.text);
                                                  if(code == 200 && widget.fromAgentsList){
                                                    await HttpCalls.getAgents(masterProvider, agentsProvider);
                                                  }
                                                  provider.setIsRefillingBalance =
                                                      false;
                                                  if (code == 200) {
                                                    Fluttertoast.showToast(
                                                        msg: getTranslated(context,
                                                            "agent.balanceRefilled"),
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.green,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                    if(widget.fromAgentsList){
                                                      Navigator.pop(context);
                                                    }
                                                    else{
                                                      agentsProvider.setCurrentPage = 0;
                                                    }
                                                  } else if (code == 301 || code == 401) {
                                                    await masterProvider.logOut();
                                                    SharedPref.logOut();
                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Login()),
                                                            (route) => false);
                                                  }
                                                  else if (code == 400) {
                                                    Fluttertoast.showToast(
                                                        msg: getTranslated(context,
                                                            "agent.youCantRefillThisAmount"),
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  } else if (code == 500) {
                                                    Fluttertoast.showToast(
                                                        msg: getTranslated(
                                                            context, "agent.oops"),
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  } else if (code == -1) {
                                                    Fluttertoast.showToast(
                                                        msg: getTranslated(context,
                                                            "agent.checkInternetConnection"),
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  }
                                                },
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                getTranslated(context, "agent.transfer"),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
