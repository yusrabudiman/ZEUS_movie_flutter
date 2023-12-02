import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spons/leftnav.dart';

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
                    labelText: "Search Movies",
                    prefixIcon: Icon(Icons.search),
                    hintText: "Try: Oppenheimer"),
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
                            child:
                                Text('Try feature search, if you have idea')),
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
}
