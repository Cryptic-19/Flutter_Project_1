import 'package:flutter/material.dart';
import 'package:calculator/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calculator/pages/sign_up.dart';
import 'package:calculator/components/my_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool showLoginPage = true;

  void onTap() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  void showErrorMsg(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      showErrorMsg(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!showLoginPage) {
      return SignUp();
    }
    double displayW = MediaQuery.of(context).size.width;
    double displayH = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.green[200],
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: .07 * displayH),
            Icon(Icons.account_circle_outlined,
                size: 0.0005 * displayH * displayW),
            SizedBox(height: .07 * displayH),
            const Text(
              'Welcome Back!',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'We\'re so excited to see you again!',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            SizedBox(height: .035 * displayH),
            MyTextField(
              controller: emailController,
              hintText: 'email',
              obscureText: false,
            ),
            SizedBox(height: .014 * displayH),
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            SizedBox(height: .014 * displayH),
            MyButton(
                fnc: signUserIn,
                num: const Text('Sign In'),
                bgcolor: Colors.black87,
                fgcolor: Colors.white,
                wd: 0.90),

            SizedBox(height: .07 * displayH),

            // not a member? register now
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Not a member?',
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(width: .0056 * displayW),
              GestureDetector(
                onTap: onTap,
                child: const Text(
                  'Register now.',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]),
          ]),
        ))));
  }
}
