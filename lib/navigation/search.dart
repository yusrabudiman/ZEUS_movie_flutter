import 'package:flutter/material.dart';

class appSearch extends StatefulWidget {
  const appSearch({super.key});

  @override
  State<appSearch> createState() => _appSearchState();
}

class _appSearchState extends State<appSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Search'),
            centerTitle: true,
            pinned: true,
          ),
          SliverAppBar(
            flexibleSpace: Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Decorator',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32))),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
