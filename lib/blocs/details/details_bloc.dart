import 'dart:async';
import 'package:flutter_practice/blocs/movieRepository.dart';
import 'package:flutter_practice/models/movie.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';

import 'details_event.dart';
import 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final MovieRepository movieRepository;

  DetailsBloc({
    @required this.movieRepository,
  })  : assert(movieRepository != null);

  DetailsState get initialState => DetailsInitial();

  String getYear(String date) {
    if (date != "") {
      return DateFormat('yyyy-mm-dd').parse(date).year.toString();
    }

    return "n/a";
  }

  Movie toViewModel(Map<dynamic, dynamic> movieDetails) {
    return Movie(
            id: movieDetails['id'],
            title: movieDetails['original_title'],
            overview: movieDetails['overview'],
            imageUrl: movieDetails['poster_path'],
            year: getYear(movieDetails['release_date']),
          );
  }

  @override
  Stream<DetailsState> mapEventToState(DetailsEvent event) async* {
    if (event is DetailsRequested) {
      yield DetailsLoading();

      try {
        final movieDetails = await movieRepository.getMovieDetails(
          movieId: event.movieId,
        );

        if (movieDetails['status_code'] != null) {
          yield DetailsFailure(error: movieDetails['status_message']);
        } else if (movieDetails != null) {
          yield DetailsCompleted(movieDetails: toViewModel(movieDetails));
        } else {
          yield DetailsFailure(error: "Nothing found");
        }
      } catch (error) {
        yield DetailsFailure(error: error.toString());
      }
    }
  }
}
