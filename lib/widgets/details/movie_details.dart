import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../blocs/details/details_bloc.dart';
import '../../blocs/details/details_event.dart';
import '../../blocs/details/details_state.dart';

const TMDB_IMAGE_PATH = "https://image.tmdb.org/t/p/w500";

class MovieDetails extends StatefulWidget {
  const MovieDetails({ Key key, this.movieId });

  final int movieId;
  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<String> _selectedMovies = [];

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white,
    minimumSize: const Size.fromHeight(40),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(6.0)),
    ),
  );

  @override
  void initState() {
    super.initState();
    _getMovieDetails();
  }

  Future<void> _getMovieDetails() async {
    BlocProvider.of<DetailsBloc>(context).add(
      DetailsRequested(movieId: widget.movieId),
    );
  }

  Future<void> _addMovieToWatchList() async {
    BlocProvider.of<DetailsBloc>(context).add(
      AddMovieToWatchList(movieId: widget.movieId),
    );
  }

  Future<void> _removeMovieFromWatchList() async {
    BlocProvider.of<DetailsBloc>(context).add(
      RemoveMovieFromWatchList(movieId: widget.movieId),
    );
  }

  Future<void> _addMovieToWatchedList() async {
    BlocProvider.of<DetailsBloc>(context).add(
      AddMovieToWatchedList(movieId: widget.movieId),
    );
  }

  Future<void> _removeMovieFromWatchedList() async {
    BlocProvider.of<DetailsBloc>(context).add(
      RemoveMovieFromWatchedList(movieId: widget.movieId),
    );
  }

  Future<void> _removeMovieLists() async {
    await _removeMovieFromWatchList();
    await _removeMovieFromWatchedList();
  }

  Future<void> _setAddedToWatch() async {
    await _addMovieToWatchList();
    await _removeMovieFromWatchedList();
  }

  Future<void> _setWatched() async {
    await _addMovieToWatchedList();
    await _removeMovieFromWatchList();
  }

  @override
  Widget build(BuildContext context) {
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
                  return Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Column(
                                    children: [
                                      movieDetails.imageUrl != null
                                        ? CachedNetworkImage(
                                            imageUrl: TMDB_IMAGE_PATH + movieDetails.imageUrl,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'images/no_image.png',
                                            fit: BoxFit.cover,
                                        ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 16.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(movieDetails.title, textAlign: TextAlign.start, style: TextStyle(fontSize: 21.0)),
                                        SizedBox(height: 8.0),
                                        Text('${movieDetails.country}, ${movieDetails.year}', textAlign: TextAlign.start,),
                                        SizedBox(height: 8.0),
                                        Text('${movieDetails.rate}/10 (${movieDetails.rateCount} votes)', textAlign: TextAlign.start,),
                                        SizedBox(height: 8.0),
                                        Container(
                                          child: FilledButton(
                                            style: flatButtonStyle,
                                            child: Text(
                                              (movieDetails.isAddedToWatch != null && movieDetails.isAddedToWatch)
                                                  ? 'Already Watched'
                                                  : 'Add to Watch List',
                                              style: TextStyle(fontSize: 14.0),
                                            ),
                                            onPressed: (movieDetails.isAddedToWatch != null && movieDetails.isAddedToWatch)
                                                ? _setWatched
                                                : _setAddedToWatch,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        if ((movieDetails.isAddedToWatch != null && movieDetails.isAddedToWatch)
                                            || (movieDetails.isWatched != null && movieDetails.isWatched))  ...[
                                          Container(
                                            child: FilledButton(
                                              style: flatButtonStyle,
                                              child: Text('Remove', style: TextStyle(fontSize: 14.0)),
                                              onPressed: _removeMovieLists,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Text("Overview: ", textAlign: TextAlign.start, style: TextStyle(fontSize: 21.0)),
                            SizedBox(height: 8.0),
                            Text(movieDetails.overview, textAlign: TextAlign.start),
                          ]
                      )
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
