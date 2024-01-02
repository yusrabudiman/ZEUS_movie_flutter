import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spons/formpage/flutter_form_log_sign.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:spons/l10n/my_localization.dart';
import 'package:spons/l10n/my_localization_delegate.dart';

import 'package:spons/menu.dart';
import 'package:spons/provider/watchlist_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => WatchlistProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  MyLocalizationDelegate _myLocalizationDelegate =
      MyLocalizationDelegate(Locale('en', 'US'));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        _myLocalizationDelegate
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('id', 'ID'),
      ],
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      // home: TestingBahasa(),
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data != null) {
              return MyWidget();
            } else {
              return LoginForm();
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

// class TestingBahasa extends StatefulWidget {
//   @override
//   _TestingBahasaState createState() => _TestingBahasaState();
// }

// class _TestingBahasaState extends State<TestingBahasa> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Localization'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               ElevatedButton(
//                 child: Text('English'),
//                 onPressed: () {
//                   setState(() {
//                     MyLocalization.load(Locale('en', 'US'));
//                   });
//                 },
//               ),
//               Text(MyLocalization.of(context)!.helloWorld),
//               ElevatedButton(
//                 child: Text('Indonesia'),
//                 onPressed: () {
//                   setState(() {
//                     MyLocalization.load(Locale('id', 'ID'));
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
