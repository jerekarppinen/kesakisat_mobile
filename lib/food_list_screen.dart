import 'package:flutter/material.dart';

import 'sport_list.dart';

class sportListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Coding with Curry')),
      body: SportList(),
    );
  }
}