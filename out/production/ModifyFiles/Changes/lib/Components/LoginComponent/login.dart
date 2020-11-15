import 'package:evd_retailer/Components/LoginComponent/widgets/login_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait ? LoginBody() : SingleChildScrollView(child: LoginBody(),)
  )
  );


  }

}