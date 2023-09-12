import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistProvider extends ChangeNotifier {
  List<String> _movies = [];
  List<String> get item => _movies;

  void toggleMovies(String item) {
    final isExist = _movies.contains(item);
    if (isExist) {
      _movies.remove(item);
    } else {
      _movies.add(item);
    }
    notifyListeners();
  }

  bool isExist(String item) {
    final isExist = _movies.contains(item);
    return isExist;
  }

  void clearMovies() {
    _movies = [];
    notifyListeners();
  }

  static WatchlistProvider of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<WatchlistProvider>(
      context,
      listen: listen,
    );
  }
}
