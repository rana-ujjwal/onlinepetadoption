import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petadoptionapp/auth/main_page.dart';

class LogoutPage extends StatelessWidget {
  Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }

  const LogoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MainPage();
  }
}
