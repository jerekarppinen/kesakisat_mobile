import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kesakisat_mobile/blocs/player_bloc.dart';
import 'package:kesakisat_mobile/db/database_provider.dart';
import 'package:kesakisat_mobile/player_list.dart';
import 'package:kesakisat_mobile/result_list.dart';
import 'package:kesakisat_mobile/states/player_state.dart';

import 'blocs/sport_bloc.dart';
import 'sport_list.dart';

void main() => runApp(TabBarMyApp());

class TabBarMyApp extends StatelessWidget {
  final String appName = "Kesäkisat Mobile";

  // https://stackoverflow.com/questions/53294551/showdialog-from-root-widget
  final navigatorKey = GlobalKey<NavigatorState>();

  showInfoDialog() {
    final context = navigatorKey.currentState.overlay.context;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Info"),
        content: Text(
            "Pisteiden laskenta ottaa huomioon vain numerot, ei yksikköjä esim. m, cm, sec. \n\n"
            "Jokaisen lajin paras tulos saa aina 100 pistettä, ja järjestyksessä seuraavat aina yhden vähemmän. "
            "Samat tulokset saavat saman pistemäärän."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            return PlayerBloc(new PlayerInitialState());
          },
        ),
        BlocProvider(create: (BuildContext context) {
          return SportBloc([]);
        }),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showInfoDialog();
                  },
                ),
              ],
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
                // Inject provider instead calling from widget
                // is here just to demonstrate how to use mockito and
                // golden image tests
                PlayerList(
                  provider: DatabaseProvider.db,
                ),
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
