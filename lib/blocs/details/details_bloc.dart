import 'dart:async';
import 'package:flutter_practice/blocs/movieRepository.dart';
import 'package:flutter_practice/models/movie.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/Database.dart';
import '../../models/watch_list.dart';
import 'details_event.dart';
import 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final MovieRepository movieRepository;
  final SQLiteDbProvider database;

  DetailsBloc({
    @required this.movieRepository,
    @required this.database
  })  : assert((movieRepository != null) && (database != null));

  DetailsState get initialState => DetailsInitial();

  String getYear(String date) {
    if (date != "") {
      return DateFormat('yyyy-mm-dd').parse(date).year.toString();
    }

    return "n/a";
  }

  Movie toViewModel(Map<dynamic, dynamic> movieDetails) {
    var countries = movieDetails['production_countries'];
    return Movie(
            id: movieDetails['id'],
            title: movieDetails['original_title'],
            overview: movieDetails['overview'],
            imageUrl: movieDetails['poster_path'],
            year: getYear(movieDetails['release_date']),
            country: countries.length > 0 ? countries[0]['name'] : "n/a",
            rate: movieDetails['vote_average'],
            rateCount: movieDetails['vote_count'],
          );
  }

  Movie _movieDetails = new Movie();
  Movie get movieDetails => _movieDetails;

  @override
  Stream<DetailsState> mapEventToState(DetailsEvent event) async* {
    if (event is DetailsRequested) {
      yield DetailsLoading();

      try {
        final prefs = await SharedPreferences.getInstance();
        var _addedToWatchList = (prefs.getStringList('addedToWatch') ?? []);
        var _watchedList = (prefs.getStringList('watched') ?? []);

        final movieDetails = await movieRepository.getMovieDetails(
          movieId: event.movieId,
        );

        if (movieDetails['status_code'] != null) {
          yield DetailsFailure(error: movieDetails['status_message']);
        } else if (movieDetails != null) {
          _movieDetails = toViewModel(movieDetails);
          _movieDetails.setAddedToWatch = _addedToWatchList.contains(event.movieId.toString());
          _movieDetails.setIsWatched = _watchedList.contains(event.movieId.toString());
          yield DetailsCompleted(movieDetails: _movieDetails);
        } else {
          yield DetailsFailure(error: "Nothing found");
        }
      } catch (error) {
        yield DetailsFailure(error: error.toString());
      }
    }

    if (event is AddMovieToWatchedList) {
      try {
        final prefs = await SharedPreferences.getInstance();
        var _watchedList = (prefs.getStringList('watched') ?? []);
        if (!_watchedList.contains(event.movieId.toString())) {
          await database.addToWatchedList(_movieDetails);
          _watchedList.add(event.movieId.toString());
          prefs.setStringList('watched', _watchedList);
        }
        _movieDetails.setIsWatched = _watchedList.contains(event.movieId.toString());
        yield DetailsCompleted(movieDetails: _movieDetails);
      } catch (error) {
        yield DetailsFailure(error: error.toString());
      }
    }

    if (event is RemoveMovieFromWatchedList) {
      try {
        final prefs = await SharedPreferences.getInstance();
        var _watchedList = (prefs.getStringList('watched') ?? []);

        await database.removeFromWatchedList(event.movieId);
        if (_watchedList.contains(event.movieId.toString())) {
          _watchedList.removeWhere((str){
            return str == event.movieId.toString();
          });
          prefs.setStringList('watched', _watchedList);
        }
        _movieDetails.setIsWatched = _watchedList.contains(event.movieId.toString());
        yield DetailsCompleted(movieDetails: _movieDetails);
      } catch (error) {
        yield DetailsFailure(error: error.toString());
      }
    }

    if (event is AddMovieToWatchList) {
      try {
        final prefs = await SharedPreferences.getInstance();
        var _addedToWatchList = (prefs.getStringList('addedToWatch') ?? []);
        await database.addToWatchList(_movieDetails);
        if (!_addedToWatchList.contains(event.movieId.toString())) {
          _addedToWatchList.add(event.movieId.toString());
          prefs.setStringList('addedToWatch', _addedToWatchList);
        }
        _movieDetails.setAddedToWatch = _addedToWatchList.contains(event.movieId.toString());
        yield DetailsCompleted(movieDetails: _movieDetails);
      } catch (error) {
        yield DetailsFailure(error: error.toString());
      }
    }

    if (event is RemoveMovieFromWatchList) {
      try {
        final prefs = await SharedPreferences.getInstance();
        var _addedToWatchList = (prefs.getStringList('addedToWatch') ?? []);
        await database.removeFromWatchList(event.movieId);
        if (_addedToWatchList.contains(event.movieId.toString())) {
          _addedToWatchList.removeWhere((str){
            return str == event.movieId.toString();
          });
          prefs.setStringList('addedToWatch', _addedToWatchList);
        }
        _movieDetails.setAddedToWatch = _addedToWatchList.contains(event.movieId.toString());
        yield DetailsCompleted(movieDetails: _movieDetails);
      } catch (error) {
        yield DetailsFailure(error: error.toString());
      }
    }
  }
}
