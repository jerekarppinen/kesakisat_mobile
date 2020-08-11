import 'package:flutter/material.dart';

import 'sport_list.dart';

class SportListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Coding with Curry')),
      body: SportList(),
    );
  }
}