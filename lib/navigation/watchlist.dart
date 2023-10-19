import 'package:flutter/material.dart';

class Wathlist extends StatefulWidget {
  const Wathlist({super.key});

  @override
  State<Wathlist> createState() => _WathlistState();
}

class _WathlistState extends State<Wathlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
        centerTitle: true,
      ),
    );
  }
}
