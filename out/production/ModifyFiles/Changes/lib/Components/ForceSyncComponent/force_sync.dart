import 'package:evd_retailer/Components/AllComponent/all.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:evd_retailer/Services/SharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ForceSync extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MasterProvider masterProvider =
        Provider.of<MasterProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "forceSync.forceSync")),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            height: 500,
            width: 350,
            child: Card(
              elevation: 5.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                        getTranslated(context, "forceSync.tooManyCards"),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RaisedButton(
                    child: Text("Sync All"),
                    onPressed: () {
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
                                      child: Text(getTranslated(
                                          context, "all.syncingInProgress")),
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Center(child: CircularProgressIndicator())
                                ],
                              ),
                            ],
                          ));
                      if(masterProvider.getIsSyncing){
                        return;
                      }
                      else{
                        masterProvider.setIsSyncing = true;
                      }
                      HttpCalls.syncCardsBehindTheScenes(masterProvider)
                          .then((value) async{
                        masterProvider.setIsSyncing = false;
                        if (value == 200 || value == 204) {
                          await SharedPref.setForceSync(false);
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                              msg: getTranslated(context, "forceSync.allSyncedSuccessfully"),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.black,
                              fontSize: 16.0);
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => All()),(route) => false);

                        } else {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              child: SimpleDialog(
                                children: <Widget>[
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(getTranslated(
                                          context, "all.syncingFailed")),
                                    ),
                                  ),
                                ],
                              ));
                        }
                      }).catchError((onError) {
                        masterProvider.setIsSyncing = false;
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            child: SimpleDialog(
                              children: <Widget>[
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                        getTranslated(context, "all.syncingFailed")),
                                  ),
                                ),
                              ],
                            ));
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
