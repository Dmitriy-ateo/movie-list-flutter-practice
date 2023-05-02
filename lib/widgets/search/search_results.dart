import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/blocs/search/search_bloc.dart';
import 'package:flutter_practice/blocs/search/search_state.dart';
import 'package:flutter_practice/models/movie.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  return ListTile(
                    title: Text('${movie.title} (${movie.year})'),
                    onTap: () {},
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