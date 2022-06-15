import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petadoptionapp/auth/main_page.dart';
import 'package:petadoptionapp/screens/add_pet_screen.dart';
import 'package:petadoptionapp/screens/adoption_screen.dart';
import 'package:petadoptionapp/screens/favourites_screen.dart';
import 'package:petadoptionapp/screens/my_profile.dart';
import 'package:petadoptionapp/screens/requests_screen.dart';
import 'package:petadoptionapp/screens/user_screen.dart';
import 'package:petadoptionapp/screens/settings_screen.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  final user = FirebaseAuth.instance.currentUser;
  int counter = 0;
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    String name = user!.displayName ?? 'Ujjwal Ranamagar';
    String email = user!.email!;
    const urlImage =
        "https://yt3.ggpht.com/ytc/AKedOLTJHhEoeEE1JicUIpl08BjnckQLCj8PJurDxOu9JA=s900-c-k-c0x00ffffff-no-rj";
    return Drawer(
      child: Material(
        color: Theme.of(context).primaryColor,
        child: ListView(
          children: <Widget>[
            buildHeader(
                urlImage: urlImage,
                name: name,
                email: email,
                onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserPage(
                          name: name,
                          urlImage: urlImage,
                        )))),
            const SizedBox(height: 48),
            buildMenuItem(
              text: 'Home',
              icon: FontAwesomeIcons.house,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Favourites',
              icon: FontAwesomeIcons.heart,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Add Pet',
              icon: FontAwesomeIcons.plus,
              onClicked: () => selectedItem(context, 2),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'My Profile',
              icon: FontAwesomeIcons.user,
              onClicked: () => selectedItem(context, 3),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Requests',
              icon: FontAwesomeIcons.bell,
              onClicked: () => selectedItem(context, 4),
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.white),
            const SizedBox(height: 24),
            buildMenuItem(
              text: 'Settings',
              icon: FontAwesomeIcons.gear,
              onClicked: () => selectedItem(context, 5),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Logout',
              icon: FontAwesomeIcons.powerOff,
              onClicked: () => selectedItem(context, 6),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    const color = Colors.white;
    const hoverColor = Colors.white70;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color, fontSize: 18)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AdoptionScreen(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const FavouritesPage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AddPet(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const MyProfilePage(),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const RequestPage(),
        ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ));
        break;
      case 6:
        FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
            (route) => false);
        break;
    }
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(urlImage),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
      );
}
