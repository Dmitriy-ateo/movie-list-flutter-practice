import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_practice/models/movie.dart';

class WatchListNotifier extends ValueNotifier<List<Movie>> {

  WatchListNotifier(List<Movie> value): super(value);

  void setItems(List<Movie> newItems) {
    value = [...newItems];
    notifyListeners();
  }

  void add(Movie item) {
    value.add(item);
    notifyListeners();
  }

  void remove(int itemId) {
    value.removeWhere((element) => element.id == itemId);
    notifyListeners();
  }
}
