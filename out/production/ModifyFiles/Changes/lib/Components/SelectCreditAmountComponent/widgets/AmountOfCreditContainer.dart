import 'package:evd_retailer/Components/SellMobileCard/sell_mobile_card.dart';
import 'package:evd_retailer/Providers/MasterProvider.dart';
import 'package:evd_retailer/Providers/SellCardProvider.dart';
import 'package:evd_retailer/Services/LocalizationMethod.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AmountOfCreditContainer extends StatelessWidget{

  final Color color;
  final int amount;
  final int stock;

  AmountOfCreditContainer({@required this.color,@required this.amount,@required this.stock});

  @override
  Widget build(BuildContext context) {

    MasterProvider masterProvider = Provider.of<MasterProvider>(context,listen:false);


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(0.0),
          height: 10,

          decoration: BoxDecoration(
              color: int.parse(masterProvider.getUser.currentBalance) >= amount || ((masterProvider.getDownloadedCards.containsKey("$amount")) && masterProvider.getDownloadedCards["$amount"].isNotEmpty)  ? color : Colors.grey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0))),
        ),

        InkWell(
          child: Container(
            height: 80,
            margin: EdgeInsets.all(0.0),
            child: Card(
                shape: Border.all(style: BorderStyle.none),
                margin: EdgeInsets.all(0.0),
                child: Center(child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("$amount",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold, color: (int.parse(masterProvider.getUser.currentBalance) >= amount || ((masterProvider.getDownloadedCards.containsKey("$amount")) && masterProvider.getDownloadedCards["$amount"].isNotEmpty )) ? color : Colors.grey)),
                   stock == null || stock == 0 ?  Container() : Text("${getTranslated(context, "MainScreen.stock")} $stock",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.green)),
                  ],
                ),
                
                )),
          ),
          onTap: (){
            if(int.parse(masterProvider.getUser.currentBalance) >= amount || ((masterProvider.getDownloadedCards.containsKey("$amount")) && masterProvider.getDownloadedCards["$amount"].isNotEmpty) ){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create: (BuildContext context) => SellCardProvider(), child: SellMobileCard(amount: amount,)),) );
            }
          },
        )
      ],
    );

  }
}