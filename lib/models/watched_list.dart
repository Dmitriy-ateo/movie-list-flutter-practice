import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_practice/models/movie.dart';

class WatchedListNotifier extends ChangeNotifier {
  final List<Movie> _items = [];

  UnmodifiableListView<Movie> get items => UnmodifiableListView(_items);

  void add(Movie item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(int itemId) {
    _items.removeWhere((element) => element.id == itemId);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}
