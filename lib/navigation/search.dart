import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../detailpage/DetailMovie.dart';

class appSearch extends StatefulWidget {
  const appSearch({super.key});

  @override
  State<appSearch> createState() => _appSearchState();
}

class _appSearchState extends State<appSearch> {
  TextEditingController controller = TextEditingController();
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
    searchString = "";
    searchData = fetchData().asStream();
  }

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
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchString = value;
                    searchData = fetchData().asStream();
                  });
                },
                controller: controller,
                decoration: InputDecoration(
                    labelText: "Search Movie",
                    prefixIcon: Icon(Icons.search),
                    hintText: "Try: Oppenheimer"),
              ),
            ),
          ),
          StreamBuilder<List>(
            stream: searchData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int position) {
                      return snapshot.data[position]['title']
                              .contains(searchString)
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailMovies(
                                      movie: snapshot.data[position],
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(snapshot.data[position]['title']),
                                subtitle: Text('Release: ' +
                                    snapshot.data[position]['release_date'] +
                                    ' - Vote: ' +
                                    snapshot.data[position]['vote_average']
                                        .toString()),
                              ),
                            )
                          : Container();
                    },
                    childCount: snapshot.data.length,
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
}
