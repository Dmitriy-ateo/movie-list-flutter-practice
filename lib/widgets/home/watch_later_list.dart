import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/screens/movie_screen.dart';
import '../../data/Database.dart';
import '../../helpers/route_helper.dart';
import '../../models/movie.dart';
import '../../models/watch_list.dart';

const TMDB_IMAGE_PATH = "https://image.tmdb.org/t/p/w500";

class WatchLaterList extends StatelessWidget {
  final SQLiteDbProvider database;
  final WatchListNotifier movieList;

  const WatchLaterList({
    Key key,
    @required this.database,
    @required this.movieList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RouteHelper route = new RouteHelper(context);

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: ValueListenableBuilder <List<Movie>>(
        valueListenable: movieList,
        builder: (context, value, child) {
          if (value.length > 0)
            return GridView.count(
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.1),
              children: value.map((movie) => (
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
            );
            return Text("Please add movie to the list");
          },
        ),
    );
  }
}
