import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'navigation/home.dart';
import 'navigation/search.dart';
import 'navigation/watchlist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String title = "Home";
  int _indexNavigation = 0;

  @override
  Widget build(BuildContext context) {
    Widget _widgetNavigation() {
      if (_indexNavigation == 0) {
        return HomeList();
      } else if (_indexNavigation == 1) {
        return appSearch();
      } else {
        return Wathlist();
      }
    }

    return Scaffold(
      body: _widgetNavigation(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexNavigation,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Watchlist')
        ],
        onTap: (value) {
          if (value == 0) {
            title = "Home";
          }
          if (value == 1) {
            title = "Search";
          }
          if (value == 2) {
            title = "Watchlist";
          }
          setState(() {
            _indexNavigation = value;
          });
        },
      ),
    );
  }
}
