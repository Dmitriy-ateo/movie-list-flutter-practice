import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchButtonPressed extends SearchEvent {
  final String movieName;

  const SearchButtonPressed({
    @required this.movieName,
  });

  @override
  List<Object> get props => [movieName];

  @override
  String toString() =>
    'SearchButtonPressed { movieName: $movieName}';
}
