import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:spons/iklanbanner.dart';

import 'package:spons/l10n/my_localization.dart';
import 'package:spons/leftnav/profile.dart';
import 'package:spons/leftnav/settings.dart';
import 'package:firebase_database/firebase_database.dart';

class leftNavbarAksi extends StatefulWidget {
  const leftNavbarAksi({super.key});

  @override
  State<leftNavbarAksi> createState() => _leftNavbarAksiState();
}

class _leftNavbarAksiState extends State<leftNavbarAksi> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();
  String? email = FirebaseAuth.instance.currentUser?.email;
  String? realName;
  String? photoUrl;
  String? bio;
  late RewardedAd _rewardedAd;

  @override
  void initState() {
    super.initState();
    fetchRealName();
    fetchPhotoUrl();
  }

  void fetchRealName() {
    String? uid = _auth.currentUser?.uid;
    if (uid != null) {
      _dbRef
          .child('users')
          .child(uid)
          .child('realName')
          .onValue
          .listen((event) {
        if (event.snapshot.value != null) {
          setState(() {
            realName = event.snapshot.value as String?;
          });
        }
      });
    }
  }

  void fetchPhotoUrl() {
    String? uid = _auth.currentUser?.uid;
    if (uid != null) {
      _dbRef
          .child('users')
          .child(uid)
          .child('photoProfile')
          .onValue
          .listen((event) {
        if (event.snapshot.value != null) {
          setState(() {
            photoUrl = event.snapshot.value as String?;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  photoUrl != null ? NetworkImage(photoUrl!) : null,
            ),
            accountName: Text(realName ?? 'Loading...'),
            accountEmail: Text(email ?? 'None'),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 17, 41, 49),
            ),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text(MyLocalization.of(context)!.profile),
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profiles()))
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(MyLocalization.of(context)!.settings),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Pengaturan()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.ads_click),
            title: Text(MyLocalization.of(context)!.premiumPier),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(MyLocalization.of(context)!.premiumPier),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(MyLocalization.of(context)!.continueWatchAds),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextButton(
                            child: Text(MyLocalization.of(context)!
                                .premiumPier), // Text('watch Ads')
                            onPressed: () {
                              Navigator.pop(context);
                              RewardedAd.load(
                                  adUnitId:
                                      'ca-app-pub-3940256099942544/5224354917',
                                  request: AdRequest(),
                                  rewardedAdLoadCallback:
                                      RewardedAdLoadCallback(onAdLoaded: (ad) {
                                    _rewardedAd = ad;
                                    _rewardedAd?.show(
                                        onUserEarnedReward: (ad, reward) {
                                      debugPrint(
                                          "My Reward Amount -> ${reward.amount}");
                                    });
                                  }, onAdFailedToLoad: ((error) {
                                    debugPrint('error');
                                  })));
                            },
                          ),
                          TextButton(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
