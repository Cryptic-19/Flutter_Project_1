import 'package:flutter/material.dart';
import 'package:calculator/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calculator/pages/login_page.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool showLoginPage = false;

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

  void signUserUp() async {
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
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        showErrorMsg("Passwords are not matching!");
      }
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      showErrorMsg(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage();
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
            Text(
              'Create An Account',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Join our beautiful world of Arithmetic!',
              style: const TextStyle(
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
            MyTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),
            SizedBox(height: .014 * displayH),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                minimumSize: Size(displayW * 0.9, displayH * 0.075),
              ),
              onPressed: signUserUp,
              child: const Text('Sign Up'),
            ),
            SizedBox(height: .07 * displayH),

            // not a member? register now
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Already have an account?',
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(width: .0056 * displayW),
              GestureDetector(
                onTap: onTap,
                child: const Text(
                  'Login here.',
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
