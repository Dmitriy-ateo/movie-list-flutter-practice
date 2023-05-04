import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../models/movie.dart';

abstract class DetailsState {
  const DetailsState();

  Object get props => {};
}

class DetailsInitial extends DetailsState {}
class DetailsCompleted extends DetailsState {
  final Movie movieDetails;

  const DetailsCompleted({@required this.movieDetails});

  @override
  Movie get props => movieDetails;
}

class DetailsLoading extends DetailsState {}

class DetailsFailure extends DetailsState {
  final String error;

  const DetailsFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'DetailsFailure { error: $error }';
}
