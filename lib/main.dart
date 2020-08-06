import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Olympics',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          //visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedSport;
  int _tabIndex = 0;
  String person;
  String sport;
  String newPlayerValue;

  final sports = [
    "Tikanheitto",
    "Kävynheitto",
    "Pituushyppy",
    "Tukkihumala",
    "Tölkkikävely",
    "Kengänheitto",
    "Mölkky"
  ];

  final people = [
    "Joyce",
    "Shaunte",
    "Jeannie",
    "Vesta",
    "Cleotilde",
    "Milda",
    "Angelica",
    "Harland",
    "Faith",
    "Voncile",
    "Victoria",
    "Marlene",
    "Orval",
    "Kasey",
    "Maisha",
    "Tomasa",
    "Leisha",
    "Krysta",
    "Jamaal",
    "Robbyn",
  ];

  HashMap<String, HashMap<String, String>> scoresMap = new HashMap();

  Widget getPeople() {
    Color peopleColor = Colors.yellowAccent[500];

    return ListView.separated(
        shrinkWrap: true,
        itemCount: people.length + 1,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Column(
                children: [
                  Center(
                    child: Text(sports[_selectedSport],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.teal)
                            ),
                              hintText: "Uusi pelaaja",
                          ),
                          onChanged: (value) => {
                            print("New player value: ${value}"),
                            setState(() => {
                              newPlayerValue = value
                            })
                          },
                        )
                      ),
                      (
                        ClipRect(
                          child: Material(
                            color: Colors.white,
                            child: InkWell(
                              splashColor: Colors.red,
                              child: SizedBox(width: 130, height: 60, child: Icon(Icons.person_add)),
                              onTap: () => { print("Add player: ${newPlayerValue}") },
                            )
                          )
                        )
                      )
                    ]
                  )
                ]
            ) ;
          }
          return InkWell(
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20.0, top: 20.0),
                  height: 50,
                  color: peopleColor,
                  child: Text(
                    people[index - 1],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Spacer(),
                Expanded(
                    child: Container(
                        height: 50,
                        child: TextField(
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.teal)
                              ),
                              hintText: 'Tulos'),
                          onChanged: (value) => {
                            person = people[index - 1],
                            sport = sports[_selectedSport],
                            print(
                                "selectedSport: ${sport}, person: ${person} value: ${value}")
                          },
                        )))
              ],
            ),
            onTap: () => {print("${people[index - 1]} tapped")},
          );
        });
  }

  Widget getSports() {
    Color sportColor = Colors.grey[500];

    return ListView.separated(
      itemCount: 7,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int index) {
        if (_selectedSport != null && index == _selectedSport) {
          sportColor = Colors.green[400];
        } else {
          sportColor = Colors.grey[500];
        }
        String textString = sports[index];
        return InkWell(
            child: Container(
                height: 50,
                color: sportColor,
                child: Center(child: Text(textString))),
            onTap: () {
              setState(() => {_selectedSport = index, _tabIndex = 1});
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("${sports[index]} valittu!")));
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: _tabIndex,
        length: 3,
        child: Scaffold(
            resizeToAvoidBottomPadding: true,
            appBar: AppBar(
                bottom: TabBar(tabs: [
                  Tab(icon: Icon(Icons.list)),
                  Tab(icon: Icon(Icons.people)),
                  Tab(icon: Icon(Icons.flag))
                ]),
                title: Text("Olympics")),
            body: TabBarView(
              children: [getSports(), getPeople(), Tab(icon: Icon(Icons.flag))],
            )));
  }
}
