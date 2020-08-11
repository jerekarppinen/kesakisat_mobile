import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'blocs/sport_bloc.dart';
import 'sport_list.dart';

void main() => runApp(TabBarDemo());

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*
    return MaterialApp(
      title: 'Awesome title',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.list)),
                  Tab(icon: Icon(Icons.people)),
                  Tab(icon: Icon(Icons.flag)),
                ]
            ),
            title: Text('Pankajärvi Olympics'),
          ),
          body: TabBarView(
            children: [
              BlocProvider<SportBloc>(
                create: (context) => SportBloc(),
                child: SportList(),
              ),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      )
    );

     */

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SportBloc(),
        )
      ],
      child: MaterialApp(
        title: 'Sqflite Tutorial',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.list)),
                  Tab(icon: Icon(Icons.people)),
                  Tab(icon: Icon(Icons.flag)),
                ],
              ),
              title: Text('Pankajärvi Olympics'),
            ),
            body: TabBarView(
              children: [
                SportList(),
                Icon(Icons.directions_transit),
                Icon(Icons.directions_bike),
              ],
            ),
          ),
        ),
      ),
    );
  }
}