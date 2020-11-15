
import 'package:evd_retailer/Components/ReprintComponent/widgets/printed_item.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Services/HttpCalls.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Reprint extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen:false);
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "rePrint.rePrint")),
        centerTitle: true,
      ),
      body: SafeArea(
        child:Padding(
          padding: EdgeInsets.all(10.0),
          child: FutureBuilder(
            future: HttpCalls.getGroupedPrintedCards(masterProvider), // some future
            builder: ((BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                if(snapshot.data.isEmpty){
                  return Center(child: Text(getTranslated(context, "rePrint.inOrderToReprint")));
                }
                else{
                  return ListView.builder(
                    itemBuilder: ((BuildContext context, int index){
                      return PrintedItem(snapshot.data[index]);
                    }),
                    itemCount: snapshot.data.length,
                  );
                }
              }
              else{
                return Center(child: CircularProgressIndicator());
              }
            }),
          ),
        )
      ),
    );
  }
}