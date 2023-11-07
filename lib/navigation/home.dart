import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../detailpage/DetailMovie.dart';

class HomeList extends StatefulWidget {
  const HomeList({super.key});

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  double kSpacing = 14.00;
  BorderRadius kBorderRadius = BorderRadius.circular(20.00);

  late Stream<List<Map<String, dynamic>>> _trendings;
  late Stream<List<Map<String, dynamic>>> _movies;
  late Stream<List<Map<String, dynamic>>> _nowPlaying;

  @override
  void initState() {
    super.initState();
    _trendings = getTrending().asBroadcastStream();
    _movies = getMovies().asBroadcastStream();

    _nowPlaying = getNowPlaying().asBroadcastStream();
  }

  Stream<List<Map<String, dynamic>>> getTrending() {
    return Stream.fromFuture(_fetchTrending());
  }

  Future<List<Map<String, dynamic>>> _fetchTrending() async {
    try {
      var response = await Dio().get(
          "https://api.themoviedb.org/3/trending/movie/day?api_key=6e6c2ac305876492f99cc067787a39a0");
      var dataset = response.data['results'];
      return List<Map<String, dynamic>>.from(dataset).take(5).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> getMovies() {
    return Stream.fromFuture(_fetchMovies());
  }

  Future<List<Map<String, dynamic>>> _fetchMovies() async {
    try {
      var response = await Dio().get(
          "https://api.themoviedb.org/3/movie/popular?api_key=6e6c2ac305876492f99cc067787a39a0");
      var data = response.data['results'];
      return List<Map<String, dynamic>>.from(data).take(6).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> getNowPlaying() {
    return Stream.fromFuture(_fetchNowPlaying());
  }

  Future<List<Map<String, dynamic>>> _fetchNowPlaying() async {
    try {
      var response = await Dio().get(
          "https://api.themoviedb.org/3/movie/now_playing?api_key=6e6c2ac305876492f99cc067787a39a0");
      var nowplaying = response.data["results"];
      return List<Map<String, dynamic>>.from(nowplaying).take(6).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('Movie'),
          centerTitle: true,
          expandedHeight: 120,
          elevation: 0,
          pinned: true,
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              left: 15,
              top: 20,
            ),
            child: Text('Trending',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 290.0,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _trendings,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, int index) {
                        return Container(
                          width: 130.0,
                          child: Card(
                            elevation: 20,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailMovies(
                                            movie: snapshot.data![index])));
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(kSpacing)),
                                    child: Image.network(
                                        'http://image.tmdb.org/t/p/w500/${snapshot.data![index]['poster_path']}'),
                                  ),
                                  Text(
                                    '${snapshot.data![index]['original_title']}',
                                    style: TextStyle(fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('API sedang bermasalah');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          //
        ),

        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 5,
            ),
            child: Text('Recommended',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
          ),
        ),

        StreamBuilder<List<Map<String, dynamic>>>(
          stream: _movies,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 2, //width / height
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                        padding: EdgeInsets.only(
                            left: 12, bottom: 12, right: 12, top: 11),
                        child: Card(
                          elevation: 10,
                          color: Color.fromARGB(255, 23, 24, 28),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailMovies(
                                            movie: snapshot.data![index],
                                          )));
                            },
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(kSpacing)),
                                  child: Image.network(
                                      'http://image.tmdb.org/t/p/w500/${snapshot.data![index]['poster_path']}'),
                                ),
                                Text(
                                  '${snapshot.data![index]['original_title']}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                  childCount: snapshot.data?.length,
                ),
              );
            } else if (snapshot.hasError) {
              return SliverFillRemaining(child: Text('API dalam masalah'));
            } else {
              return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()));
            }
          },
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 5,
            ),
            child: Text('Now Playing',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200.0,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _nowPlaying,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, int index) {
                        return Container(
                          width: 260.0,
                          child: Card(
                            elevation: 20,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailMovies(
                                              movie: snapshot.data![index],
                                            )));
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(kSpacing)),
                                    child: Image.network(
                                        'http://image.tmdb.org/t/p/w500/${snapshot.data![index]['backdrop_path']}'),
                                  ),
                                  Text(
                                    '${snapshot.data![index]['original_title']}',
                                    style: TextStyle(fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error fetching data');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        ),
        //New column
      ],
    ));
  }
}
