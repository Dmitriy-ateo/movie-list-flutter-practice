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

  List<Movie> toViewModel(List<dynamic> dataModelList) {
    return dataModelList
        .map(
          (dataModel) =>
          Movie(
            id: dataModel['id'],
            title: dataModel['original_title'],
            overview: dataModel['overview'],
            imageUrl: dataModel['poster_path'],
            year: getYear(dataModel['release_date']),
          ),
        )
        .toList(growable: false);
  }

  @override
  Stream<DetailsState> mapEventToState(DetailsEvent event) async* {
    if (event is DetailsButtonPressed) {
      yield DetailsLoading();

      try {
        final movieList = await movieRepository.searchMovies(
          movieName: event.movieName,
        );

        if (movieList['errors'] != null) {
          yield DetailsFailure(error: movieList['errors']);
        } else if (movieList['total_results'] > 0) {
          yield DetailsCompleted(movieList: toViewModel(movieList['results']));
        } else {
          yield DetailsFailure(error: "Nothing found");
        }
      } catch (error) {
        yield DetailsFailure(error: error.toString());
      }
    }
  }
}
