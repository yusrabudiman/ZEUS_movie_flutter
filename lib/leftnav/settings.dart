import 'package:flutter/material.dart';
import 'package:spons/settings/languange.dart';

class Pengaturan extends StatefulWidget {
  const Pengaturan({super.key});

  @override
  State<Pengaturan> createState() => SPengaturanState();
}

class SPengaturanState extends State<Pengaturan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListTile(
        title: Text('Languange'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Languanges()));
        },
      ),
    );
  }
}
