import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/blocs/details/details_bloc.dart';
import '../blocs/movieRepository.dart';
import '../widgets/details/movie_details.dart';

class MovieArguments {
  final int movieId;
  MovieArguments(this.movieId);
}

class MovieScreen extends StatelessWidget {
  final MovieRepository movieRepository;

  const MovieScreen({Key key, @required this.movieRepository }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as MovieArguments;

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Movie Details'),
        ),
        body: BlocProvider(
          create: (context) {
            return DetailsBloc(
              movieRepository: movieRepository,
            );
          },
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
                child: Column(
                  children: <Widget>[
                    MovieDetails(movieId: args.movieId),
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}