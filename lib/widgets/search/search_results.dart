import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/blocs/search/search_bloc.dart';
import 'package:flutter_practice/blocs/search/search_state.dart';
import 'package:flutter_practice/models/movie.dart';
import 'package:flutter_practice/screens/movie_screen.dart';

import '../../helpers/route_helper.dart';

const TMDB_IMAGE_PATH = "https://image.tmdb.org/t/p/w500";

class SearchResults extends StatelessWidget {
  const SearchResults({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RouteHelper route = new RouteHelper(context);

    return Expanded(
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is SearchFailure) {
            return Column(
              children: <Widget>[
                Icon(Icons.error),
                SizedBox(height: 8.0),
                Text('${state.error}'),
              ],
            );
          } 
          
          if (state is SearchCompleted) {
            List<Movie> movieList = state.movieList;
            if (movieList != null && movieList.length > 0) {
              return ListView.builder(
                itemCount: movieList.length,
                itemBuilder: (context, index) {
                  var movie = movieList[index];
                  return Card(
                    child: ListTile(
                      leading: movie.imageUrl != null
                        ? Image.network(
                            TMDB_IMAGE_PATH + movie.imageUrl,
                            width: 80,
                            height: 115,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            'images/no_image.png',
                            width: 80,
                            height: 115,
                            fit: BoxFit.contain,
                          ),
                      title: Text('${movie.title} (${movie.year})'),
                      onTap: () {
                        route.navigateTo('/movie', MovieArguments(movie.id));
                      },
                    ),
                  );
                },
              );
            }
            return Text('Sorry, but nothing found');
          }

          return Container(
            child: Center(
              child: Text('Enter movie name and tap the search icon')
            ),
          );
        }
      )
    );
  }
}