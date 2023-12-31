import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spons/l10n/my_localization.dart';

import '../provider/watchlist_provider.dart';

class DetailMovies extends StatefulWidget {
  final Map<String, dynamic> movie;

  const DetailMovies({Key? key, required this.movie}) : super(key: key);

  @override
  State<DetailMovies> createState() => _DetailMoviesState();
}

class _DetailMoviesState extends State<DetailMovies> {
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###");
    final prov = Provider.of<WatchlistProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.movie['backdrop_path'] != null
                  ? Image.network(
                      "http://image.tmdb.org/t/p/w500/${widget.movie['backdrop_path']}",
                      fit: BoxFit.cover,
                      width: double.maxFinite,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/not_available.png');
                      },
                    )
                  : Image.asset('assets/not_available.png'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 12),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          widget.movie['original_title'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          widget.movie['release_date'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 104, 104, 104)),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          prov.toggleMovieInWatchlist(widget.movie);
                        },
                        icon: prov.isMovieInWatchlist(widget.movie)
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border),
                        label: Text(MyLocalization.of(context)!.favorite),
                      )
                    ],
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Text(
                    widget.movie['overview'],
                    textAlign: TextAlign.justify,
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Text(
                    MyLocalization.of(context)!.moreInfo,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          MyLocalization.of(context)!.languangeWords,
                        ),
                        Text(
                          "${widget.movie['original_language']}",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          MyLocalization.of(context)!.rating,
                        ),
                        Text(
                          "${widget.movie['vote_average'].toStringAsFixed(1)}",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          MyLocalization.of(context)!.voting,
                        ),
                        Text(
                          "${formatter.format(widget.movie['vote_count'])}",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          MyLocalization.of(context)!.popularity,
                        ),
                        Text(widget.movie['popularity']
                            .toString()
                            .replaceAll(".", "")),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          MyLocalization.of(context)!.ratedFor,
                        ),
                        Text(widget.movie['adult']
                            ? "17+ Mature"
                            : "13+ Violence"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
