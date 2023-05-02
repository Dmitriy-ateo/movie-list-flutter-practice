import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class DetailsEvent extends Equatable {
  const DetailsEvent();
}

class DetailsButtonPressed extends DetailsEvent {
  final String movieName;

  const DetailsButtonPressed({
    @required this.movieName,
  });

  @override
  List<Object> get props => [movieName];

  @override
  String toString() =>
    'DetailsButtonPressed { movieName: $movieName}';
}
