import 'package:flutter/material.dart';

class PairedDevicesItem extends StatelessWidget{

  PairedDevicesItem(this.name, this.address);
  final String name, address;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Center(child: Text("$name",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),
            Center(child: Text("$address",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),),
          ],
        ),
      ),
    );
  }
}