import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spons/leftnav/profile.dart';
import 'package:spons/leftnav/settings.dart';

class leftNavbarAksi extends StatefulWidget {
  const leftNavbarAksi({super.key});

  @override
  State<leftNavbarAksi> createState() => _leftNavbarAksiState();
}

class _leftNavbarAksiState extends State<leftNavbarAksi> {
  String? email = FirebaseAuth.instance.currentUser?.email;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(),
            accountName: Text('victoria'),
            accountEmail: Text('$email'),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 17, 41, 49),
            ),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Profile'),
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profiles()))
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
        ],
      ),
    );
  }
}
