import 'package:flutter/material.dart';
import 'package:petadoptionapp/screens/navigation_drawer.dart';

class UserPage extends StatelessWidget {
  final String name;
  final String urlImage;
  const UserPage({Key? key, required this.name, required this.urlImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('The Pet Hub'),
        ),
        body: Image.network(
          urlImage,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ));
  }
}
