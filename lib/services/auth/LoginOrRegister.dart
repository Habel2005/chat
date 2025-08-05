import 'package:flutter/material.dart';
import 'package:chat/pages/login.dart';
import 'package:chat/pages/register.dart';
class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginOrRegister> {
  bool showLogin =true; //initially login page

  void toogle()
  {
    setState(() {
      showLogin = !showLogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLogin) {
      return LoginPage(onTap: toogle);
    } else {
      return RegisterPage(onTap: toogle);
    }
  }
}