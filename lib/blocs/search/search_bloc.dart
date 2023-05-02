import 'dart:async';
import 'package:flutter_practice/blocs/movieRepository.dart';
import 'package:flutter_practice/blocs/search/search_event.dart';
import 'package:flutter_practice/blocs/search/search_state.dart';
import 'package:flutter_practice/models/movie.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MovieRepository movieRepository;

  SearchBloc({
    @required this.movieRepository,
  })  : assert(movieRepository != null);

  SearchState get initialState => SearchInitial();

  List<Movie> toViewModel(List<dynamic> dataModelList) {
    return dataModelList
        .map(
          (dataModel) =>
          Movie(
            title: dataModel['original_title'],
            overview: dataModel['overview'],
            imageUrl: dataModel['poster_path'],
          ),
        )
        .toList(growable: false);
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchButtonPressed) {
      yield SearchLoading();

      try {
        final movieList = await movieRepository.searchMovies(
          movieName: event.movieName,
        );

        if (movieList['errors'] != null) {
          yield SearchFailure(error: movieList['errors']);
        } else if (movieList['total_results'] > 0) {
          yield SearchCompleted(movieList: toViewModel(movieList['results']));
        } else {
          yield SearchFailure(error: "Nothing found");
        }
      } catch (error) {
        yield SearchFailure(error: error.toString());
      }
    }
  }
}
