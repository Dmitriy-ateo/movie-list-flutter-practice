import 'package:flutter_practice/models/movie.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}
class SearchCompleted extends SearchState {
  final List<dynamic> movieList;

  const SearchCompleted({@required this.movieList});

  @override
  List<dynamic> get props => movieList;
}

class SearchLoading extends SearchState {}

class SearchFailure extends SearchState {
  final String error;

  const SearchFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SearchFailure { error: $error }';
}
