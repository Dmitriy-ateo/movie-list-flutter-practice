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

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final movieRepository = MovieRepository();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WatchList()),
        ChangeNotifierProvider(create: (context) => WatchedList()),
      ],
      child: MyApp(movieRepository: movieRepository),
    ),
  );
}

class MyApp extends StatefulWidget {
  final MovieRepository movieRepository;
  const MyApp({Key key, @required this.movieRepository}) : super(key: key);

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
        '/home': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(movieRepository: widget.movieRepository),
        '/movie': (context) => MovieScreen(),
      },
    );
  }
}
