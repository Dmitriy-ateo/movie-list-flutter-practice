import 'package:flutter/material.dart';
import 'package:flutter_practice/helpers/route_helper.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RouteHlpr route = new RouteHlpr(context);

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
                  route.navigateTo('/search');
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
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}
