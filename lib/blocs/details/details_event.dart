import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class DetailsEvent extends Equatable {
  const DetailsEvent();
}

class DetailsRequested extends DetailsEvent {
  final int movieId;

  const DetailsRequested({
    @required this.movieId,
  });

  @override
  List<Object> get props => [movieId];

  @override
  String toString() =>
    'DetailsRequested { movieId: $movieId }';
}

class AddMovieToWatchList extends DetailsEvent {
  final int movieId;

  const AddMovieToWatchList({
    @required this.movieId,
  });

  @override
  List<Object> get props => [movieId];

  @override
  String toString() =>
      'DetailsRequested { movieId: $movieId }';
}

class RemoveMovieFromWatchList extends DetailsEvent {
  final int movieId;

  const RemoveMovieFromWatchList({
    @required this.movieId,
  });

  @override
  List<Object> get props => [movieId];

  @override
  String toString() =>
      'DetailsRequested { movieId: $movieId }';
}

class AddMovieToWatchedList extends DetailsEvent {
  final int movieId;

  const AddMovieToWatchedList({
    @required this.movieId,
  });

  @override
  List<Object> get props => [movieId];

  @override
  String toString() =>
      'DetailsRequested { movieId: $movieId }';
}

class RemoveMovieFromWatchedList extends DetailsEvent {
  final int movieId;

  const RemoveMovieFromWatchedList({
    @required this.movieId,
  });

  @override
  List<Object> get props => [movieId];

  @override
  String toString() =>
      'DetailsRequested { movieId: $movieId }';
}
