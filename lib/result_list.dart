import 'package:flutter/material.dart';

class ResultList extends StatefulWidget {
  const ResultList({Key key}) : super(key: key);

  @override
  _ResultListState createState() => _ResultListState();
}

class _ResultListState extends State<ResultList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tulokset")),
      body: Container(
        child: Text("Tuloksia!")
      ),
    );
  }
}