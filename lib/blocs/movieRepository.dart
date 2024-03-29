import 'package:flutter/widgets.dart';
import 'package:tmdb_api/tmdb_api.dart';

class MovieRepository {
  TMDB tmdb = TMDB(ApiKeys('f06887531ab4c764bb245e2423a624ed', 'apiReadAccessTokenv4'));

  Future<Map> searchMovies({
    @required String movieName,
  }) async {
    Future<Map> resultData = tmdb.v3.search.queryMovies(movieName);
    return resultData;
  }

  Future<Map> getMovieDetails({
    @required int movieId,
  }) async {
    Future<Map> resultData = tmdb.v3.movies.getDetails(movieId);
    return resultData;
  }
}
