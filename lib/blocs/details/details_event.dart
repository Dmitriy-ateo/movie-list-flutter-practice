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
