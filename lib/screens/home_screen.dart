import 'package:flutter/material.dart';
import 'package:flutter_practice/helpers/route_helper.dart';

import '../data/Database.dart';
import '../widgets/home/watch_later_list.dart';
import '../widgets/home/watched_list.dart';

class HomeScreen extends StatelessWidget {
  final SQLiteDbProvider database;

  const HomeScreen({Key key, @required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RouteHelper route = new RouteHelper(context);

    return WillPopScope(
      onWillPop: route.onBackPressed,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('What 2 Watch'),
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  route.navigateTo('/search', {});
                },
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: 'Watch Later'),
                Tab(text: 'Watched'),
              ],
              indicatorColor: Colors.deepOrange[50],
            ),
          ),
          body: TabBarView(
            children: [
              WatchLaterList(database: database),
              WatchedList(database: database),
            ],
          ),
        ),
      ),
    );
  }
}
