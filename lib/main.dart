import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spons/formpage/flutter_form_log_sign.dart';

import 'package:spons/menu.dart';
import 'package:spons/provider/watchlist_provider.dart';

import 'detailpage/DetailMovie.dart';
import 'navigation/home.dart';
import 'navigation/search.dart';
import 'navigation/watchlist.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => WatchlistProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data != null) {
              return MyWidget(); // If a user is signed in, navigate to MyWidget
            } else {
              return LoginForm(); // If no user is signed in, show the login form
            }
          } else {
            return CircularProgressIndicator(); // Show a loading spinner while waiting
          }
        },
      ),
    );
  }
}
