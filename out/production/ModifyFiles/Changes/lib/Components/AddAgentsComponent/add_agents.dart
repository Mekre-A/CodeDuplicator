import 'package:evd_retailer/Components/AgentActivationComponent/agent_activation.dart';
import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/AgentsProvider.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:evd_retailer/Services/Validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AddAgents extends StatefulWidget{
  @override
  _AddAgentsState createState() => _AddAgentsState();
}

class _AddAgentsState extends State<AddAgents> {
  TextEditingController agentNameController, agentPhoneNumberController;
  @override
  void initState(){
    super.initState();
    agentNameController = TextEditingController();
    agentPhoneNumberController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    AgentsProvider agentsProvider = Provider.of<AgentsProvider>(context,listen: false);
    MasterProvider masterProvider = Provider.of<MasterProvider>(context, listen: false);


    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "agent.addNewAgent")),
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
                TextFormField(
                  controller: agentPhoneNumberController,
                  keyboardType: TextInputType.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: getTranslated(context,"agent.phoneNumber"),
                    border: OutlineInputBorder()
                  ),

                  validator: (value){
                    return Validator.validatePhone(value, context);
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: agentNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: getTranslated(context, "agent.agentName"),
                      border: OutlineInputBorder()
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value){
                    return Validator.validateName(value, context);
                  },
                ),
                SizedBox(height: 30,),
                Consumer<AgentsProvider>(builder: ((context,provider,child){
                  if(provider.getIsAddingAgent){
                    return CircularProgressIndicator();
                  }
                  return Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          onPressed: ()async{
                            if(Validator.validateName(agentNameController.text, context) != null || Validator.validatePhone(agentPhoneNumberController.text, context) != null ){
                              return;
                            }
                            provider.setIsAddingAgent =  true;
                            int code = await HttpCalls.registerAgent(masterProvider, agentsProvider, agentNameController.text, agentPhoneNumberController.text);
                            provider.setIsAddingAgent =  false;
                            if(code == 200){
                              Fluttertoast.showToast(
                                  msg: getTranslated(context, "agent.activationSent"),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> AgentActivation(agentPhoneNumberController.text)));
                            }
                            else if (code == 301 || code == 401) {

                              await masterProvider.logOut();
                              SharedPref.logOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Login()),
                                      (route) => false);
                            }
                            else if(code == 400){
                              Fluttertoast.showToast(
                                  msg: getTranslated(context, "agent.phoneMayBeUsed"),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            else if(code == 500){
                              Fluttertoast.showToast(
                                  msg: getTranslated(context, "agent.oops"),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            else if(code == -1){
                              Fluttertoast.showToast(
                                  msg: getTranslated(context, "agent.checkInternetConnection"),
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
                            child: Text(getTranslated(context, "agent.addAgent"),style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ],
                  );
                }),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}