import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/screens/movie_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/Database.dart';
import '../../helpers/route_helper.dart';
import '../../models/movie.dart';

const TMDB_IMAGE_PATH = "https://image.tmdb.org/t/p/w500";

class WatchedList extends StatefulWidget {
  final SQLiteDbProvider database;

  const WatchedList({Key key, @required this.database}) : super(key: key);

  @override
  State<WatchedList> createState() => _WatchedListState();
}

class _WatchedListState extends State<WatchedList> {
  Future<List<Movie>> _watchedList;

  @override
  void initState() {
    super.initState();
    _loadWatchedList();
  }

  //Loading counter value on start
  Future<void> _loadWatchedList() async {
    setState(() {
      _watchedList = widget.database.getWatchedList();
    });
  }

  @override
  Widget build(BuildContext context) {
    RouteHelper route = new RouteHelper(context);
    return FutureBuilder <List<Movie>>(
      future: _watchedList,
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return Text('Loading....');
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            // Text('Result: ${snapshot.data}');
            else if (snapshot.data.length > 0) {
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: GridView.count(
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.1),
                  children: snapshot.data.map((movie) => (
                    GestureDetector(
                      onTap: () {
                        route.navigateTo('/movie', MovieArguments(movie.id));
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                movie.imageUrl != null
                                    ? CachedNetworkImage(
                                  imageUrl: TMDB_IMAGE_PATH + movie.imageUrl,
                                  fit: BoxFit.fill,
                                )
                                    : Image.asset(
                                  'images/no_image.png',
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 8.0),
                                Expanded(
                                  child: Text('${movie.title} (${movie.year})')
                                ),
                              ],
                            )
                          ),
                        ],
                      )
                    )
                  )).toList(),
                )
              );
            } else return Center(
              child: Text('No Results'),
            );
        }
      },
    );
  }
}