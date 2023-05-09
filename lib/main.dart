import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/blocs/movieRepository.dart';
import 'package:flutter_practice/blocs/simple_bloc_delegate.dart';
import 'package:flutter_practice/models/watch_list.dart';
import 'package:flutter_practice/models/watched_list.dart';
import 'package:flutter_practice/screens/home_screen.dart';
import 'package:flutter_practice/screens/movie_screen.dart';
import 'package:flutter_practice/screens/search_screen.dart';
import 'package:provider/provider.dart';

import 'data/Database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  BlocSupervisor.delegate = SimpleBlocDelegate();
  final movieRepository = MovieRepository();
  final database = SQLiteDbProvider.db;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WatchListNotifier()),
        ChangeNotifierProvider(create: (context) => WatchedListNotifier()),
      ],
      child: MyApp(movieRepository: movieRepository, database: database),
    ),
  );
}

class MyApp extends StatefulWidget {
  final MovieRepository movieRepository;
  final SQLiteDbProvider database;
  const MyApp({Key key, @required this.movieRepository, @required this.database}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepOrange[900],
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(database: widget.database),
        '/search': (context) => SearchScreen(movieRepository: widget.movieRepository),
        '/movie': (context) => MovieScreen(movieRepository: widget.movieRepository, database: widget.database),
      },
    );
  }
}
