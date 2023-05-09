import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/movie.dart';

class SQLiteDbProvider {
  SQLiteDbProvider._();
  static final SQLiteDbProvider db = SQLiteDbProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    print("CREATING DB");
    return await openDatabase(
        join(await getDatabasesPath(), 'movie_database.db'),
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
            "CREATE TABLE WatchList ("
              "id INTEGER PRIMARY KEY,"
              "title TEXT,"
              "country TEXT,"
              "year TEXT,"
              "overview TEXT,"
              "imageUrl TEXT,"
              "rate REAL,"
              "rateCount INTEGER"
            ")"
          );
          await db.execute(
            "CREATE TABLE WatchedList ("
              "id INTEGER PRIMARY KEY,"
              "title TEXT,"
              "country TEXT,"
              "year TEXT,"
              "overview TEXT,"
              "imageUrl TEXT,"
              "rate REAL,"
              "rateCount INTEGER"
            ")"
          );
        }
    );
  }

  Future<List<Movie>> getWatchList() async {
    final db = await database;
    List<Map> results = await db.query(
        "WatchList", columns: Movie.columns, orderBy: "id ASC"
    );
    List<Movie> movies = [];
    results.forEach((result) {
      Movie movie = Movie.fromMap(result);
      movies.add(movie);
    });
    return movies;
  }

  Future<List<Movie>> getWatchedList() async {
    final db = await database;
    List<Map> results = await db.query(
        "WatchedList", columns: Movie.columns, orderBy: "id ASC"
    );
    List<Movie> movies = [];
    results.forEach((result) {
      Movie movie = Movie.fromMap(result);
      movies.add(movie);
    });
    return movies;
  }

  Future<Movie> getMovieById(int id) async {
    final db = await database;
    var result = await db.query("Movie", where: "id = ", whereArgs: [id]);
    return result.isNotEmpty ? Movie.fromMap(result.first) : Null;
  }

  addToWatchList(Movie movie) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT Into WatchList (id, title, country, year, overview, imageUrl)"
            " VALUES (?, ?, ?, ?, ?, ?)",
        [movie.id, movie.title, movie.country, movie.year, movie.overview, movie.imageUrl]
    );
    print("ADDING MOVIE TO DB: ");
    print(result);
    return result;
  }

  removeFromWatchList(int id) async {
    print("REMOVING MOVIE FROM DB: ");
    print(id);

    final db = await database;
    db.delete("WatchList", where: "id = ?", whereArgs: [id]);
  }

  addToWatchedList(Movie movie) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT Into WatchedList (id, title, country, year, overview, imageUrl)"
            " VALUES (?, ?, ?, ?, ?, ?)",
        [movie.id, movie.title, movie.country, movie.year, movie.overview, movie.imageUrl]
    );
    print("ADDING MOVIE TO DB: ");
    print(result);
    return result;
  }

  removeFromWatchedList(int id) async {
    print("REMOVING MOVIE FROM DB: ");
    print(id);

    final db = await database;
    db.delete("WatchedList", where: "id = ?", whereArgs: [id]);
  }
}
