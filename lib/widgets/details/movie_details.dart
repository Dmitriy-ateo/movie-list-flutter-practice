import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/models/movie.dart';
import 'package:flutter_practice/screens/movie_screen.dart';
import '../../blocs/details/details_bloc.dart';
import '../../blocs/details/details_event.dart';
import '../../blocs/details/details_state.dart';
import '../../helpers/route_helper.dart';

const TMDB_IMAGE_PATH = "https://image.tmdb.org/t/p/w500";

class MovieDetails extends StatelessWidget {
  final int movieId;
  const MovieDetails({ Key key, this.movieId }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DetailsBloc>(context).add(
      DetailsRequested(movieId: movieId),
    );

    RouteHelper route = new RouteHelper(context);

    return Expanded(
        child: BlocBuilder<DetailsBloc, DetailsState>(
            builder: (context, state) {
              if (state is DetailsLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (state is DetailsFailure) {
                return Column(
                  children: <Widget>[
                    Icon(Icons.error),
                    SizedBox(height: 8.0),
                    Text('${state.error}'),
                  ],
                );
              }

              if (state is DetailsCompleted) {
                Movie movieDetails = state.movieDetails;
                if (movieDetails != null) {
                  return Card(
                    child: ListTile(
                      leading: movieDetails.imageUrl != null
                          ? Image.network(
                        TMDB_IMAGE_PATH + movieDetails.imageUrl,
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
                      title: Text('${movieDetails.title} (${movieDetails.year})'),
                      onTap: () {
                        route.navigateTo('/movie', MovieArguments(movieDetails.id));
                      },
                    ),
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