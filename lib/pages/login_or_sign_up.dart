/*import 'package:flutter/material.dart';
import 'package:calculator/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calculator/pages/sign_up.dart';
import 'package:calculator/pages/login_page.dart';

class LoginOrSignup extends StatefulWidget {
  LoginOrSignup({
    super.key,
  });

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  bool showLoginPage = true;

  void togglepages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglepages);
    } else {
      return SignUp(onTap: togglepages);
    }
  }
}*/
