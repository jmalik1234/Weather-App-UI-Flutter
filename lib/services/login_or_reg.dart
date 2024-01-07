import 'package:flutter/material.dart';
import 'package:weather_app/screens/home.dart';

import '../screens/login.dart';
import '../screens/reg.dart';

class LoginOrReg extends StatefulWidget {
  const LoginOrReg({super.key});

  State<LoginOrReg> createState() => _LoginReg();
}

class _LoginReg extends State<LoginOrReg> {
  bool showLogin = true; //false is register page

  void togglePage() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (showLogin) {
      //when you reach the login page change the state to !showLogin
      //create a login page
      print("on login page did not just reg");
      return LoginPage(onTap: togglePage);
    } else {
      return RegPage(onTap: togglePage);
    }
    //when you reach the register page change the state to !showLogin
  }
}
