import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kesakisat_mobile/blocs/player_bloc.dart';
import 'package:kesakisat_mobile/player_list.dart';
import 'package:kesakisat_mobile/result_list.dart';


import 'blocs/sport_bloc.dart';
import 'sport_list.dart';

void main() => runApp(TabBarMyApp());

class TabBarMyApp extends StatelessWidget {

  final String appName = "Kesäkisat Mobile";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            return PlayerBloc([]);
          },
        ),
        BlocProvider(
            create: (BuildContext context) {
              return SportBloc([]);
            }
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.people)),
                  Tab(icon: Icon(Icons.list)),
                  Tab(icon: Icon(Icons.flag)),
                ],
              ),
              title: Text(appName),
            ),
            body: TabBarView(
              children: [
                PlayerList(),
                SportList(),
                ResultList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}