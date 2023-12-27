import 'package:flutter/material.dart';

class Languanges extends StatefulWidget {
  const Languanges({super.key});

  @override
  State<Languanges> createState() => _LanguangesState();
}

class _LanguangesState extends State<Languanges> {
  String _selectedLocale = 'Indonesia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Languange'),
      ),
      body: Column(
        children: [
          RadioListTile(
            value: 'en',
            groupValue: _selectedLocale,
            onChanged: ((value) {
              setState(() {
                _selectedLocale = value!;
              });
            }),
            title: const Text('English'),
          ),
          RadioListTile(
            value: 'Indonesia',
            groupValue: _selectedLocale,
            onChanged: ((value) {
              setState(() {
                _selectedLocale = value!;
              });
            }),
            title: const Text('Indonesia'),
          ),
          RadioListTile(
            value: 'Chinese Traditional',
            groupValue: _selectedLocale,
            onChanged: ((value) {
              setState(() {
                _selectedLocale = value!;
              });
            }),
            title: const Text('Chinese Traditional'),
          ),
          RadioListTile(
            value: 'Es',
            groupValue: _selectedLocale,
            onChanged: ((value) {
              setState(() {
                _selectedLocale = value!;
              });
            }),
            title: const Text('Espanol'),
          ),
        ],
      ),
    );
  }
}
