import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/blocs/movieRepository.dart';
import 'package:flutter_practice/blocs/search/search_bloc.dart';
import 'package:flutter_practice/widgets/search/search_field.dart';
import 'package:flutter_practice/widgets/search/search_results.dart';

class SearchScreen extends StatelessWidget {
  final MovieRepository movieRepository;
  const SearchScreen({Key key, @required this.movieRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search movie'),
        ),
        body: BlocProvider(
          create: (context) {
            return SearchBloc(
              movieRepository: movieRepository,
            );
          },
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  SearchField(),
                  SearchResults(),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}