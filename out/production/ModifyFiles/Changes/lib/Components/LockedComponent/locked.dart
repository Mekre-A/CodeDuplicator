import 'package:evd_retailer/Components/AllComponent/all.dart';
import 'package:evd_retailer/Components/LoginComponent/login.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:evd_retailer/Services/Validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Locked extends StatefulWidget {
  LockedState createState() => LockedState();
}

class LockedState extends State<Locked> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider =
        Provider.of<MasterProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "locked.locked")),
        centerTitle: true,
        actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (String value)async{
                await masterProvider.logOut();
                SharedPref.logOut();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()),(route) => false);
              },
              itemBuilder: (BuildContext context){
                return [
                  PopupMenuItem<String>(
                  child:Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0),
                    child: Text(getTranslated(context, "locked.logOut")),
                  ),
                  value: "Logout",
                )
                ];
              },
            )
            ],
          ),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: Icon(
                Icons.lock_outline,
                size: 200.0,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 20.0),
                  child: TextFormField(
                    validator: (value) {
                      return Validator.validatePassword(value,context);
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    controller: controller,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50.0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () {
                              if (Validator.validatePassword(controller.text,context) ==
                                  null) {
                                if (masterProvider.getPassKey ==
                                    controller.text) {
                                  SharedPref.setLocked(false);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => All()),
                                      (route) => false);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: getTranslated(context, "locked.wrongPassword"),
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.black,
                                      fontSize: 16.0);
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                getTranslated(context, "locked.unlock"),
                                style:
                                    TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
