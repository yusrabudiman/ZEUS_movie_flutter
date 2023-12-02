import 'package:flutter/material.dart';

class leftNavbarAksi extends StatefulWidget {
  const leftNavbarAksi({super.key});

  @override
  State<leftNavbarAksi> createState() => _leftNavbarAksiState();
}

class _leftNavbarAksiState extends State<leftNavbarAksi> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(),
            accountName: Text('victoria'),
            accountEmail: Text('testing@gmail.com'),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 17, 41, 49),
            ),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Profile'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => null,
          ),
          Divider(),
          ListTile()
        ],
      ),
    );
  }
}
