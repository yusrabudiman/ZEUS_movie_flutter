import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:spons/l10n/my_localization.dart';
import 'package:spons/leftnav.dart';

import '../detailpage/DetailMovie.dart';

class appSearch extends StatefulWidget {
  const appSearch({super.key});

  @override
  State<appSearch> createState() => _appSearchState();
}

class _appSearchState extends State<appSearch> {
  int coin = 0; //coin for purchase or only using
  late BannerAd _bannerAd;
  bool _isBannerReady = false;
  bool _isAdEnabled = true;

  late InterstitialAd _interstitialAd;
  bool _isInterstitialReady = false;

  late TextEditingController controller = TextEditingController();
  String searchString = "";
  late Stream<List<dynamic>> searchData;

  Future<List<dynamic>> fetchData() async {
    final response = await Dio().get(
        'https://api.themoviedb.org/3/search/movie?query=$searchString&api_key=6e6c2ac305876492f99cc067787a39a0');
    if (response.statusCode == 200) {
      return response.data['results'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    searchString = "";
    searchData = fetchData().asStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: TextField(
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  setState(() {
                    searchString = value;
                    searchData = fetchData().asStream();
                  });
                },
                controller: controller,
                decoration: InputDecoration(
                    labelText: MyLocalization.of(context)!.search,
                    prefixIcon: Icon(Icons.search),
                    hintText: "Oppenheimer"),
              ),
            ),
          ),
          StreamBuilder<List>(
            stream: searchData,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                List? data = snapshot.data;
                return data!
                        .where((item) => item['title'].contains(searchString))
                        .isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                MyLocalization.of(context)!.descSearch,
                                textAlign: TextAlign.center,
                              ),
                              Expanded(
                                  child: _isBannerReady && _isAdEnabled
                                      ? Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            width:
                                                _bannerAd.size.width.toDouble(),
                                            height: _bannerAd.size.height
                                                .toDouble(),
                                            child: AdWidget(ad: _bannerAd),
                                          ),
                                        )
                                      : Container())
                            ],
                          ),
                        )),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int position) {
                            return data[position]['title']
                                    .contains(searchString)
                                ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailMovies(
                                            movie: data[position],
                                          ),
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      title: Text(data[position]['title']),
                                      subtitle: Text('Release: ' +
                                          data[position]['release_date'] +
                                          ' - Vote: ' +
                                          data[position]['vote_average']
                                              .toString()),
                                    ),
                                  )
                                : Container();
                          },
                          childCount: data.length,
                        ),
                      );
              } else if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text("${snapshot.error}")),
                );
              } else {
                return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ],
      ),
    ));
  }

  void _loadBannerAd() {
    if (_isAdEnabled) {
      _bannerAd = BannerAd(
          size: AdSize.banner,
          adUnitId: 'ca-app-pub-3940256099942544/6300978111',
          listener: BannerAdListener(onAdLoaded: (_) {
            setState(() {
              _isBannerReady = true;
            });
          }),
          request: AdRequest());
    }
    _bannerAd.load();
  }
}
