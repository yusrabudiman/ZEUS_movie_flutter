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
  //show movie
  List<Map<String, dynamic>> _trendings = [];
  List<Map<String, dynamic>> _movies = [];
  List<Map<String, dynamic>> _nowPlaying = [];

  @override
  void initState() {
    super.initState();
    getRecomended();
    getTrending();
    getNowPlaying();
  }

  void getTrending() async {
    try {
      var response = await Dio().get(
          "https://api.themoviedb.org/3/trending/movie/day?api_key=6e6c2ac305876492f99cc067787a39a0");
      var dataset = response.data['results'];

      setState(() {
        _trendings = List<Map<String, dynamic>>.from(dataset).take(5).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  void getRecomended() async {
    try {
      var response = await Dio().get(
          "https://api.themoviedb.org/3/movie/popular?api_key=6e6c2ac305876492f99cc067787a39a0");
      var data = response.data['results'];

      setState(() {
        _movies = List<Map<String, dynamic>>.from(data).take(6).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  void getNowPlaying() async {
    try {
      var response = await Dio().get(
          "https://api.themoviedb.org/3/movie/now_playing?api_key=6e6c2ac305876492f99cc067787a39a0");
      var nowplaying = response.data["results"];

      setState(() {
        _nowPlaying =
            List<Map<String, dynamic>>.from(nowplaying).take(6).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 1.8;
    // final double itemWidth = size.width / 2;
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('Movie'),
          centerTitle: true,
          expandedHeight: 320,
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
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _trendings.length,
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
                                  builder: (context) =>
                                      DetailMovies(movie: _trendings[index])));
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(kSpacing)),
                              child: Image.network(
                                  'http://image.tmdb.org/t/p/w500/${_trendings[index]['poster_path']}'),
                            ),
                            Text(
                              '${_trendings[index]['original_title']}',
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
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

        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 2, //width / height
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Padding(
                  padding:
                      EdgeInsets.only(left: 12, bottom: 12, right: 12, top: 11),
                  child: Card(
                    elevation: 20,
                    color: Color.fromARGB(255, 23, 24, 28),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailMovies(
                                      movie: _movies[index],
                                    )));
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(kSpacing)),
                            child: Image.network(
                                'http://image.tmdb.org/t/p/w500/${_movies[index]['poster_path']}'),
                          ),
                          Text(
                            '${_movies[index]['original_title']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${_movies[index]['release_date']}',
                          ),
                        ],
                      ),
                    ),
                  ));
            },
            childCount: _movies.length,
          ), //gridcount
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
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _nowPlaying.length,
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
                                        movie: _nowPlaying[index],
                                      )));
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(kSpacing)),
                              child: Image.network(
                                  'http://image.tmdb.org/t/p/w500/${_nowPlaying[index]['backdrop_path']}'),
                            ),
                            Text(
                              '${_nowPlaying[index]['original_title']}',
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
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
