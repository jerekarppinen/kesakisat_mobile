import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kesakisat_mobile/main.dart';

void main() {
  testWidgets("Renders players screen by default", (WidgetTester tester) async {
    await tester.pumpWidget(new TabBarMyApp());

    expect(find.text("Pelaajat"), findsOneWidget);

    expect(find.widgetWithIcon(Tab, Icons.people), findsOneWidget);
    expect(find.widgetWithIcon(Tab, Icons.list), findsOneWidget);
    expect(find.widgetWithIcon(Tab, Icons.flag), findsOneWidget);

    expect(find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
  });
}