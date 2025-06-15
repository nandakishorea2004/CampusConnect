import 'package:campus/app_ui/user_new/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});



  @override
  SplashUI createState()=> SplashUI();
}

class SplashUI extends State<SplashScreen>{



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timeCount();
  }

  timeCount() {
    Future.delayed(const Duration(seconds: 3), () {
      //  BlocProvider.of<AuthCheckBloc>(context).add(CheckAuth());
     Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => LoginPage()),
  (Route<dynamic> route) => false, // Remove all previous routes
);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body:Container(
        height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child:Image.asset('assets/images/onboarding_illustration.png',))
    );
  }



}