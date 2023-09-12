import 'package:flutter/material.dart';

class appSearch extends StatefulWidget {
  const appSearch({super.key});

  @override
  State<appSearch> createState() => _appSearchState();
}

class _appSearchState extends State<appSearch> {
  //type data

  //https://api.themoviedb.org/3/search/keyword?api_key=6e6c2ac305876492f99cc067787a39a0&query=The&page=1 query=search
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
