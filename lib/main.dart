import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/blocs/movieRepository.dart';
import 'package:flutter_practice/blocs/simple_bloc_delegate.dart';
import 'package:flutter_practice/screens/home_screen.dart';
import 'package:flutter_practice/screens/movie_screen.dart';
import 'package:flutter_practice/screens/search_screen.dart';

import 'data/Database.dart';
import 'models/movie.dart';
import 'models/watch_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  BlocSupervisor.delegate = SimpleBlocDelegate();
  final movieRepository = MovieRepository();
  final database = SQLiteDbProvider.db;

  runApp(
    MyApp(movieRepository: movieRepository, database: database),
  );
}

class MyApp extends StatefulWidget {
  final MovieRepository movieRepository;
  final SQLiteDbProvider database;

  const MyApp({
    Key key,
    @required this.movieRepository,
    @required this.database
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WatchListNotifier _watchLaterList = WatchListNotifier([]);
  WatchListNotifier _watchedList = WatchListNotifier([]);

  @override
  void initState() {
    super.initState();
    _loadWatchLaterList();
    _loadWatchedList();
  }

  Future<void> _loadWatchLaterList() async {
    List<Movie> movies = await widget.database.getWatchList();
    _watchLaterList.setItems(movies);
  }

  Future<void> _loadWatchedList() async {
    List<Movie> movies = await widget.database.getWatchedList();
    _watchedList.setItems(movies);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepOrange[900],
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(
            database: widget.database,
            watchLaterList: _watchLaterList,
            watchedList: _watchedList,
        ),
        '/search': (context) => SearchScreen(
            movieRepository: widget.movieRepository
        ),
        '/movie': (context) => MovieScreen(
            movieRepository: widget.movieRepository,
            database: widget.database,
            watchLaterList: _watchLaterList,
            watchedList: _watchedList,
        ),
      },
    );
  }
}
