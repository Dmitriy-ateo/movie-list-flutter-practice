import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class DetailsState extends Equatable {
  const DetailsState();

  @override
  List<Object> get props => [];
}

class DetailsInitial extends DetailsState {}
class DetailsCompleted extends DetailsState {
  final List<dynamic> movieList;

  const DetailsCompleted({@required this.movieList});

  @override
  List<dynamic> get props => movieList;
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
