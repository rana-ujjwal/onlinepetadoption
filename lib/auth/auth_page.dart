import 'package:flutter/material.dart';
import 'package:petadoptionapp/screens/signup_form_screen.dart';
import '../screens/login_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // initially show login page
  bool showLoginScreen = true;

  void toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(showSignUpFormScreen: toggleScreens);
    } else {
      return SignUpForm(showLoginScreen: toggleScreens);
    }
  }
}
